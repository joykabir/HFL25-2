🧮 Simple Calculator - HFL25-2

Programming with Flutter and Dart

A beginner-friendly console calculator application built with Dart that demonstrates fundamental programming concepts including classes, exception handling, and user input validation.
✨ Features

    ➕ Addition operations
    ➖ Subtraction operations
    🔄 Multiple calculations in one session
    ✅ Input validation with error handling
    🚪 Graceful exit with quit command
    📱 Clean console interface with formatted output

🚀 Quick Start
Prerequisites

    Dart SDK (version 3.0.0 or higher)

Installation & Setup

    Clone or download the project

    bash

git clone <repository-url>
# OR download and extract the ZIP file

Navigate to project directory

bash

cd HFL25-2

Run the program

bash

    dart run bin/calculator.dart

🎮 How to Use

    Start the calculator - Run the command above
    Enter first number - Type any integer
    Enter second number - Type any integer
    Choose operation - Type + for addition or - for subtraction
    View result - See your calculation result
    Continue or quit - Type quit at any number prompt to exit

Example Session

vbnet

=== Simple Calculator for New Dart Programmers ===
Supports: Addition (+) and Subtraction (-) only
Type "quit" at any number prompt to exit the program.

--- New Calculation ---
Enter the first integer (or "quit" to exit): 25
Enter the second integer: 10
Choose operation (+) for addition or (-) for subtraction: +

✅ --- RESULT ---
Operation: Addition
Calculation: 25 + 10 = 35

--- New Calculation ---
Enter the first integer (or "quit" to exit): quit

👋 Thank you for using the Simple Calculator!
Happy coding with Dart! 🎯

📂 Project Structure

python

HFL25-2/
├── 📄 pubspec.yaml          # Dart project configuration
├── 📄 README.md             # This file
└── 📁 bin/
    └── 📄 calculator.dart   # Main application file

🎯 Learning Objectives

This project demonstrates key Dart concepts for beginners:

    Classes & Objects - Organizing code structure
    Exception Handling - Try-catch blocks and custom exceptions
    Input/Output - Console interaction with users
    String Manipulation - Parsing and validation
    Control Flow - Loops, conditionals, and switch statements
    Method Organization - Private methods and code separation

🛠️ Technical Details

    Language: Dart 3.0+
    Platform: Console/Terminal application
    Dependencies: None (uses built-in dart:io library)
    Architecture: Object-oriented with single responsibility principle

🐛 Error Handling

The application handles various error scenarios:

    ❌ Invalid integers - Shows helpful error messages
    ❌ Invalid operations - Only accepts + and -
    ❌ Unexpected errors - Graceful error reporting
    ✅ User-friendly messages - Clear feedback for all interactions

🤝 Contributing

This is a learning project for Flutter and Dart programming. Feel free to:

    Report issues or bugs
    Suggest improvements
    Add new features (multiplication, division, etc.)
    Improve code documentation

📝 License

This project is for educational purposes as part of the HFL25-2 course.

Happy Coding! 🎯✨

Built with ❤️ using Dart