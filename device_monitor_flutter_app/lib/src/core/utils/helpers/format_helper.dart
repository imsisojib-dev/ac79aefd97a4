import 'package:intl/intl.dart';

class FormatHelper {
  static String getTimeAgo(DateTime? timestamp) {
    if (timestamp == null) return "N/A";
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  static String formatDateTimeForServer(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  }

  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  static String formatCondition(String condition) {
    return condition.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

}
