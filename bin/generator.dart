library generator;

import 'dart:io';
import 'package:args/args.dart';

late String className;
late String username;
late String pass;
late String path;

void main(List<String> arguments) {
  final ArgParser argParser = ArgParser()
    ..addOption('class', abbr: 'c', help: 'The class name to generate.')
    ..addOption('username', abbr: 'u', help: 'The username for connection.')
    ..addOption('path', abbr: 'p', help: 'The path for the generated file.')
    ..addOption('pass', abbr: 'r', help: 'The path for the generated file.');

  final ArgResults argResults = argParser.parse(arguments);

  className = argResults['class'] ?? '';
  username = argResults['username'] ?? '';
  path = argResults['path'] ?? '';
  pass = argResults['pass'] ?? '';

  if (className.isEmpty || username.isEmpty || path.isEmpty) {
    print('Please specify class, username, and path');
    return;
  }

  generateModel();
}

void generateModel() async {
  //Путь до файла шаблона
  final templateFile = File('assets/templates/model_template.txt');

  //Путь до выходного файла
  final outputFile = File('${Directory.current.path}/$path/${className}_module.dart');

  // Создание директорий, если путь не существует
  outputFile.parent.createSync(recursive: true);

  String templateData = await templateFile.readAsString();

  //Замена значений переменных шаблонов
  String populatedData = templateData
      .replaceAll('{{className}}', '${className[0].toUpperCase()}${className.substring(1)}')
      .replaceAll('{{username}}', username)
      .replaceAll('{{pass}}', pass);

  //Запись содержимого в файл
  outputFile.writeAsStringSync(populatedData);

  print('File is created at $path/${className}_model.dart');
}