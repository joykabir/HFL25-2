import 'dart:io';

class InputHelper {
  static bool readConfirmation(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.toLowerCase().trim();
    return input == 'yes' || input == 'y';
  }

  static int? readInt(String prompt, {int? min, int? max}) {
    stdout.write(prompt);
    final input = stdin.readLineSync() ?? '';
    final parsed = int.tryParse(input);
    
    if (parsed == null) return null;
    if (min != null && parsed < min) return null;
    if (max != null && parsed > max) return null;
    
    return parsed;
  }

  static String readNonEmpty(String prompt, {String errorMessage = 'Input cannot be empty.'}) {
    while (true) {
      final input = readString(prompt);
      if (input.isNotEmpty) return input;
      print(errorMessage);
    }
  }

  static String readString(String prompt, {String defaultValue = ''}) {
    stdout.write(prompt);
    final input = stdin.readLineSync() ?? '';
    return input.isEmpty ? defaultValue : input.trim();
  }

  static List<String> readStringList(String prompt, {String separator = ','}) {
    stdout.write(prompt);
    final input = stdin.readLineSync() ?? '';
    
    if (input.isEmpty) return <String>[];
    
    return input
        .split(separator)
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}