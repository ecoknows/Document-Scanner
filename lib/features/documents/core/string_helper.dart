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

  static String getFileFullName(String string) {
    if (isUrl(string)) {
      // Parse the URL
      Uri uri = Uri.parse(string);

      // Get the path of the URL and split it by "/"
      List<String> pathSegments = uri.pathSegments;

      // The last segment will be the file name
      String fileName = pathSegments.isNotEmpty ? pathSegments.last : '';
      return fileName;
    } else {
      String fileName = string.split('/').last;

      return fileName;
    }
  }

  static String getFileName(String string) {
    String fileName = string.split('/').last;

    return extractFileName(fileName);
  }

  static String getDocumentName(String url) {
    // Regular expression to match the dynamic part of the URL
    RegExp regExp = RegExp(r'%2F(\d+)%2F\1');

    // Match the URL with the RegExp
    Match? match = regExp.firstMatch(url);

    // Return the matched value if found, otherwise return an empty string
    return match != null ? match.group(1)! : '';
  }
}
