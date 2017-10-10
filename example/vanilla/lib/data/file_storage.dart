import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:vanilla/models.dart';

/// Create an abstract class that we can use for both the concrete
/// implementation below and a Mock implementation for testing.
abstract class FileStorage {
  Future<List<Todo>> loadTodos();
  Future<File> saveTodos(List<Todo> todos);
  Future<FileSystemEntity> clean();
}

/// Loads and saves a List of Todos using a text file stored on the device.
class VanillaFileStorage implements FileStorage {
  final String tag;

  VanillaFileStorage(this.tag);

  Future<List<Todo>> loadTodos() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();

    return AppState.fromJson(new JsonDecoder().convert(string)).todos;
  }

  Future<File> saveTodos(List<Todo> todos) async {
    final file = await _getLocalFile();

    return file.writeAsString(
        new JsonEncoder().convert(new AppState(todos: todos).toJson()));
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();

    return new File('${dir.path}/FlutterMvcFileStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}