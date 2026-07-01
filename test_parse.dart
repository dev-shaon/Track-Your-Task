void main() {
  String timeStr = "10:00\u202FAM";
  print("Contains AM: ${timeStr.contains('AM')}");
  String cleaned = timeStr.replaceAll('AM', '').replaceAll('PM', '').trim();
  print("Cleaned: '$cleaned'");
  try {
    List<String> parts = cleaned.split(':');
    int hour = int.parse(parts[0].trim());
    int minute = int.parse(parts[1].trim());
    print("Parsed: $hour:$minute");
  } catch (e) {
    print("Error: $e");
  }
}
