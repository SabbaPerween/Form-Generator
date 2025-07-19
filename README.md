

# Dynamic Form Generator with Admin Dashboard & Data Analytics Platform
![Python Version](https://img.shields.io/badge/python-3.9+-blue.svg)
![Framework](https://img.shields.io/badge/framework-Streamlit-red)
![Database](https://img.shields.io/badge/database-PostgreSQL-blue)
![License](https://img.shields.io/badge/license-MIT-green)


This is a comprehensive web application built with Streamlit that allows users with different roles to dynamically create forms, share them, fill them out, and analyze the submitted data through an interactive dashboard.

### Table of Contents
*   [Overview](#overview)
*   [Core Features](#core-features)
*   [Technology Stack](#technology-stack)
*   [System Architecture](#system-architecture)
*   [Getting Started](#getting-started)
*   [Usage](#usage)
*   [Future Work](#future-work)
*   [License](#license)

---

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
cd <repository-folder>


### 2. Clone the Repository

# For MacOS/Linux
python3 -m venv venv
source venv/bin/activate

# For Windows
python -m venv venv
venv\Scripts\activate

### 3. Install Dependencies
pip install -r requirements.txt

### 4. Configure Environment Variables
#.env file
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

### 5. Run the Application
streamlit run app.py

Usage
Navigate to http://localhost:8501.
Register a new account or use the pre-seeded default accounts:
Admin: admin / admin123
Editor: editor / editor123
Viewer: viewer / viewer123
Use the sidebar navigation to explore the application's features based on your user role.
Future Work
This platform provides a solid foundation. Future enhancements could include:
REST API: Expose an API for programmatic form submission and data retrieval.
OAuth Integration: Allow users to log in with Google, GitHub, etc.
Advanced Reporting: Create a dedicated report builder with scheduled email delivery.
Webhooks: Trigger actions in other systems upon form submission.
Containerization: Provide Dockerfile and docker-compose.yml for easy deployment.


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
source venv/bin/activate  # On Windows, use `venv\Scripts\activate`

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