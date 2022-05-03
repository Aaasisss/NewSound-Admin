import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(File file, String fileName) async {
    //File file = File(filePath);
    try {
      await storage.ref('photos/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> getDownloadUrl(String fileName) async {
    return await storage.ref('photos/$fileName').getDownloadURL();
  }
}
