import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text('We have sent an email. Follow the link in the email to verify your email address.'),
          const Text('If you have not received a verification email yet, click the button below'),
          TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.purple
              ),
              child: const Text('Send me a email again', style: TextStyle(color: Colors.white),)
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.purple
              ),
              child: const Text('Restart', style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
    );
  }
}
