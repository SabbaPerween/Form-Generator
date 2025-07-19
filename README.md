# Dynamic Form Generator with Admin Dashboard & Data Analytics Platform
![Python Version](https://img.shields.io/badge/python-3.9+-blue.svg)
![Framework](https://img.shields.io/badge/framework-Streamlit-red)
![Database](https://img.shields.io/badge/database-PostgreSQL-blue)
![License](https://img.shields.io/badge/license-MIT-green)

This is a comprehensive web application built with Streamlit that allows users with different roles to dynamically create forms, share them, fill them out, and analyze the submitted data through an interactive dashboard.

### Table of Contents
*   [Overview](#overview)
*   [Project Philosophy](#project-philosophy)
*   [Core Features](#core-features)
*   [Technology Stack](#technology-stack)
*   [System Architecture](#system-architecture)
*   [Getting Started](#getting-started)
*   [Troubleshooting](#troubleshooting)
*   [Usage](#usage)
*   [Future Work](#future-work)
*   [License](#license)

---

## Overview

This project solves the challenge of creating and managing custom data collection forms in a secure, multi-user environment. It moves beyond static forms by providing a complete lifecycle management tool: from AI-assisted creation and database schema generation to a powerful administrative backend for data filtering, visualization, and export.

## Project Philosophy

The development of this platform is guided by four core principles:

*   **Security First:** Every feature, from authentication to database interaction, is designed with security as the foremost priority. We use industry-standard practices for password hashing, SQL query parameterization, and access control.
*   **Seamless User Experience:** The interface, powered by Streamlit, is designed to be intuitive for all user roles. Complex actions like database table creation or AI integration are abstracted behind simple UI components.
*   **Scalable Architecture:** The relational database schema and modular code structure are designed to handle a growing number of forms, submissions, and users without significant refactoring.
*   **Developer-Friendly & Maintainable:** With a clear separation of concerns (`app.py`, `db.py`, `form_utils.py`), comprehensive documentation, and adherence to best practices, the codebase is easy to understand, maintain, and extend.

## Core Features

### User & Access Management
*   **Secure Authentication:** Comprehensive login, registration, and password reset system. Users can authenticate with a username, email, or phone number.
*   **OTP Password Reset:** Secure, time-sensitive One-Time Password (OTP) system delivered via SMTP for password recovery.
*   **Role-Based Access Control (RBAC):**
    *   **Admin:** Full control over all forms, data, users, and system health.
    *   **Editor:** Can create, edit, and view specific forms.
    *   **Viewer:** Can only view and submit data to assigned forms.

### Form Lifecycle
*   **Dynamic Form Creation:** Intuitive UI to build forms with over 15 field types, including text, numbers, dates, file uploads, and complex selections.
*   **AI-Powered Field Generation:** Describe a form's purpose in natural language (e.g., "a patient intake form") and have the AI (Ollama/Llama2) instantly generate the corresponding JSON field structure.
*   **Automatic Database Management:** Creating a form automatically generates and manages a corresponding, strongly-typed PostgreSQL table.
*   **Advanced Form Relationships:**
    *   **Parent-Child Links:** Establish hierarchies between forms (e.g., link "Students" to a "School").
    *   **Child-to-Child Links:** Create relationships between records from different child forms under the same parent (e.g., link a "Teacher" record to a "Student" record).

### Data Intelligence & Sharing
*   **Public Sharing:** Generate unique, secure URLs to share forms publicly for data collection.
*   **Embeddable Forms:** Generate `<iframe>` code to embed forms into other websites.
*   **Interactive Analytics Dashboard:**
    *   Dynamically filter data by any field (e.g., age, gender, class).
    *   Visualize data with interactive charts and graphs from Plotly.
    *   View Key Performance Indicators (KPIs) and submission trends over time.
    *   Explore relationships between numeric fields with scatter plots and correlation heatmaps.
*   **Data Export:** Download filtered data in CSV, PDF, and Excel formats.

### System Administration
*   **User Management Panel:** Admins can create, delete, and modify user roles and reset passwords.
*   **System Health Dashboard:** Tools to diagnose and repair broken form relationships and clean up "orphan" records (metadata without a corresponding data table).

## Technology Stack

| Category      | Technology                               |
|---------------|------------------------------------------|
| **Frontend**  | Streamlit, Plotly                        |
| **Backend**   | Python                                   |
| **Database**  | PostgreSQL                               |
| **AI**        | Ollama (Llama 2)                         |
| **Data Tools**| Pandas                                   |
| **Security**  | Werkzeug (Password Hashing)              |
| **Reports**   | FPDF2 (PDFs), OpenPyXL (Excel)           |

## System Architecture

For a detailed technical blueprint, including the database schema and component responsibilities, please see the [**ARCHITECTURE.md**](ARCHITECTURE.md) file.

## Getting Started

Follow these instructions to set up and run the project locally.

### Prerequisites
*   Python 3.9+
*   PostgreSQL (v12 or higher)
*   Ollama installed and serving a model (e.g., `ollama run llama2`)

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd <repository-folder>
```
. git clone ...: This command uses git (a version control system) to download a complete copy of your project's code from its online repository (like GitHub) to the user's local machine.
. cd ...: This stands for "change directory". It moves the terminal's focus into the newly created project folder so the subsequent commands are run in the correct place.
### 2. Creating a Virtual Environment
This is a critical best practice in Python development.
```bash
# For MacOS/Linux
python3 -m venv venv
source venv/bin/activate
```
* python3 -m venv venv: This command tells Python to run its built-in venv module. It creates a new, isolated "virtual environment" in a folder named venv.
Why? This prevents package conflicts. The libraries needed for your project (like Streamlit, Pandas, etc.) will be installed inside this venv folder and won't interfere with other Python projects on the user's computer.

* source venv/bin/activate: This command "activates" the virtual environment. It tells the terminal that for this session, any Python-related commands (like python and pip) should use the versions inside the venv folder, not the system-wide ones.
```bash
# For Windows
python -m venv venv
.\venv\Scripts\activate
```
* The logic is the same, but the path to the activation script uses backslashes (\) instead of forward slashes (/).
### 3. Installing Dependencies
```bash
pip install -r requirements.txt
```
* pip: This is Python's package installer.
* install -r requirements.txt: This command tells pip to read the requirements.txt file. It will then go through every library listed in that file (e.g., streamlit, pandas, psycopg2-binary) and download and install the correct versions into the currently active virtual environment.
### 4. Configure Environment Variables
Create a file named .env in the root of your project and add the following, replacing the placeholder values with your actual credentials.
```bash
# --- DATABASE CONFIGURATION ---
DB_NAME=form_generator
DB_USER=your_postgres_user
DB_PASSWORD=your_super_secret_password
DB_HOST=localhost
DB_PORT=5432

# --- SMTP EMAIL CONFIGURATION (for Password Reset) ---
# For Gmail, you MUST use a 16-digit "App Password".
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SENDER_USER=your.email@gmail.com
SENDER_PASSWORD=your_gmail_app_password

# --- APPLICATION CONFIGURATION ---
# The base URL where your app is running.
BASE_URL=http://localhost:8501
```

### 5. Running the Application
``` bash
streamlit run app.py
```
* This is the final command. It uses the streamlit library (which was just installed) to start a local web server and run your app.py script. It will then print a URL (like http://localhost:8501) that the user can open in their web browser to see and interact with your application.

### 6. Troubleshooting

*   **PostgreSQL Connection Error:** If the app fails to start with a database connection error, double-check that your `DB_USER`, `DB_PASSWORD`, `DB_HOST`, and `DB_PORT` in the `.env` file are correct and that the PostgreSQL server is running.

*   **`psycopg2` Installation Failure:** If `pip install` fails on `psycopg2-binary`, you may be missing the necessary PostgreSQL development headers.
    *   On **Debian/Ubuntu**: `sudo apt-get install libpq-dev`
    *   On **macOS (with Homebrew)**: `brew install postgresql`
    *   On **Fedora/CentOS**: `sudo dnf install libpq-devel`

*   **Ollama/AI Feature Errors:** If AI features are failing, ensure Ollama is running in the background. You can verify this by opening a new terminal and running `ollama run llama2`.

*   **Password Reset Email Fails:** If you see an `SMTPAuthenticationError`, especially with a Gmail account, it almost certainly means you need to use a 16-digit **App Password**, not your regular account password. Follow Google's instructions to generate one.

# Usage
1. Navigate to http://localhost:8501 in your web browser.
2. Register a new account or use the pre-seeded default accounts:
Admin: admin / admin123
Editor: editor / editor123
Viewer: viewer / viewer123
3. Use the sidebar navigation to explore the application's features based on your user role.

# Future Work
This platform provides a solid foundation. Future enhancements could include:
* REST API: Expose an API for programmatic . form submission and data retrieval.
* OAuth Integration: Allow users to log in with Google, GitHub, etc.
* Advanced Reporting: Create a dedicated report builder with scheduled email delivery.
* Webhooks: Trigger actions in other systems upon form submission.
* Containerization: Provide Dockerfile and docker-compose.yml for easy deployment.
# License
This project is licensed under the MIT License. See the LICENSE file for details.