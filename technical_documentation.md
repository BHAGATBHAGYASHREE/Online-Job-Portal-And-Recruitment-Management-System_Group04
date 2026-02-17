# Job Portal — Technical Documentation

**Purpose:**
This document serves as the primary technical reference for the Job Portal platform. It details the system architecture, backend service structure, API specifications, and frontend organization.

---

## 1 System Overview

### 1.1 Architecture
The Job Portal is built using a modern full-stack approach:
- **Frontend**: A high-performance Flutter (Dart) application.
- **Backend**: A Node.js + Express REST API (ES Modules) providing scalable services.
- **Real-time**: Socket.io integration for instant user interactions and notifications.
- **Database**: MongoDB (Mongoose ODM) for flexible schema-based data storage.
- **Authentication**: Secure JWT-based authentication with persistence via cookies and shared preferences.

### 1.2 User Roles
- **Candidate**: Users looking for jobs. They can create profiles, upload resumes/posts, browse listings, and track their applications.
- **Recruiter**: Users looking to hire. They can post job vacancies, manage candidate applications, and view hiring analytics.

---

## 2 Technology Stack & Libraries

### 2.1 Backend (Node.js + Express)
**Core Dependencies:**
| Package | Purpose |
| :--- | :--- |
| express | Web server and API routing. |
| mongoose | MongoDB Object Data Modeling (ODM). |
| jsonwebtoken | Secure JSON Web Token generation. |
| bcryptjs | Industry-standard password hashing. |
| socket.io | Bi-directional real-time communication. |
| multer | Middleware for handling `multipart/form-data` (file uploads). |
| cloudinary | Cloud-based media and image management. |
| cookie-parser | JWT cookie management for web-based auth. |
| cors | Handling Cross-Origin Resource Sharing. |

**Entry File:** `backend/index.js`

### 2.2 Frontend (Flutter + Dart)
**Core Dependencies:**
| Package | Purpose |
| :--- | :--- |
| http | Making RESTful API requests. |
| intl | Support for internationalization and formatting. |
| shared_preferences | Persistent local key-value storage. |
| cupertino_icons | iOS-style design assets. |

**Entry File:** `frontend/lib/main.dart`

---

## 3 Backend Structure

### 3.1 Directory Organization
- **`/models`**: Mongoose schemas for data persistence.
- **`/routes`**: Express route definitions mapping URLs to controllers.
- **`/config`**: Configuration files (e.g., Database connection).
- **`/middlewares`**: Custom logic for authentication and file handling.

### 3.2 Data Models
| Model | Description |
| :--- | :--- |
| **User** | Central identity model (Email, Password, Bio, Role). |
| **Job** | Job posting details (Title, Company, Location, Description). |
| **Application** | Junction model linking Candidates to Jobs with status (Pending, Accepted). |
| **Post** | Social engagement model for sharing platform updates. |
| **Connection** | Networking model for tracking user relationships. |

### 3.3 API Overview
Base URL: `/api`

| Module | Endpoints | Responsibility |
| :--- | :--- | :--- |
| **Auth** | `/auth/*` | Registration, Login, and Session management. |
| **Jobs** | `/jobs/*` | Posting, retrieving, and updating job listings. |
| **Applications**| `/applications/*`| Submitting and managing job applications. |
| **Users** | `/user/*` | Profile updates and identity management. |
| **Community** | `/post/*` | Sharing and viewing platform posts. |

---

## 4 Frontend Architecture

### 4.1 Screen Modules (`lib/screens/`)
The frontend is divided into specialized views based on user intent:

**Authentication & Onboarding:**
- `welcome_screen`: Initial entry point.
- `login_screen` & `signup_screen`: Identity management.

**Candidate Experience:**
- `candidate_dashboard`: Central hub for job seekers.
- `job_detail_screen`: Detailed view of specific opportunities.
- `my_applications_screen`: Tracking submitted applications.

**Recruiter Experience:**
- `recruiter_dashboard`: Management hub for hiring managers.
- `create_job_screen`: Interface for posting new vacancies.
- `job_applications_screen`: Reviewing candidate submissions.
- `analytics_screen`: Hiring performance metrics.

### 4.2 Application Logic
- **Models**: `lib/models/` (e.g., `job_model.dart`) ensures typed data across the app.
- **Services**: `lib/services/` (e.g., `ApiService`) abstracts complex HTTP logic and error handling.

---

## 5 Environment Configuration

### Backend (`.env`)
The following environment variables are required for proper operation:
```text
MONGO_URI=      # MongoDB connection string
JWT_SECRET=     # Secret key for JWT signing
PORT=8000       # Operational port
CLOUDINARY_*    # Cloudinary credentials for media storage
```

---

## 6 Real-time Capabilities
The system utilizes Socket.io to bridge the gap between backend events and frontend UI. Key features include:
- `userSocketMap`: Tracks active sessions for targeted notifications.
- Real-time updates for application status changes and new job alerts.
