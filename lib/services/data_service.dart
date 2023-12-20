// create a singleton class to handle all the sqflite database related stuff
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DataService {
  Database? _database;
  static final DataService _dataService = DataService._internal();
  // factory DataService() {
  //   return _dataService;
  // }
  DataService._internal();

  static Database get database => _dataService._database! ;
  static DataService get instance => _dataService ;

  Future<void> initDatabase() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = p.join(
        documentsDirectory.path, 'gurbani_database.sqlite/database.sqlite');
    bool exists = await File(path).exists();
    if (!exists) {
      // await _decompressDatabase();
      await decompressAndLoadDatabase();
    }
    _dataService._database = await openDatabase(path);
  }

  @pragma('vm:entry-point')
  static Future<void> decompressAndLoadDatabase() async {
    ByteData data = await rootBundle.load("assets/database.zip");

    ReceivePort receivePort = ReceivePort();
    FlutterIsolate isolate = await FlutterIsolate.spawn(
      _decompressDatabase,
      {"data": data, "sendPort": receivePort.sendPort},
    );

    await for (var msg in receivePort) {
      // print(msg);
      if (msg == 1) {
        isolate.kill();
        receivePort.close();
        break;
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _decompressDatabase(Map<String, dynamic> args) async {
  // static Future<void> _decompressDatabase() async {
    final ByteData data = args['data'];
    // ByteData data = await rootBundle.load("assets/database.zip");
    final SendPort sendPort = args['sendPort'];

    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = "${documentsDirectory.path}/gurbani_database.sqlite";
    File file = File("$path.zip");
    await file.writeAsBytes(bytes, flush: true);

    Archive archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    for (ArchiveFile archiveFile in archive) {
      String fileName = archiveFile.name;
      List<int> data = archiveFile.content;
      File outFile = File("$path/$fileName");
      outFile = await outFile.create(recursive: true);
      await outFile.writeAsBytes(data, flush: true);
    }

    sendPort.send(1); // Finished decompression
  }
}