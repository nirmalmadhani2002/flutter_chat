import 'package:flutter/material.dart';

import '../APIs/APIs.dart';
import '../Helper/firebase_helper.dart';
import '../Modal/ChatUser.dart';
import 'ChatUserCard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuthHelper.firebaseAuthHelper.logOut();

                Navigator.pushReplacementNamed(context, '/');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                        "Log Out successful...",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                      behavior: SnackBarBehavior.floating),
                );
              },
              icon: Icon(Icons.logout))
        ],
        title: const Text("Chat Apps"),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                return ListView.builder(
                    itemCount: _list.length,
                    padding: EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: _list[index]);
                    });
              } else {
                return const Center(
                  child: Text('No Connections Found!',
                      style: TextStyle(fontSize: 20)),
                );
              }
          }
        },
      ),
    );
  }
}
