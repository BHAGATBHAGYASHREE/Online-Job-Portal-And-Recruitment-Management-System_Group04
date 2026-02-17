# Job Portal — Technical Documentation

**Purpose:**
This document serves as the technical reference for the Job Portal system, covering architectural design, API specifications, and frontend organization.

---

## 1 System Overview

### 1.1 Architecture
The Job Portal is built on a modern MERN stack with a Flutter frontend:
- **Frontend**: Flutter (Dart) mobile/web application using `http` for API communication and `shared_preferences` for local storage.
- **Backend**: Node.js + Express REST API (ES Modules), with Socket.io for real-time notifications/interactions.
- **Database**: MongoDB (Mongoose ODM).
- **Authentication**: JWT (JSON Web Token) with cookie-based/header-based persistence.

### 1.2 User Roles
1.  **Candidate**: Can browse jobs, apply for positions, and track applications.
2.  **Recruiter**: Can post jobs, manage applications, and view analytics.

---

## 2 Technology Stack & Libraries

### 2.1 Backend (Node.js + Express)
| Package | Purpose |
| :--- | :--- |
| express | Web framework and routing |
| mongoose | MongoDB interaction |
| jsonwebtoken | Secure authentication |
| bcryptjs | Password security |
| socket.io | Real-time communication |
| multer | File/Resume upload handling |
| cloudinary | Media storage |
| cookie-parser | JWT cookie management |
| cors | Cross-origin resource sharing |

**Entry Point**: `backend/index.js`

### 2.2 Frontend (Flutter + Dart)
| Package | Purpose |
| :--- | :--- |
| http | REST API communication |
| intl | Formatting and internationalization |
| shared_preferences | Persistent local storage (Tokens, etc.) |
| cupertino_icons | iOS-style iconography |

**Entry Point**: `frontend/lib/main.dart`

---

## 3 Backend Structure

### 3.1 Core Architecture
The backend follows a modular route-controller-model pattern:
- **`index.js`**: Application bootstrap, middleware configuration, and socket initialization.
- **`config/db.js`**: Database connection logic.

### 3.2 Models
- **User (`user.model.js`)**: Handles auth, profile details, and roles.
- **Job (`job.model.js`)**: Job listing schema (Title, company, etc.).
- **Application (`application.model.js`)**: Links users to jobs with status tracking.
- **Post (`post.model.js`)**: Community/social feature for sharing updates.
- **Connection (`connection.model.js`)**: Relationship tracking between users.

### 3.3 API Endpoints
Base URL: `/api`

| Module | Route | Purpose |
| :--- | :--- | :--- |
| **Auth** | `/auth` | Login, Register, Logout |
| **User** | `/user` | Profile management |
| **Jobs** | `/jobs` | CRUD operations for job posts |
| **Applications** | `/applications` | Apply for jobs, track status |
| **Posts** | `/post` | Community engagement |
| **Connections** | `/connection` | Networking features |

---

## 4 Frontend Architecture

### 4.1 Screen Modules
The UI is organized into feature-specific screens located in `lib/screens/`:

- **General**: `welcome_screen`, `login_screen`, `signup_screen`.
- **Recruiter**: `recruiter_dashboard`, `create_job_screen`, `job_applications_screen`, `analytics_screen`.
- **Candidate**: `candidate_dashboard`, `job_detail_screen`, `my_applications_screen`.

### 4.2 Data Management
- Uses `lib/models/` for data serialization (e.g., `job_model.dart`).
- Uses `ApiService` (in `lib/services/`) for centralizing all network requests.

---

## 5 Environment Configuration

### Backend (`.env`)
Required keys:
- `MONGO_URI`: MongoDB connection string.
- `JWT_SECRET`: Secret for signing tokens.
- `PORT`: Server port (defaults to 8000).
- `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`.

---

## 6 Real-time Features
The system implements Socket.io for:
- User registration on connection (`userSocketMap`).
- Potential real-time notifications for job updates or application status changes.
