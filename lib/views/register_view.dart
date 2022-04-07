import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../firebase_options.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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
                          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                          log(userCredential.toString());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            await showErrorDialog(context, 'Email already in use');
                          } else if (e.code == 'weak-password'){
                            await showErrorDialog(context, 'Weak password');
                          } else if (e.code == 'invalid-email'){
                            await showErrorDialog(context, 'Invalid email');
                          } else {
                            await showErrorDialog(context, 'Error: ${e.code}');
                          }
                        } catch (e) {
                          await showErrorDialog(context, e.toString());
                        }
                      },
                      child: const Text("Register")
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                      },
                      child: const Text('Already registered? Login now!')
                  )
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
