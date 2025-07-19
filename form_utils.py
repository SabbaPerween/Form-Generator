# form_utils.py
import ollama
import json
import os
import logging
import pandas as pd
from fpdf import FPDF
from datetime import datetime
import io
# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
def generate_pdf_from_dataframe(df: pd.DataFrame, title: str) -> bytes:
    """Generates a PDF file from a pandas DataFrame."""
    pdf = FPDF(orientation='L', unit='mm', format='A4') # Landscape mode for more space
    pdf.add_page()
    
    # Title
    pdf.set_font('Arial', 'B', 16)
    pdf.cell(0, 10, title, 0, 1, 'C')
    
    # Date
    pdf.set_font('Arial', '', 10)
    pdf.cell(0, 10, f"Report generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", 0, 1, 'C')
    pdf.ln(10)
    
    # Table Header
    pdf.set_font('Arial', 'B', 8)
    # Dynamically calculate column widths
    page_width = pdf.w - 2 * pdf.l_margin
    num_columns = len(df.columns)
    col_width = page_width / num_columns if num_columns > 0 else page_width
    
    for col in df.columns:
        pdf.cell(col_width, 10, col, 1, 0, 'C')
    pdf.ln()
    
    # Table Rows
    pdf.set_font('Arial', '', 8)
    for index, row in df.iterrows():
        for item in row:
            # Convert item to string and handle potential encoding issues for PDF
            cell_text = str(item).encode('latin-1', 'replace').decode('latin-1')
            pdf.cell(col_width, 10, cell_text, 1, 0)
        pdf.ln()
        
    # THE FIX: Explicitly convert the bytearray from pdf.output() to bytes.
    return bytes(pdf.output())

def generate_excel_from_dataframe(df: pd.DataFrame) -> bytes:
    """Generates an Excel file from a pandas DataFrame."""
    output = io.BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Submissions')
        # Auto-adjust columns' width
        for column in df:
            column_width = max(df[column].astype(str).map(len).max(), len(column))
            writer.sheets['Submissions'].column_dimensions[column[0].upper()].width = column_width + 2
            
    return output.getvalue()

def get_navigation_css():
    """Returns CSS to fix navigation arrow styling"""
    return """
    <style>
    /* Fix for navigation arrows */
    .nav-arrow {
        display: inline-block;
        margin: 0 5px;
    }
    .nav-arrow::after {
        content: ">";
        font-family: inherit;
    }
    </style>
    """
# In form_utils.py

# This function will become our primary, instant form generator.
def generate_html_form(form_name: str, fields: list) -> str:
    """
    Instantly generates a functional Bootstrap 5 HTML form from a list of fields
    without calling an LLM. This should be the default method.
    """
    # Start with Bootstrap CDN and a container
    html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{form_name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>{form_name}</h2>
        <form action="#" method="POST">
    """

    # Loop through fields and generate the correct HTML input
    for field in fields:
        field_name = field.get("name", "unnamed_field")
        # Sanitize name for HTML attributes
        sanitized_name = field_name.replace(" ", "_").lower()
        field_type = field.get("type", "TEXT")
        options = field.get("options", [])
        
        html += f'        <div class="mb-3">\n'
        html += f'            <label for="{sanitized_name}" class="form-label">{field_name}</label>\n'

        if field_type == "TEXTAREA":
            html += f'            <textarea class="form-control" id="{sanitized_name}" name="{sanitized_name}" rows="3" required></textarea>\n'
        elif field_type == "SELECT":
            html += f'            <select class="form-select" id="{sanitized_name}" name="{sanitized_name}" required>\n'
            for option in options:
                html += f'                <option value="{option}">{option}</option>\n'
            html += f'            </select>\n'
        elif field_type == "RADIO":
            for i, option in enumerate(options):
                html += f'''
            <div class="form-check">
                <input class="form-check-input" type="radio" name="{sanitized_name}" id="{sanitized_name}_{i}" value="{option}" required>
                <label class="form-check-label" for="{sanitized_name}_{i}">
                    {option}
                </label>
            </div>'''
        elif field_type == "MULTISELECT":
            html += f'            <select class="form-select" id="{sanitized_name}" name="{sanitized_name}" multiple required>\n'
            for option in options:
                html += f'                <option value="{option}">{option}</option>\n'
            html += f'            </select>\n'
        elif field_type == "CHECKBOX":
            # For a single boolean checkbox
            html += f'''
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="{sanitized_name}" name="{sanitized_name}" value="true">
                <label class="form-check-label" for="{sanitized_name}">Yes/No</label>
            </div>'''
        elif field_type == "PHONE":
            html += f'            <input type="tel" class="form-control" id="{sanitized_name}" name="{sanitized_name}" pattern="[0-9]{{10,15}}" title="10-15 digit phone number" required>\n'
        elif field_type == "EMAIL":
            html += f'            <input type="email" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        elif field_type == "DATE":
            html += f'            <input type="date" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        elif field_type == "DATETIME":
            html += f'            <input type="datetime-local" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        elif field_type == "TIME":
            html += f'            <input type="time" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        elif field_type == "INTEGER" or field_type == "FLOAT" or field_type == "RANGE":
            html += f'            <input type="number" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        elif field_type == "PASSWORD":
            html += f'            <input type="password" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        else: # Default to text input
            html += f'            <input type="text" class="form-control" id="{sanitized_name}" name="{sanitized_name}" required>\n'
        
        html += f'        </div>\n'

    # Add submit button and close tags
    html += """
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</body>
</html>
    """
    return html
# This is the NEW function that generates fields from a description. It's correct.
def generate_fields_with_llama(description: str) -> tuple[bool, str]:
    """
    Uses an LLM to generate a form's field structure from a natural language description.

    Returns a tuple: (success: bool, content: str), where content is either
    a JSON string of the fields or an error message.
    """
    valid_types = [
        "VARCHAR(255)", "INTEGER", "FLOAT", "DATE", "BOOLEAN", "TEXT", "PHONE",
        "TEXTAREA", "PASSWORD", "CHECKBOX", "RADIO", "SELECT", "DATETIME", "TIME",
        "MULTISELECT", "EMAIL", "URL", "COLOR", "RANGE"
    ]

    prompt = f"""
You are an expert JSON generator for a form-building application.
Based on the user's request, generate a JSON array of field objects.

**RULES:**
1.  **ONLY output the raw JSON array.** Do NOT include any explanations, markdown like ```json, or introductory text. Your entire response must be only the JSON.
2.  Each object in the array represents a form field and must have a "name" and a "type".
3.  The "name" should be a human-readable string (e.g., "Full Name").
4.  The "type" MUST be one of the following values: {', '.join(valid_types)}.
5.  For types 'SELECT', 'RADIO', or 'MULTISELECT', you MUST include an "options" key with an array of strings.
6.  Infer the most appropriate type. 'TEXTAREA' is for long text. 'VARCHAR(255)' is for short text. 'EMAIL' for emails, 'DATE' for dates, etc.

**EXAMPLE 1:**
User Request: "A contact form with name, email, and a message."
Your Output:
[
  {{"name": "Name", "type": "VARCHAR(255)"}},
  {{"name": "Email", "type": "EMAIL"}},
  {{"name": "Message", "type": "TEXTAREA"}}
]

**EXAMPLE 2:**
User Request: "Student survey with student name, their grade from 1 to 12, and their favorite subject (Math, Science, History, Art)."
Your Output:
[
  {{"name": "Student Name", "type": "VARCHAR(255)"}},
  {{"name": "Grade", "type": "INTEGER"}},
  {{"name": "Favorite Subject", "type": "RADIO", "options": ["Math", "Science", "History", "Art"]}}
]

---

**USER'S REQUEST:**
"{description}"

**YOUR JSON OUTPUT:**
"""
    try:
        response = ollama.generate(
            model='llama2',
            prompt=prompt,
            options={'temperature': 0.1}
        )
        
        json_response = response['response']
        
        try:
            json.loads(json_response)
            return (True, json_response)
        except json.JSONDecodeError as e:
            error_msg = f"AI returned malformed JSON. Error: {e}\nRaw Response: {json_response}"
            logger.error(error_msg)
            return (False, error_msg)

    except Exception as e:
        logger.error(f"Error calling LLM for field generation: {e}")
        return (False, f"An error occurred while contacting the AI: {e}")

def enhance_html_with_llama(form_name, fields):
    confirmation_message = f"Request received: Enhancing form '{form_name}' with AI (LLM)..."
    print(confirmation_message) # For immediate console feedback
    logger.info(confirmation_message) # For structured logging
    try:
        nav_css = get_navigation_css()
        # Create field specifications string
        field_specs = "\n".join(
            # Corrected to handle tuple items from the tuple of tuples
            [f"- {dict(field)['name']} ({dict(field)['type']})" for field in fields]
        )
        
        prompt = f"""
        Create an HTML form for '{form_name}' with the following fields:
        {field_specs}
        
        Requirements:
        1. Use Bootstrap 5 for styling
        2. Wrap each field in a div with class 'mb-3'
        3. Use appropriate input types based on data types:
            - VARCHAR(255)/TEXT: text input or textarea
            - INTEGER/FLOAT: number input
            - DATE: date input
            - BOOLEAN: checkbox
            - PHONE: tel input with pattern validation
        4. Add 'required' attribute to all fields
        5. Include a submit button with class 'btn btn-primary'
        6. Add form labels with field names
        7. Use field names for input names and IDs
        8. For phone fields, add pattern="[0-9]{{10,15}}" and title="10-15 digit phone number"
        9. For navigation elements, use:
            <span class="nav-arrow"></span> 
            instead of Material Icons
        10. Include this CSS:
        {nav_css}
        """
        
        response = ollama.generate(
            model='llama2',
            prompt=prompt,
            options={'temperature': 0.2}
        )
        
        return response['response']
    except Exception as e:
        logger.error(f"Error generating form: {str(e)}")
        # Fallback to the non-AI HTML generator
        return generate_html_form(form_name, [dict(field) for field in fields])
def generate_fallback_form(fields):
    """Generate a simple form as fallback when LLAMA fails"""
    form_html = get_navigation_css() +'<form>\n'
    for field in fields:
        field_name = field["name"]
        field_type = field["type"]
        if field_type in ["RADIO", "SELECT", "CHECKBOX", "MULTISELECT"]:
            options = field.get("options", [])
        input_type = "text"
        if "INT" in field_type:
            input_type = "number"
        elif "FLOAT" in field_type:
            input_type = "number"
        elif "DATE" in field_type:
            input_type = "date"
        elif "BOOLEAN" in field_type:
            input_type = "checkbox"
        elif "PHONE" in field_type:
            input_type = "tel"
        
        form_html += f'  <div class="mb-3">\n'
        form_html += f'    <label for="{field_name}" class="form-label">{field_name}</label>\n'
        
        if field_type == "PHONE":
            form_html += f'    <input type="tel" class="form-control" id="{field_name}" name="{field_name}" pattern="[0-9]{{10,15}}" title="10-15 digit phone number">\n'
        else:
            form_html += f'    <input type="{input_type}" class="form-control" id="{field_name}" name="{field_name}">\n'
        
        form_html += '  </div>\n\n'
    
    form_html += '  <button type="submit" class="btn btn-primary">Submit</button>\n'
    form_html += '</form>'
    return form_html
# Corrected function in form_utils.py

# def generate_embed_code(form_name: str, token: str, base_url: str) -> str:
#     """Generate HTML embed code for a form"""
#     # Use the corrected URL structure (base_url + ?token=...)
#     embed_url = f"{base_url}?token={token}"
#     return f"""
#     <iframe 
#         src="{embed_url}" 
#         title="{form_name}"
#         width="100%" 
#         height="600px"
#         frameborder="0"
#         style="border: 1px solid #ddd; border-radius: 5px;"
#     ></iframe>
#     """
def generate_embed_code(form_name: str, token: str, base_url: str) -> str:
    """Generate HTML embed code (iframe) for a form."""
    # The URL for the iframe's src attribute must include the token parameter
    embed_url = f"{base_url}?token={token}"
    
    return f'''
<iframe 
    src="{embed_url}" 
    title="{form_name}"
    width="100%" 
    height="600px"
    frameborder="0"
    style="border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);"
></iframe>
    '''
def save_form_html(form_name, html_content):
    try:
        # Ensure navigation CSS exists in the content
        if 'nav-arrow' not in html_content:
            html_content = get_navigation_css() + html_content
        os.makedirs("generated_forms", exist_ok=True)
        filename = f"{form_name.replace(' ', '_').lower()}.html"
        filepath = os.path.join("generated_forms", filename)
        
        # Add Bootstrap CDN if missing
        if '<link href="https://cdn.jsdelivr.net/npm/bootstrap' not in html_content:
            bootstrap_cdn = """
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            """
            html_content = bootstrap_cdn + html_content
        
        with open(filepath, "w") as f:
            f.write(html_content)
        
        return filepath
    except Exception as e:
        logger.error(f"Error saving form HTML: {str(e)}")
        return None
def get_html_input(field):
        field_type = field.get("type", "TEXT")
        field_name = field["name"]
        required = "required" if field.get("required") else ""
        
        if field_type == "TEXTAREA":
            return f'<textarea class="form-control" name="{field_name}" {required}></textarea>'
        
        elif field_type == "PASSWORD":
            return f'<input type="password" class="form-control" name="{field_name}" {required}>'
        
        elif field_type == "CHECKBOX_GROUP":
            options = field.get("options", "").split(',')
            html = ""
            for opt in options:
                html += f'''
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="{field_name}[]" value="{opt}">
                    <label class="form-check-label">{opt}</label>
                </div>
                '''
            return html
        
        # Add similar blocks for other field types...
        
        # Default text input
        return f'<input type="text" class="form-control" name="{field_name}" {required}>'
