class FormatHelper {
  static String getTimeAgo(DateTime? timestamp) {
    if (timestamp == null) return "N/A";
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
