import 'dart:io';

void main() {
  SimpleCalculator calculator = SimpleCalculator();
  calculator.run();
}

class SimpleCalculator {
  static const String _welcomeMessage = '=== Simple Calculator for New Dart Programmers ===';
  static const String _supportedOperations = 'Supports: Addition (+) and Subtraction (-) only';
  static const String _quitCommand = 'quit';
  
  void run() {
    _displayWelcomeMessage();
    
    while (true) {
      print('\n--- New Calculation ---');
      
      try {
        int firstNumber = _getIntegerFromUser('Enter the first integer (or "$_quitCommand" to exit): ', allowQuit: true);
        int secondNumber = _getIntegerFromUser('Enter the second integer: ');
        String operation = _getOperationFromUser();
        int result = performCalculation(firstNumber, secondNumber, operation);
        _displayResult(firstNumber, secondNumber, operation, result);
        
      } on QuitException {
        _displayGoodbyeMessage();
        break;
        
      } catch (error) {
        _displayErrorMessage('An unexpected error occurred: $error');
      }
    }
  }
  
  // Made public for testing
  int performCalculation(int num1, int num2, String operation) {
    return switch (operation) {
      '+' => num1 + num2,
      '-' => num1 - num2,
      _ => throw Exception('Unsupported operation: $operation'),
    };
  }
  
  // Made public for testing
  String getOperationName(String operation) {
    return switch (operation) {
      '+' => 'Addition',
      '-' => 'Subtraction', 
      _ => 'Unknown Operation',
    };
  }
  
  void _displayWelcomeMessage() {
    print(_welcomeMessage);
    print(_supportedOperations);
    print('Type "$_quitCommand" at any number prompt to exit the program.\n');
  }
  
  int _getIntegerFromUser(String prompt, {bool allowQuit = false}) {
    while (true) {
      stdout.write(prompt);
      String? userInput = stdin.readLineSync();
      String cleanInput = userInput?.trim() ?? '';
      
      if (allowQuit && cleanInput.toLowerCase() == _quitCommand) {
        throw QuitException();
      }
      
      try {
        int number = int.parse(cleanInput);
        return number;
        
      } on FormatException {
        _displayErrorMessage('Please enter a valid integer!');
      }
    }
  }
  
  String _getOperationFromUser() {
    while (true) {
      stdout.write('Choose operation (+) for addition or (-) for subtraction: ');
      String? userInput = stdin.readLineSync();
      String operation = userInput?.trim() ?? '';
      
      switch (operation) {
        case '+':
        case '-':
          return operation;
        default:
          _displayErrorMessage('Invalid operation! Please enter + or -');
      }
    }
  }
  
  void _displayResult(int num1, int num2, String operation, int result) {
    print('\n✅ --- RESULT ---');
    String operationName = getOperationName(operation);
    print('Operation: $operationName');
    print('Calculation: $num1 $operation $num2 = $result');
  }
  
  void _displayErrorMessage(String message) {
    print('❌ Error: $message');
  }
  
  void _displayGoodbyeMessage() {
    print('\n👋 Thank you for using the Simple Calculator!');
    print('Happy coding with Dart! 🎯');
  }
}

class QuitException implements Exception {}