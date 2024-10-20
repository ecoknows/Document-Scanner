import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelpers {
  static Future<String?> getDownloadUrlIfExists(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return null;
      }
      rethrow;
    }
  }

  static Future<void> renameFile(String oldFilePath, String newFilePath) async {
    final storage = FirebaseStorage.instance;

    final oldFileRef = storage.ref(oldFilePath);

    final data = await oldFileRef.getData();

    if (data != null) {
      final newFileRef = storage.ref(newFilePath);
      await newFileRef.putData(data);

      await oldFileRef.delete();
    }
  }
}
