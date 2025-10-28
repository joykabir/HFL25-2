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


## Prerequisites

- Dart SDK (version 3.0.0 or higher)
- Superhero API key (Personal)

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

