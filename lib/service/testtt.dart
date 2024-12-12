import 'package:flutter/material.dart';
import 'package:hankammeleducation/service/firebase_notification_service.dart';


class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    updateNotificationCount();
  }

  void updateNotificationCount() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  void refreshNotifications() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications "),
        actions: [
          // الأيقونة مع عداد الإشعارات
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NotificationsPopup(
                        onRefresh: refreshNotifications,
                      );
                    },
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: notificationCount > 0
                    ? Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$notificationCount',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                    : SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Text("Main Content Here"),
      ),
    );
  }
}

class NotificationsPopup extends StatelessWidget {
  final VoidCallback onRefresh;

  const NotificationsPopup({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = FirebaseNotificationService.getNotifications();
    return AlertDialog(
      title: Text("Notifications"),
      content: notifications.isEmpty
          ? Text("No notifications.")
          : Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]['title']),
              subtitle: Text(notifications[index]['body']),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onRefresh();
            Navigator.pop(context);
          },
          child: Text("Refresh"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
