[![Run Dart Tests on PR](https://github.com/joykabir/HFL25-2/actions/workflows/dart-test.yml/badge.svg)](https://github.com/joykabir/HFL25-2/actions/workflows/dart-test.yml)
[![Auto readme creation for new version folders](https://github.com/joykabir/HFL25-2/actions/workflows/add-readme.yml/badge.svg)](https://github.com/joykabir/HFL25-2/actions/workflows/add-readme.yml)

# HFL25-2: Programming with Flutter and Dart

**Course Projects and Assignments Repository**

This repository contains all programming assignments and projects for the HFL25-2 course, focusing on Flutter and Dart development.

## 📚 Repository Overview

### [📁 v01 - Simple Calculator](./v01/)
**Assignment 1**: Console-based calculator application
- ➕ Addition and subtraction operations
- 🔄 Multiple calculations until quit
- ✅ Input validation and error handling
- 🧪 Unit testing
- **Status**: ✅ Submitted

### [📁 v02 - Future Project](./v02/)
**Assignment 2**: _To be announced_
- **Status**: 📋 Planned


### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) (version 3.0.0 or higher)
- Git for cloning the repository

### Installation & Setup

```bash
# Clone the repository
git clone git@github.com:joykabir/HFL25-2.git
cd HFL25-2

# Navigate to specific project
cd v01

# Install dependencies (if any)
dart pub get

# Run the program
dart run bin/calculator.dart

# Run tests
dart test
```
## 🔧 How to Add a Function in Dart

Functions are reusable blocks of code that perform specific tasks. Here's how to create and use functions in Dart with simple examples.

### 📝 Basic Function Syntax

```dart
returnType functionName(parameters) {
  return value;
}

1. Function with No Parameters
void sayHello() {
  print('Hello, World!');
}

void main() {
  sayHello();
}


3. Function that Returns a Value
int addNumbers(int a, int b) {
  return a + b;
}

void main() {
  int result = addNumbers(5, 3);
  print('5 + 3 = $result'); // Output: 5 + 3 = 8
}
```
