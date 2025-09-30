

### 🎮 How to Run

```bash

Start the calculator - Run the command above
Enter first number - Type any integer
Enter second number - Type any integer
Choose operation - Type + for addition or - for subtraction
View result - See your calculation result
Continue or quit - Type quit to exit

```

### Example Session

```bash
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
```

### 🧪 Running Tests

This project includes unit tests. To run tests ->

```bash

# Install dependencies (required for testing)
dart pub get

# Run all tests
dart test

# Run tests with detailed output
dart test --reporter=expanded

# Run specific test file
dart test test/calculator_test.dart

# Run tests with coverage (optional)
dart test --coverage=coverage
```
### 🐛 Error Handling

The application handles various error scenarios:

    ❌ Invalid integers - Shows helpful error messages
    ❌ Invalid operations - Only accepts + and -
    ❌ Unexpected errors - Graceful error reporting
    ✅ User-friendly messages - Clear feedback for all interactions