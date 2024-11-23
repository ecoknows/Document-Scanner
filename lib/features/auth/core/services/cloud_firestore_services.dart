import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner/features/documents/core/image_folder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> newImageFolder() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentReference userDoc = _users.doc(user.uid);
      CollectionReference folders = userDoc.collection('image_folders');

      await folders.add({
        'name': 'New Folder',
      });
    }
  }

  Future<List<ImageFolder>> getImageFolder() async {
    User? user = _auth.currentUser;

    List<ImageFolder> imageFolders = [];

    if (user != null) {
      DocumentReference userDoc = _users.doc(user.uid);
      CollectionReference folders = userDoc.collection('image_folders');

      QuerySnapshot querySnapshot = await folders.get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        Map<String, String> map = {
          "id": doc.id,
          "name": data['name'],
        };

        imageFolders.add(ImageFolder.fromJson(map));
      }
    }

    return imageFolders;
  }

  Future<void> renameFolder(String folderId, String name) async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentReference userDoc = _users.doc(user.uid);
      CollectionReference folders = userDoc.collection('image_folders');
      DocumentReference targetFolder = folders.doc(folderId);

      await targetFolder.update({
        'name': name,
      });
    }
  }
}
