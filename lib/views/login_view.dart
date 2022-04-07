import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email    = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: const InputDecoration(
                        hintText: "Enter your email"
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password,
                    decoration: const InputDecoration(
                        hintText: "Enter your password"
                    ),
                  ),
                  TextButton(
                      onPressed: () async {

                        final email = _email.text.trim();
                        final password = _password.text.trim();
                        try {
                          final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                          Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            log('User not found');
                          } else if (e.code == 'wrong-password'){
                            log('Password incorrect');
                          } else if (e.code == 'invalid-email'){
                            log('Invalid email');
                          }
                        }

                      },
                      child: const Text("Login")
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    },
                    child: const Text('Not registered yet? Register now!')
                  )
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        }),
      );
  }
}
