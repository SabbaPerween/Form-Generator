{
  "README.md": "# Dynamic Form Generator & Data Analytics Platform\n\n![Python Version](https://img.shields.io/badge/python-3.9+-blue.svg)\n![Framework](https://img.shields.io/badge/framework-Streamlit-red)\n![Database](https://img.shields.io/badge/database-PostgreSQL-blue)\n![License](https://img.shields.io/badge/license-MIT-green)\n\nA full-stack, enterprise-grade web application for dynamically creating, sharing, and analyzing forms. This platform features robust role-based access control, an interactive analytics dashboard, and AI-powered assistance to streamline the form creation process.\n\n---\n\n### Table of Contents\n*   [Overview](#overview)\n*   [Core Features](#core-features)\n*   [Technology Stack](#technology-stack)\n*   [System Architecture](#system-architecture)\n*   [Getting Started](#getting-started)\n*   [Usage](#usage)\n*   [Future Work](#future-work)\n*   [License](#license)\n\n---\n\n## Overview\n\nThis project solves the challenge of creating and managing custom data collection forms in a secure, multi-user environment. It moves beyond static forms by providing a complete lifecycle management tool: from AI-assisted creation and database schema generation to a powerful administrative backend for data filtering, visualization, and export.\n\n\n## Core Features\n\n### User & Access Management\n*   **Secure Authentication:** Comprehensive login, registration, and password reset system. Users can authenticate with a username, email, or phone number.\n*   **OTP Password Reset:** Secure, time-sensitive One-Time Password (OTP) system delivered via SMTP for password recovery.\n*   **Role-Based Access Control (RBAC):**\n    *   **Admin:** Full control over all forms, data, users, and system health.\n    *   **Editor:** Can create, edit, and view specific forms.\n    *   **Viewer:** Can only view and submit data to assigned forms.\n\n### Form Lifecycle\n*   **Dynamic Form Creation:** Intuitive UI to build forms with over 15 field types, including text, numbers, dates, file uploads, and complex selections.\n*   **AI-Powered Field Generation:** Describe a form's purpose in natural language (e.g., \"a patient intake form\") and have the AI (Ollama/Llama2) instantly generate the corresponding JSON field structure.\n*   **Automatic Database Management:** Creating a form automatically generates and manages a corresponding, strongly-typed PostgreSQL table.\n*   **Advanced Form Relationships:**\n    *   **Parent-Child Links:** Establish hierarchies between forms (e.g., link \"Students\" to a \"School\").\n    *   **Child-to-Child Links:** Create relationships between records from different child forms under the same parent (e.g., link a \"Teacher\" record to a \"Student\" record).\n\n### Data Intelligence & Sharing\n*   **Public Sharing:** Generate unique, secure URLs to share forms publicly for data collection.\n*   **Embeddable Forms:** Generate `<iframe>` code to embed forms into other websites.\n*   **Interactive Analytics Dashboard:**\n    *   Dynamically filter data by any field (e.g., age, gender, class).\n    *   Visualize data with interactive charts and graphs from Plotly.\n    *   View Key Performance Indicators (KPIs) and submission trends over time.\n    *   Explore relationships between numeric fields with scatter plots and correlation heatmaps.\n*   **Data Export:** Download filtered data in CSV, PDF, and Excel formats.\n\n### System Administration\n*   **User Management Panel:** Admins can create, delete, and modify user roles and reset passwords.\n*   **System Health Dashboard:** Tools to diagnose and repair broken form relationships and clean up \"orphan\" records (metadata without a corresponding data table).\n\n## Technology Stack\n\n| Category      | Technology                               |\n|---------------|------------------------------------------|\n| **Frontend**  | Streamlit, Plotly                        |\n| **Backend**   | Python                                   |\n| **Database**  | PostgreSQL                               |\n| **AI**        | Ollama (Llama 2)                         |\n| **Data Tools**| Pandas                                   |\n| **Security**  | Werkzeug (Password Hashing)              |\n| **Reports**   | FPDF2 (PDFs), OpenPyXL (Excel)           |\n\n## System Architecture\n\nFor a detailed technical blueprint, including the database schema and component responsibilities, please see the [**ARCHITECTURE.md**](ARCHITECTURE.md) file.\n\n## Getting Started\n\nFollow these instructions to set up and run the project locally.\n\n### Prerequisites\n*   Python 3.8+\n*   PostgreSQL (v12 or higher)\n*   Ollama installed and serving a model (e.g., `ollama run llama2`)\n\n### 1. Clone the Repository\n```bash\ngit clone <your-repository-url>\ncd <repository-folder>\n```\n\n### 2. Set Up a Virtual Environment\n```bash\n# For MacOS/Linux\npython3 -m venv venv\nsource venv/bin/activate\n\n# For Windows\npython -m venv venv\nvenv\\Scripts\\activate\n```\n\n### 3. Install Dependencies\n```bash\npip install -r requirements.txt\n```\n\n### 4. Configure Environment Variables\nCreate a file named `.env` in the project root. Use the template below and populate it with your specific credentials.\n\n> **`.env` Template**\n> ```env\n> # --- DATABASE CONFIGURATION ---\n> DB_NAME=form_generator\n> DB_USER=your_postgres_user\n> DB_PASSWORD=your_super_secret_password\n> DB_HOST=localhost\n> DB_PORT=5432\n> \n> # --- SMTP EMAIL CONFIGURATION (for Password Reset) ---\n> # For Gmail, you MUST use a 16-digit \"App Password\".\n> SMTP_SERVER=smtp.gmail.com\n> SMTP_PORT=587\n> SENDER_USER=your.email@gmail.com\n> SENDER_PASSWORD=your_gmail_app_password\n> \n> # --- APPLICATION CONFIGURATION ---\n> # The base URL where your app is running.\n> BASE_URL=http://localhost:8501\n> ```\n\n### 5. Run the Application\nThe database tables will be created automatically on the first run.\n```bash\nstreamlit run app.py\n```\n\n## Usage\n\n1.  Navigate to `http://localhost:8501`.\n2.  Register a new account or use the pre-seeded default accounts:\n    *   **Admin:** `admin` / `admin123`\n    *   **Editor:** `editor` / `editor123`\n    *   **Viewer:** `viewer` / `viewer123`\n3.  Use the sidebar navigation to explore the application's features based on your user role.\n\n## Future Work\n\nThis platform provides a solid foundation. Future enhancements could include:\n*   **REST API:** Expose an API for programmatic form submission and data retrieval.\n*   **OAuth Integration:** Allow users to log in with Google, GitHub, etc.\n*   **Advanced Reporting:** Create a dedicated report builder with scheduled email delivery.\n*   **Webhooks:** Trigger actions in other systems upon form submission.\n*   **Containerization:** Provide `Dockerfile` and `docker-compose.yml` for easy deployment.\n\n## License\nThis project is licensed under the MIT License. See the `LICENSE` file for details.",
  "ARCHITECTURE.md": "# System Architecture\n\nThis document provides a deep dive into the technical architecture of the Dynamic Form Generator platform. It is intended for developers, architects, and anyone who needs to understand how the system works internally.\n\n## 1. Core Component Responsibilities\n\nThe application follows a clear separation of concerns, with each module having a distinct responsibility.\n\n*   **`app.py` - The Controller & View Layer**\n    *   **Responsibility:** Manages all user interface (UI) rendering, application state (`st.session_state`), and user interaction logic.\n    *   **Mechanism:** It acts as a router, directing the user to different \"pages\" (UI blocks) based on their login status and selected navigation option. It orchestrates calls to the other modules but contains no direct database or complex business logic itself.\n\n*   **`db.py` - The Data Access Layer (DAL)**\n    *   **Responsibility:** To be the single source of truth for all database interactions. No other file should ever connect directly to PostgreSQL.\n    *   **Mechanism:** It abstracts all SQL queries into Python functions. This includes creating/altering tables (`CREATE`, `ALTER`), managing metadata (`forms` table), and performing all CRUD operations on user and form data. It uses parameterized queries via `psycopg2` to prevent SQL injection vulnerabilities.\n\n*   **`form_utils.py` - The Business Logic & Utility Layer**\n    *   **Responsibility:** Contains complex, non-UI-related helper functions.\n    *   **Mechanism:** This module handles tasks like generating HTML from form fields, orchestrating calls to the Ollama AI for enhancement, and generating file-based exports (PDF, Excel).\n\n*   **`email_utils.py` - The Email Service Layer**\n    *   **Responsibility:** Handles the external communication for sending SMTP emails.\n    *   **Mechanism:** It reads configuration from environment variables and abstracts the `smtplib` logic, providing a simple function to send an OTP email. It includes detailed error handling for common SMTP issues.\n\n## 2. Database Schema\n\nThe PostgreSQL database is the heart of the system. The schema is designed to be relational and scalable.\n\n\n### Key Tables\n\n*   `users`\n    *   **Purpose:** Stores all user account information.\n    *   **Columns:** `id`, `username`, `email`, `phone`, `password_hash` (Werkzeug PBKDF2), `role`, `otp`, `otp_expires_at`.\n    *   **Relations:** This is the primary table for authentication and authorization. The `role` column links to the permissions logic in `app.py`.\n\n*   `forms`\n    *   **Purpose:** The metadata registry for every form created.\n    *   **Columns:** `id`, `form_name` (unique), `fields` (JSONB), `share_token`.\n    *   **Relations:** This table does **not** store submission data. The `fields` JSONB column contains the complete schema definition for a given form, which is used to both render the form and manage its corresponding data table.\n\n*   **Dynamic Data Tables (e.g., `student_form`, `feedback_form`)**\n    *   **Purpose:** To store the actual submission data for each form.\n    *   **Mechanism:** When a new form is created in the `forms` table, a corresponding table is created with a name derived from the `form_name` (e.g., \"Student Form\" -> `student_form`). Columns in this table are generated based on the `fields` JSON from the `forms` table.\n    *   **Relations:** If a form is a child of another, its data table will contain a `parent_id` column with a Foreign Key constraint referencing the parent's data table (`FOREIGN KEY (parent_id) REFERENCES parent_table(id)`).\n\n*   `child_relationships`\n    *   **Purpose:** Enables many-to-many style relationships between records of different child forms that share the same parent.\n    *   **Columns:** `parent_id`, `child_form1`, `record_id1`, `child_form2`, `record_id2`, `relationship_type`.\n    *   **Example:** A \"School\" (parent) has \"Teachers\" (child1) and \"Students\" (child2). This table can link Teacher #5 to Student #87 with the relationship type \"Tutor\".\n\n## 3. Security Considerations\n\nSecurity was a primary design consideration.\n*   **Password Management:** User passwords are never stored in plaintext. They are salted and hashed using the `pbkdf2:sha256` algorithm via the `werkzeug` library.\n*   **SQL Injection Prevention:** All database queries in `db.py` that involve user-supplied data use parameterized statements, which is the industry standard for preventing SQL injection attacks.\n*   **Authorization:** The `check_access()` function in `app.py` is called at the beginning of every protected page view. It checks the logged-in user's permissions (stored in `st.session_state`) before allowing the page to render, ensuring strict enforcement of roles.\n*   **Environment Variables:** All sensitive credentials (database passwords, email passwords) are loaded from a `.env` file, which should **never** be committed to version control.\n\n## 4. AI Integration Strategy (Ollama)\n\nThe AI integration is designed to assist, not replace, the user.\n*   **Prompt Engineering:** The function `generate_fields_with_llama` in `form_utils.py` uses a carefully engineered prompt. It provides the AI with strict rules, a list of valid field types, and two distinct examples (few-shot prompting). This dramatically increases the reliability and accuracy of the generated JSON output, minimizing the chance of hallucinations or malformed responses.\n*   **Graceful Fallback:** The `enhance_html_with_llama` function includes a `try...except` block. If the LLM call fails for any reason (e.g., Ollama is not running), it gracefully falls back to the deterministic, non-AI function `generate_html_form`, ensuring the application remains functional."
} 

<!-- # Dynamic Form Generator with Admin Dashboard & Data Analytics Platform

This is a comprehensive web application built with Streamlit that allows users with different roles to dynamically create forms, share them, fill them out, and analyze the submitted data through an interactive dashboard.

<!-- ## Key Features

*   **Role-Based Access Control (RBAC):** Three user roles (Admin, Editor, Viewer) with distinct permissions for creating, editing, viewing, and managing data.
*   **Secure Authentication:** Full user authentication system including registration, login (username/email/phone), and a secure password reset flow via email OTP.
*   **Dynamic Form Creation:** Users can create custom forms with a wide variety of field types (text, numbers, dates, select boxes, file uploads, etc.).
*   **AI-Powered Assistance:**
    *   **Field Generation:** Describe a form in plain English, and an AI (powered by Ollama) will generate the necessary fields for you.
    *   **HTML Enhancement:** Automatically generate a styled HTML file for the form, which can be further enhanced by the AI for better aesthetics.
*   **Form Relationships:** Create parent-child relationships between forms (e.g., a "Students" form can be a child of a "Schools" form).
*   **Data Submission:** Forms can be shared via a unique public link for anyone to fill out.
*   **Interactive Admin Dashboard:**
    *   Filter and view submission data in real-time.
    *   Visualize data with dynamic charts and graphs (powered by Plotly).
    *   Manage and delete records.
    *   Export data to CSV, PDF, and Excel.
*   **System Management:** Admins have access to a user management panel and system health tools to fix broken form relationships and clean up orphan records.

## Tech Stack

*   **Backend & Frontend:** Python, Streamlit
*   **Database:** PostgreSQL
*   **AI Integration:** Ollama (running a model like Llama 2)
*   **Data Handling:** Pandas
*   **Styling:** Bootstrap 5 (for generated HTML forms)

## Setup and Installation

Follow these steps to get the project running on your local machine.

**Prerequisites:**
*   Python 3.8+
*   PostgreSQL database installed and running.
*   Ollama installed and running with a model (e.g., `ollama pull llama2`).

**1. Clone the Repository**
```bash
git clone <your-repository-url>
cd <your-repository-folder>
#Create a Virtual Environment (Recommended)
python -m venv venv
source venv/bin/activate  # On Windows, use `venv\Scripts\activate` -->

### Table of Contents
*   [Overview](#overview)
*   [Core Features](#core-features)
*   [Technology Stack](#technology-stack)
*   [System Architecture](#system-architecture)
*   [Getting Started](#getting-started)
*   [Usage](#usage)
*   [Future Work](#future-work)
*   [License](#license)

## Overview

This project solves the challenge of creating and managing custom data collection forms in a secure, multi-user environment. It moves beyond static forms by providing a complete lifecycle management tool: from AI-assisted creation and database schema generation to a powerful administrative backend for data filtering, visualization, and export.

**(Suggestion: Add a screenshot or a GIF of the application's dashboard here to make it visually appealing.)**
`[Screenshot of the Admin Dashboard]`

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
*   Python 3.8+
*   PostgreSQL (v12 or higher)
*   Ollama installed and serving a model (e.g., `ollama run llama2`)

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd <repository-folder> -->