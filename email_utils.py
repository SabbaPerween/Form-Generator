import os
import smtplib
import ssl
from email.message import EmailMessage
import logging
from socket import gaierror, timeout

logger = logging.getLogger(__name__)

def send_otp_email(recipient_email: str, otp: str) -> bool:
    """
    Sends an OTP to the user's email address with enhanced error handling and debug output.
    This function reads SMTP configuration from environment variables.
    """

    # --- Step 1: Read Configuration from Environment Variables ---
    smtp_server = os.getenv("SMTP_SERVER")
    sender_user = os.getenv("SENDER_USER")
    sender_password = os.getenv("SENDER_PASSWORD")
    
    try:
        smtp_port = int(os.getenv("SMTP_PORT", 587))
    except (ValueError, TypeError):
        # This error is critical and indicates a misconfigured .env file.
        print("CRITICAL ERROR: SMTP_PORT in your .env file is not a valid number. It must be an integer like 587 or 465.")
        logger.critical("Invalid SMTP_PORT in environment variables.")
        return False

    # --- Step 2: Print Debug Info and Validate Configuration ---
    # This helps the user diagnose the problem from their terminal output.
    print("\n--- SMTP Email Debug Information ---")
    print(f"SMTP Server: {smtp_server}")
    print(f"SMTP Port: {smtp_port}")
    print(f"Sender User/Email: {sender_user}")
    print(f"Sender Password Provided: {'Yes' if sender_password else 'No'}")
    print("------------------------------------\n")

    if not all([smtp_server, sender_user, sender_password]):
        print("CRITICAL ERROR: One or more required SMTP environment variables are missing.")
        print("Please ensure SMTP_SERVER, SENDER_USER, and SENDER_PASSWORD are all set in your .env file.")
        logger.critical("Missing one or more SMTP environment variables.")
        return False

    # --- Step 3: Construct the Email Message ---
    msg = EmailMessage()
    msg['Subject'] = "Your Password Reset Code"
    msg['From'] = sender_user
    msg['To'] = recipient_email
    msg.set_content(
        f"""
        Hello,
        Your one-time password (OTP) is: {otp}
        This code is valid for 10 minutes.
        If you did not request this, please ignore this email.
        Thank you,
        The Form Generator Team
        """
    )

    # --- Step 4: Connect to SMTP Server and Send Email ---
    try:
        # Create a secure SSL context.
        context = ssl.create_default_context()
        
        # The connection method depends on the port.
        # Port 465 uses SMTP_SSL (implicit SSL from the start).
        # Port 587 (and others) use standard SMTP and are upgraded to TLS with server.starttls().
        if smtp_port == 465:
            print(f"Attempting to connect to {smtp_server}:{smtp_port} using SMTP_SSL...")
            with smtplib.SMTP_SSL(smtp_server, smtp_port, context=context, timeout=15) as server:
                print("SSL Connection successful. Attempting to log in...")
                server.login(sender_user, sender_password)
                print("Login successful. Sending email...")
                server.send_message(msg)
                print("Email sent successfully via SMTP_SSL.")
        else:
            print(f"Attempting to connect to {smtp_server}:{smtp_port} using standard SMTP...")
            with smtplib.SMTP(smtp_server, smtp_port, timeout=15) as server:
                print("Connection successful. Upgrading to secure (TLS) connection...")
                server.starttls(context=context)
                print("Connection secured. Attempting to log in...")
                server.login(sender_user, sender_password)
                print("Login successful. Sending email...")
                server.send_message(msg)
                print("Email sent successfully via STARTTLS.")
        
        logger.info(f"OTP email sent successfully to {recipient_email}")
        return True

    # --- Step 5: Handle Specific Errors with User-Friendly Advice ---
    except smtplib.SMTPAuthenticationError as e:
        print("--- CRITICAL: SMTP AUTHENTICATION FAILED ---")
        print(f"The email server rejected the login credentials. Server response: {e}")
        print("\nCommon Causes & Solutions:")
        print("1. Incorrect SENDER_USER or SENDER_PASSWORD in your .env file.")
        print("2. If using Gmail/Google Workspace, you MUST use an 'App Password', not your regular password. See instructions below.")
        print("3. Some email providers require the SENDER_USER to be the full email address (e.g., 'user@example.com').")
        
        if smtp_server and "gmail.com" in smtp_server.lower():
            print("\n--- GMAIL-SPECIFIC HELP ---")
            print("You are using a Gmail server. This error almost always means you need an App Password.")
            print("1. Go to your Google Account security settings: https://myaccount.google.com/security")
            print("2. Make sure 2-Step Verification is ON for your account.")
            print("3. Under 'Signing in to Google', click on 'App passwords'.")
            print("4. Generate a new 16-character password and use that for the SENDER_PASSWORD in your .env file.")
            print("---------------------------\n")
            
        logger.error("SMTP Authentication Failed.", exc_info=True)
        return False
        
    except (smtplib.SMTPConnectError, ConnectionRefusedError, gaierror, timeout) as e:
        print("--- CRITICAL: SMTP CONNECTION FAILED ---")
        print(f"The application could not connect to the SMTP server at '{smtp_server}:{smtp_port}'.")
        print(f"Error details: {e}")
        print("\nCommon Causes & Solutions:")
        print("1. Incorrect SMTP_SERVER or SMTP_PORT in your .env file.")
        print("2. A firewall on your computer or network is blocking the connection to the port.")
        print("3. The SMTP server is down or not accessible from your network.")
        print("4. A typo in the server name (DNS lookup failed).")
        logger.error("SMTP Connection Failed.", exc_info=True)
        return False
        
    except Exception as e:
        print(f"--- CRITICAL: AN UNEXPECTED ERROR OCCURRED ---")
        print(f"An unknown error happened during the email sending process: {e}")
        logger.error("An unexpected error occurred while sending email.", exc_info=True)
        return False