import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SaveFile {
  static Future<File> bytesToFile(List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();

    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');
    //Write PDF data
    return await file.writeAsBytes(bytes, flush: true);
  }

  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }

  static Future<List<int>> readImageData(String name) async {
    File file = File(name);
    Uint8List bytes = file.readAsBytesSync();
    final ByteData data = ByteData.view(bytes.buffer);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static Future<List<int>> readImageDataFromNetwork(String name) async {
    http.Response response = await http.get(
      Uri.parse(name),
    );
    Uint8List bytes = response.bodyBytes; //Uint8List
    final ByteData data = ByteData.view(bytes.buffer);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
