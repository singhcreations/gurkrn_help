import 'dart:io';
import 'dart:isolate';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
//run krke dikhao

class _SplashScreenState extends State<SplashScreen> {
  bool initializingDatabase = false;
  late ReceivePort receivePort;
  late FlutterIsolate isolate;

  Future<void> decompressAndLoadDatabase() async {
    setState(() {
      initializingDatabase = true;
    });
    ByteData data = await rootBundle.load("assets/database.zip");

    receivePort = ReceivePort();
    isolate = await FlutterIsolate.spawn(
      _decompressDatabase,
      {"data": data, "sendPort": receivePort.sendPort},
    );
  }

  static void _decompressDatabase(Map<String, dynamic> args) async {
    final ByteData data = args['data'];
    final SendPort sendPort = args['sendPort'];

    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
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

  Future<bool> checkDatabaseExists() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(
        documentsDirectory.path, 'gurbani_database.sqlite/database.sqlite');
    return File(path).exists();
  }

  Future _initDatabase() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Now you can open the database
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = p.join(
          documentsDirectory.path, 'gurbani_database.sqlite/database.sqlite');
      Database db = await openDatabase(path, readOnly: false, version: 1);

      //You can use this instance anywhere in the app...
      GetIt.I.registerSingleton<Database>(db);
    }
  }

  @override
  void initState() {
    super.initState();

    checkDatabaseExists().then((exists) async {
      if (!exists) {
        await decompressAndLoadDatabase();

        receivePort.listen((message) async {
          if (message == 1) {
            isolate.kill();
            receivePort.close();

            //initialize database once its ready to use...
            await _initDatabase();

            GoRouter.of(context).replace('/home');
          }
        });
      } else {
        Future.delayed(const Duration(seconds: 2, milliseconds: 500), () async {
          //initialize database when you know its already ready to use...
          await _initDatabase();

          GoRouter.of(context).replace('/home');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 0.3.sw,
                child: const Image(
                  image: AssetImage('assets/images/play_store_512.png'),
                ),
              ),
            ),
            SizedBox(
              height: 38.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "The ਗੁਰਬਾਣੀ App",
                  style: TextStyle(
                    fontFamily: "Gurmukhi-Bold",
                    fontSize: 32.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.sp,
            ),
            Container(
              width: 1.sw,
              height: 80.sp,
              padding: EdgeInsets.symmetric(horizontal: 28.sp),
              child: initializingDatabase
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please wait",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Regular",
                                  fontSize: 14.sp,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              width: 12.sp,
                            ),
                            SizedBox(
                              width: 16.sp,
                              height: 16.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 1.6,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat-Regular',
                              color: Colors.black),
                          textAlign: TextAlign.center,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText(
                                  'Initiating divine connection'),
                              RotateAnimatedText(
                                  'Fetching insights from Gurbani'),
                              RotateAnimatedText(
                                  'Bringing eternal wisdom to your fingertips'),
                              RotateAnimatedText(
                                  'Loading interpretations from Sri Guru Granth Sahib Ji'),
                              RotateAnimatedText(
                                  'Gathering celestial blessings'),
                              RotateAnimatedText(
                                  'Loading spiritual discourses'),
                              RotateAnimatedText(
                                  'Your gateway to divine understanding is unfolding'),
                              RotateAnimatedText('Aligning sacred teachings'),
                              RotateAnimatedText(
                                  'Almost there, holding the blessings...'),
                            ],
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please wait",
                          style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                              fontSize: 14.sp),
                        ),
                        SizedBox(
                          width: 12.sp,
                        ),
                        SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.6,
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
