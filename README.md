# Story App

A Flutter application for managing stories, featuring a robust authentication system and story management.

## Features

- User Registration and Login
- Secure Token Storage (using `flutter_secure_storage`)
- Client-side Input Validation
- Session Management (auto-login with splash screen)
- Centralized State Management (using `provider`)
- Named Routes for Navigation (using `go_router`)
- API Communication (using `http`)
- Story Listing and Detail Viewing
- Adding New Stories with Image Upload (using `image_picker`)
- API Response Model Classes

## Recent Improvements

- Fixed keyboard overflow issues on login and add story screens.

## Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd story_app
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```