import 'package:flutter/material.dart';

class SessionDetailPushNotification extends StatefulWidget {
  const SessionDetailPushNotification({super.key});

  @override
  State<SessionDetailPushNotification> createState() =>
      _SessionDetailPushNotificationState();
}

class _SessionDetailPushNotificationState
    extends State<SessionDetailPushNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SESSION DETAILS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(""),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
