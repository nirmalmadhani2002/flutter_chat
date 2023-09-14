import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../APIs/APIs.dart';
import '../Helper/firebase_helper.dart';
import '../Modal/ChatUser.dart';
import 'ChatUserCard.dart';
import 'LoginPage.dart';

class MyHomePage extends StatefulWidget {
  final ChatUser user;

  const MyHomePage({super.key, required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _list = [];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) async {
                    Navigator.pop(context);
                    await FirebaseAuthHelper.firebaseAuthHelper.logOut();
                    //for moving to home screen
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginPage()));
                  });
                });

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Form(
                key: formKey,
                child: AlertDialog(
                  title: Text("update user name"),
                      actions: [
                        TextFormField(
                          initialValue: widget.user.name,
                          onSaved: (val) => APIs.me.name = val ?? '',
                          validator: (val) => val != null && val.isNotEmpty
                              ? null
                              : 'Required Field',
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.blue),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: 'eg. Happy Singh',
                              label: const Text('Name')),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: Size(20, 10)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              APIs.updateUserInfo().then((value) {

                              });
                            }
                          },
                          icon: const Icon(Icons.edit, size: 28),
                          label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
              ));
        },
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
