import 'package:flutter/material.dart';
import 'package:flutter_project/constants/routes.dart';
import 'package:flutter_project/service/auth/auth_service.dart';
import 'package:flutter_project/utilities/show_error_dialog.dart';

import '../service/auth/auth_exception.dart';

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
              onPressed: () async {
                try {
                  await AuthService.firebase().sendVerifiedEmail();
                } on TooManyRequestsAuthException {
                  await showErrorDialog(context, 'Too many requests');
                }

              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.purple
              ),
              child: const Text('Send me a email again', style: TextStyle(color: Colors.white),)
          ),
          TextButton(
              onPressed: () async {
                AuthService.firebase().logOut();
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
