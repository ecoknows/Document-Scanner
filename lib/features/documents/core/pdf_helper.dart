import 'dart:io'; // For File and Directory
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:path_provider/path_provider.dart'; // To get local directories

class PdfHelper {
  static Future<File> pdfUrlToFile(String pdfUrl, String fileName) async {
    try {
      // Get the application's temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName.pdf';

      // Fetch the image data from the URL
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        // Write the image data to a file
        final file = File(filePath);
        return await file.writeAsBytes(response.bodyBytes);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error downloading image: $e');
      rethrow;
    }
  }
}
