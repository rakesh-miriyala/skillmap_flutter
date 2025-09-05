# SkillMap

**SkillMap** is a full-stack web application built with **Flutter (Web)** for the frontend and **Node.js + Oracle SQL** for the backend. It helps manage and register skilled workers in villages, allowing admins to oversee workers who may not be able to register themselves.

---

## Features

### Public Side
- Register as a worker with name, skill, village, and contact.
- Search and filter workers by name, skill, and village.
- Multilingual support: English and Telugu.
- User-friendly design with cards, dropdowns, and responsive layouts.

### Admin Side
- Admin login system (for illiterate workers’ registrations management).
- View all registered workers in a structured dashboard.
- Edit or delete worker entries.
- Search and filter functionality.
- Logout system.

---

## Tech Stack

**Frontend:**  
- Flutter (Web)  
- Dart  
- flutter_localizations for multilingual support  
- Google Fonts (Noto Sans)

**Backend:**  
- Node.js + Express  
- Oracle SQL 12c (or higher)  
- bcrypt for password hashing  

**API Communication:**  
- REST API using JSON  

---

## Folder Structure

<img width="553" height="534" alt="image" src="https://github.com/user-attachments/assets/8bce404d-fe29-44b7-b361-fb753fa60623" />

---

## Installation

### Backend
1. Navigate to backend folder:

cd backend

2. Install dependencies:

npm install

3. Create .env file for database credentials:

DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_CONNECTION_STRING=localhost/XE

4. Start server:

node server.js

Frontend

1. Navigate to frontend folder:

cd frontend

2. Install dependencies:

flutter pub get

3. Run the web app:

flutter run -d chrome

Usage

-Public users can directly register their details from the home page.

-Admin users can log in via the admin login page to manage worker records.

-Switch between English and Telugu using the language toggle in the top-right corner.

Contributing

Contributions are welcome! Please:

1. Fork the repository.

2. Create a new branch: git checkout -b feature/your-feature.

3. Commit your changes: git commit -m "Add some feature".

4. Push to the branch: git push origin feature/your-feature.

5. Create a Pull Request.

License

This project is licensed under the MIT License. See the LICENSE file for details.
