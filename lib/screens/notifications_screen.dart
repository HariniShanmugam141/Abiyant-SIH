import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/translations.dart';

class NotificationsScreen extends StatefulWidget {
  final AppState appState;

  const NotificationsScreen({super.key, required this.appState});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark notifications as read when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.markNotificationsAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = widget.appState.isTamil;
    final notifications = widget.appState.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5A24),
        foregroundColor: Colors.white,
        title: Text(AppTranslations.translate('notifications', isTamil)),
      ),
      body: notifications.isEmpty
          ? _buildEmptyView(isTamil)
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: notification.isRead ? Colors.transparent : const Color(0xFFE8F5E9),
                      width: 1.5,
                    ),
                  ),
                  elevation: notification.isRead ? 0.5 : 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon indicator based on notification context
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? Colors.grey.shade100
                                : const Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(notification.message),
                            color: notification.isRead
                                ? Colors.grey
                                : const Color(0xFF0F5A24),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Text message
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTamil ? notification.messageTamil : notification.message,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatTimestamp(notification.timestamp, isTamil),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Unread Dot
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8, top: 4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyView(bool isTamil) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 15),
          Text(
            isTamil ? 'அறிவிப்புகள் ஏதும் இல்லை.' : 'No notifications yet.',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('payment') || lower.contains('credit') || lower.contains('payout')) {
      return Icons.account_balance_wallet;
    } else if (lower.contains('booking') || lower.contains('confirmed')) {
      return Icons.event_available;
    } else if (lower.contains('quality') || lower.contains('moisture')) {
      return Icons.done_all;
    } else if (lower.contains('queue') || lower.contains('position')) {
      return Icons.people;
    } else if (lower.contains('cancelled')) {
      return Icons.cancel_outlined;
    }
    return Icons.notifications;
  }

  String _formatTimestamp(DateTime time, bool isTamil) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) {
      return isTamil ? 'இப்போது' : 'Just now';
    } else if (diff.inMinutes < 60) {
      return isTamil
          ? '${diff.inMinutes} நிமிடங்களுக்கு முன்பு'
          : '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return isTamil
          ? '${diff.inHours} மணிநேரத்திற்கு முன்பு'
          : '${diff.inHours} hours ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
