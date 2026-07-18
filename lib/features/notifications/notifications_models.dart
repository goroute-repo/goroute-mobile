class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.read,
    required this.createdAt,
    this.body,
    this.linkPath,
  });

  final String id;
  final String kind;
  final String title;
  final String? body;
  final String? linkPath;
  final bool read;
  final String createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] as String?) ?? '',
      kind: (json['kind'] as String?) ?? 'info',
      title: (json['title'] as String?) ?? '',
      body: json['body'] as String?,
      linkPath: json['linkPath'] as String?,
      read: json['read'] == true,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }
}

class NotificationsList {
  const NotificationsList({
    required this.unreadCount,
    required this.items,
  });

  final int unreadCount;
  final List<AppNotification> items;

  factory NotificationsList.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    return NotificationsList(
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      items: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}
