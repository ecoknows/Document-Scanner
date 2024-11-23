class StringHelper {
  static bool isUrl(String input) {
    final urlRegex = RegExp(r'^(http|https|ftp):\/\/[^\s/$.?#].[^\s]*$');
    return urlRegex.hasMatch(input);
  }

  static String extractFileName(String filename) {
    final regex = RegExp(r'^(\d+)(?:\.\d+\.jpg)$');
    final match = regex.firstMatch(filename);

    if (match != null) {
      return match.group(1) ?? ''; // Return the numeric part before the .0.jpg
    } else {
      return ''; // Return empty if it doesn't match the expected pattern
    }
  }

  static String getFileName(String string) {
    if (isUrl(string)) {
      // Parse the URL
      Uri uri = Uri.parse(string);

      // Get the path of the URL and split it by "/"
      List<String> pathSegments = uri.pathSegments;

      // The last segment will be the file name
      String fileName = pathSegments.isNotEmpty ? pathSegments.last : '';
      return extractFileName(fileName);
    } else {
      String fileName = string.split('/').last;

      return extractFileName(fileName);
    }
  }
}
