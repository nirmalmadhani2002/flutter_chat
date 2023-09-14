import 'package:chat_flutter/Modal/ChatUser.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          foregroundImage: NetworkImage(widget.user.image),
        ),
        title: Text(widget.user.name),
        subtitle: Text(widget.user.about),
        trailing: Text("12:00n AM"),
      ),
    );
  }
}
