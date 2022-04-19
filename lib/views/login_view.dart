import 'package:flutter/material.dart';
import 'package:flutter_project/service/auth/auth_exception.dart';
import 'package:flutter_project/service/auth/auth_service.dart';
import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
        future: AuthService.firebase().initialize(),
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
                          final user = await AuthService.firebase().logIn(email: email, password: password);
                          if (user.isEmailVerified) {
                            Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                          }
                        } on UserNotFoundAuthException {
                          await showErrorDialog(context, 'User not found');
                        } on WrongPasswordAuthException {
                          await showErrorDialog(context, 'Incorrect password');
                        } on GenericAuthException {
                          await showErrorDialog(context, 'Failed to login');
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
