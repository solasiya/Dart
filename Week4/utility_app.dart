import 'dart:io';
import 'dart:convert';

void main() async {
  final logFile = File('log.txt');
  final dataFile = File('data.json');
  
  Map<String, dynamic> data = {};
  
  if (await dataFile.exists()) {
    String contents = await dataFile.readAsString();
    data = json.decode(contents);
  }
  
  while (true) {
    print('\nEnter a string (or "quit" to exit):');
    String input = stdin.readLineSync() ?? '';
    
    if (input.toLowerCase() == 'quit') break;
    
    // String manipulation
    String manipulated = manipulateString(input);
    
    // Store in collection
    String timestamp = DateTime.now().toIso8601String();
    data[timestamp] = {
      'original': input,
      'manipulated': manipulated,
    };
    
    // Log the entry
    await logEntry(logFile, timestamp, input);
    
    print('Manipulated string: $manipulated');
  }
  
  // Save data to file
  await dataFile.writeAsString(json.encode(data));
  
  print('Data saved. Goodbye!');
}

String manipulateString(String input) {
  String concatenated = input + ' - manipulated';
  String interpolated = 'Original: $input';
  String substring = input.length > 5 ? input.substring(0, 5) : input;
  String upperCase = input.toUpperCase();
  String lowerCase = input.toLowerCase();
  String reversed = input.split('').reversed.join('');
  int length = input.length;
  
  return '''
Concatenated: $concatenated
Interpolated: $interpolated
Substring (first 5 chars): $substring
Uppercase: $upperCase
Lowercase: $lowerCase
Reversed: $reversed
Length: $length
''';
}

Future<void> logEntry(File logFile, String timestamp, String input) async {
  String logEntry = '$timestamp: Processed "$input"\n';
  await logFile.writeAsString(logEntry, mode: FileMode.append);
}