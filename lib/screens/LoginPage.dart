import 'package:chat_flutter/Modal/ChatUser.dart';
import 'package:chat_flutter/screens/MyHomePage.dart';
import 'package:flutter/material.dart';

import '../APIs/APIs.dart';
import '../Helper/firebase_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 50),
          ),
          onPressed: () async {
            Map<String, dynamic> res =
                await FirebaseAuthHelper.firebaseAuthHelper.singWithGoogle();

            if (res['user'] != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                      "Login successful...",
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating),
              );

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) =>  MyHomePage(user:APIs.me ,)));
              FirebaseAuthHelper.firebaseAuthHelper
                  .singWithGoogle()
                  .then((user) async {
                Navigator.pop(context);

                if ((await APIs.userExists())) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) =>  MyHomePage(user:APIs.me ,)));
                } else {
                  await APIs.createUser().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) =>  MyHomePage(user: APIs.me,)));
                  });
                }
              });
            } else if (res['error'] != null) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(res['error']),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ), // SnackBar
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                      "Login failed...",
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating),
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset("images/google.png"),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Google",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
