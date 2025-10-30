[![Run Dart Tests on PR](https://github.com/joykabir/HFL25-2/actions/workflows/dart-test.yml/badge.svg)](https://github.com/joykabir/HFL25-2/actions/workflows/dart-test.yml)
[![Auto readme creation for new version folders](https://github.com/joykabir/HFL25-2/actions/workflows/add-readme.yml/badge.svg)](https://github.com/joykabir/HFL25-2/actions/workflows/add-readme.yml)

[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

# HFL25-2: Programming with Flutter and Dart

Course Projects and Assignments Repository

This repository contains all programming assignments and projects for the HFL25-2 course, focusing on Flutter and Dart development.

## Repository Overview

### v01 - Simple Calculator

Assignment 1: Console-based calculator application

Features:
- Addition and subtraction operations
- Multiple calculations until quit
- Input validation and error handling
- Unit testing


### v02 - HeroDex 3000

Assignment 2: HeroDex 3000

Features:
- Add and manage superheroes with powers and attributes
- Display heroes with detailed stats
- Search heroes by name or powers
- JSON storage for hero data
- Interactive command-line interface
- Unit testing


### v03 - HeroDex 3000 Modular

Assignment 3: Continuing v02 but with modular structure in code and more functionalities

Features:
- Refactored modular code architecture
- Enhanced hero management system
- Advanced search and filtering capabilities
- Improved data persistence
- Additional features and optimizations

### v04 - Final Project

### HeroDex 3000 - Superhero Tracking Application

Welcome to HeroDex 3000, a command-line Dart application for managing your favorite superheroes and villains.

## Features

This project is built adhering to specific requirements, focusing on core programming principles, data handling, and version control.

### 1. Fundamentals of Dart

*   **Variable Declaration & Typing:** Correctly declare and use variables with appropriate Dart data types (`String`, `int`, `List`, `Map`, `Future`, etc.).
*   **Null Safety:** Understand and safely utilize Dart's null safety features (`?` and `!`).
*   **Code Structure:** Employ functions and classes to structure code logically, avoiding monolithic solutions in `main()`.

### 2. JSON Handling and API Integration

*   **HTTP Requests:** Fetch data from external APIs using the `http` package.
*   **Asynchronous Operations:** Properly implement `async` and `await` for managing asynchronous API calls and responses.
*   **Data Modeling:** Parse JSON responses into Dart model classes (e.g., `HeroModel`) that accurately represent the data structure.

### 3. Local Data Persistence

*   **Saving Data:** Store at least one hero's data locally (e.g., using JSON files, `shared_preferences`, or similar mechanisms).
*   **Loading Data:** Ensure saved data is retrieved and available when the application starts.

### 4. Core Functionality

*   **Hero Management:** Implement features to add and remove heroes.
*   **Duplicate Prevention:** Prevent the addition of duplicate heroes (based on name or a unique identifier).
*   **Categorized Listing:** Display heroes and villains separately.
*   **User Interface:** Provide a basic, intuitive command-line menu for user interaction.

### 5. Version Control (Git & GitHub)

*   **Branching Strategy:** Work on new features in dedicated Git branches.
*   **Meaningful Commits:** Write clear and descriptive commit messages that track development progress.
*   **Repository Submission:** Submit the project via a GitHub repository link.

### 6. Structure and Code Quality (Advanced Requirements)

*   **Separation of Concerns (SOC):** Organize the project into multiple files and classes, each with a distinct responsibility (e.g., `NetworkManager`, `JsonManager`, `DataManager`, `HeroModel`).
*   **Readability:** Write clean, readable, and understandable code. Business logic should not reside directly in `main()`.
*   **Abstraction & Testability:** Utilize abstractions (like abstract classes or interfaces) to make components easily replaceable and testable (e.g., for mocking).

---

## Getting Started

*(This section would typically include instructions on how to clone the repository, set up the environment, and run the application.)*

### Prerequisites

*   Dart SDK installed.
*   Git installed.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd <project-directory>
    ```

2.  **Get dependencies:**
    ```bash
    dart pub get
    ```

3.  **Environment Variables:**
    Create a `.env` file in the root of the project (next to `pubspec.yaml`) and add your API keys:
    ```dotenv
    SUPERHERO_API_URL=https://superheroapi.com/api
    SUPERHERO_API_KEY=YOUR_SUPERHERO_API_KEY
    ```
    *Replace `YOUR_SUPERHERO_API_KEY` with your actual API key.*

### Running the Application

To run the application, use the Dart CLI:

```bash
dart run bin/main.dart [options]
## Setup Superhero API key

1. Copy `.env.example` to `.env` in the root of the project. The file is already added in gitignore:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your actual API key:
   ```env
   SUPERHERO_API_KEY=your_actual_api_key_here
   ```

3. Install dependencies:
   ```bash
   cd v04
   dart pub get
   ```

## Run test

```bash
git clone git@github.com:joykabir/HFL25-2.git
cd HFL25-2/v04

# Install dependencies
dart pub get

# Run main app
dart run bin/main.dart

# Run tests
dart test test/test_all.dart --reporter=expanded

```bash
.
├── bin/                  # Application entry point and executable scripts
│   ├── main.dart         # Main application logic and CLI interface
│   └── hero_interactive.dart # Handles interactive user prompts
├── lib/                  # Source code
│   ├── config/           # Application configuration (e.g., .env loading)
│   │   └── app_config.dart
│   ├── models/           # Data models representing application entities
│   │   ├── appearance.dart
│   │   ├── biography.dart
│   │   ├── connections.dart
│   │   ├── heroimage.dart
│   │   ├── heromodel.dart  # Main hero data structure
│   │   ├── powerstats.dart
│   │   └── work.dart
│   ├── network/          # Network-related services (API calls)
│   │   └── http_handler.dart
│   └── services/         # Core business logic and data management
│       ├── hero_data_managing.dart # Abstract interface for hero data
│       └── hero_data_manager.dart  # Concrete implementation for local data
├── test/                 # Unit and integration tests
├── .env                  # Environment variables (API keys, etc.) - DO NOT COMMIT
├── .gitignore            # Specifies intentionally untracked files
├── analysis_options.yaml # Dart analysis and linting rules
├── pubspec.yaml          # Project metadata and dependencies
└── README.md             # Project description (this file)
```