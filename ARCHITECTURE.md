```markdown
# System Architecture

This document provides a deep dive into the technical architecture of the Dynamic Form Generator platform. It is intended for developers, architects, and anyone who needs to understand how the system works internally.

## 1. Core Component Responsibilities

The application follows a clear separation of concerns, with each module having a distinct responsibility.

*   **`app.py` - The Controller & View Layer**
    *   **Responsibility:** Manages all user interface (UI) rendering, application state (`st.session_state`), and user interaction logic.
    *   **Mechanism:** It acts as a router, directing the user to different "pages" (UI blocks) based on their login status and selected navigation option. It orchestrates calls to the other modules but contains no direct database or complex business logic itself.

*   **`db.py` - The Data Access Layer (DAL)**
    *   **Responsibility:** To be the single source of truth for all database interactions. No other file should ever connect directly to PostgreSQL.
    *   **Mechanism:** It abstracts all SQL queries into Python functions. This includes creating/altering tables (`CREATE`, `ALTER`), managing metadata (`forms` table), and performing all CRUD operations on user and form data. It uses parameterized queries via `psycopg2` to prevent SQL injection vulnerabilities.

*   **`form_utils.py` - The Business Logic & Utility Layer**
    *   **Responsibility:** Contains complex, non-UI-related helper functions.
    *   **Mechanism:** This module handles tasks like generating HTML from form fields, orchestrating calls to the Ollama AI for enhancement, and generating file-based exports (PDF, Excel).

*   **`email_utils.py` - The Email Service Layer**
    *   **Responsibility:** Handles the external communication for sending SMTP emails.
    *   **Mechanism:** It reads configuration from environment variables and abstracts the `smtplib` logic, providing a simple function to send an OTP email. It includes detailed error handling for common SMTP issues.

## 2. Database Schema

The PostgreSQL database is the heart of the system. The schema is designed to be relational and scalable.

**(Suggestion: For a top-tier submission, use a tool like dbdiagram.io to create an ERD image from the schema below and embed it here.)**
`[Entity-Relationship Diagram Image]`

### Key Tables

*   `users`
    *   **Purpose:** Stores all user account information.
    *   **Columns:** `id`, `username`, `email`, `phone`, `password_hash` (Werkzeug PBKDF2), `role`, `otp`, `otp_expires_at`.
    *   **Relations:** This is the primary table for authentication and authorization. The `role` column links to the permissions logic in `app.py`.

*   `forms`
    *   **Purpose:** The metadata registry for every form created.
    *   **Columns:** `id`, `form_name` (unique), `fields` (JSONB), `share_token`.
    *   **Relations:** This table does **not** store submission data. The `fields` JSONB column contains the complete schema definition for a given form, which is used to both render the form and manage its corresponding data table.

*   **Dynamic Data Tables (e.g., `student_form`, `feedback_form`)**
    *   **Purpose:** To store the actual submission data for each form.
    *   **Mechanism:** When a new form is created in the `forms` table, a corresponding table is created with a name derived from the `form_name` (e.g., "Student Form" -> `student_form`). Columns in this table are generated based on the `fields` JSON from the `forms` table.
    *   **Relations:** If a form is a child of another, its data table will contain a `parent_id` column with a Foreign Key constraint referencing the parent's data table (`FOREIGN KEY (parent_id) REFERENCES parent_table(id)`).

*   `child_relationships`
    *   **Purpose:** Enables many-to-many style relationships between records of different child forms that share the same parent.
    *   **Columns:** `parent_id`, `child_form1`, `record_id1`, `child_form2`, `record_id2`, `relationship_type`.
    *   **Example:** A "School" (parent) has "Teachers" (child1) and "Students" (child2). This table can link Teacher #5 to Student #87 with the relationship type "Tutor".

## 3. Security Considerations

Security was a primary design consideration.
*   **Password Management:** User passwords are never stored in plaintext. They are salted and hashed using the `pbkdf2:sha256` algorithm via the `werkzeug` library.
*   **SQL Injection Prevention:** All database queries in `db.py` that involve user-supplied data use parameterized statements, which is the industry standard for preventing SQL injection attacks.
*   **Authorization:** The `check_access()` function in `app.py` is called at the beginning of every protected page view. It checks the logged-in user's permissions (stored in `st.session_state`) before allowing the page to render, ensuring strict enforcement of roles.
*   **Environment Variables:** All sensitive credentials (database passwords, email passwords) are loaded from a `.env` file, which should **never** be committed to version control.

## 4. AI Integration Strategy (Ollama)

The AI integration is designed to assist, not replace, the user.
*   **Prompt Engineering:** The function `generate_fields_with_llama` in `form_utils.py` uses a carefully engineered prompt. It provides the AI with strict rules, a list of valid field types, and two distinct examples (few-shot prompting). This dramatically increases the reliability and accuracy of the generated JSON output, minimizing the chance of hallucinations or malformed responses.
*   **Graceful Fallback:** The `enhance_html_with_llama` function includes a `try...except` block. If the LLM call fails for any reason (e.g., Ollama is not running), it gracefully falls back to the deterministic, non-AI function `generate_html_form`, ensuring the application remains functional.

### Update requirements.txt
Finally, replace the contents of your requirements.txt file with this complete and accurate list of dependencies.

```bash
streamlit
psycopg2-binary
python-dotenv
ollama
pandas
werkzeug
fpdf2
openpyxl
plotly
graphviz
```