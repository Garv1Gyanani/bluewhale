import 'dart:io';

/// Blue Whale CLI
/// Simple code generator for developers
/// Run via: dart run blue_whale create tank my_feature

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('🐋 Blue Whale CLI');
    print('Usage: dart run blue_whale create <template> <name>');
    print('Available templates: tank, surface');
    return;
  }

  final command = arguments[0];
  if (command == 'create' && arguments.length >= 3) {
    final template = arguments[1];
    final name = arguments[2];
    
    _generateTemplate(template, name);
  } else {
    print('Invalid command. Try: dart run blue_whale create tank auth');
  }
}

void _generateTemplate(String template, String name) {
  final className = _snakeToCamelCase(name);
  final directory = Directory('lib/features/$name');
  
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  if (template == 'tank') {
    _createFile(
      '${directory.path}/${name}_tank.dart',
      '''
import 'package:blue_whale/blue_whale.dart';

class ${className}Tank extends Controller {
  // Dependencies or explicit logic
  
  @override
  void onInit() {
    super.onInit();
    // Logic on creation
  }
}
'''
    );
    
    _createFile(
      '${directory.path}/${name}_state.dart',
      '''
import 'package:blue_whale/blue_whale.dart';

// Signals / Pods for $className
final ${name}Loading = state(false);
final ${name}Data = state('');
'''
    );
    
    _createFile(
      '${directory.path}/${name}_surface.dart',
      '''
import 'package:flutter/material.dart';
import 'package:blue_whale/blue_whale.dart';
import '${name}_state.dart';
import '${name}_tank.dart';

class ${className}Surface extends StatelessWidget {
  const ${className}Surface({super.key});

  @override
  Widget build(BuildContext context) {
    return WhaleScope(
      setup: (scope) => scope.lazyPut(() => ${className}Tank()),
      child: Scaffold(
        appBar: AppBar(title: const Text('$className')),
        body: Center(
          child: View(() {
            if (${name}Loading()) {
              return const CircularProgressIndicator();
            }
            return Text('Data: \${${name}Data()}');
          }),
        ),
      ),
    );
  }
}
'''
    );
    print('✅ Successfully generated $className Tank ecosystem in lib/features/$name/');
  }
}

String _snakeToCamelCase(String text) {
  return text.split('_').map((word) => 
    word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()
  ).join('');
}

void _createFile(String path, String content) {
  final file = File(path);
  file.writeAsStringSync(content.trim());
}
