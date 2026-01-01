
class TimeParser {
  static int parseToSeconds(String time) {
    try {
      final parts = time.split(' ');
      if (parts.isNotEmpty) {
        return int.tryParse(parts.first) ?? 30;
      }
      return 30;
    } catch (_) {
      return 30;
    }
  }
}