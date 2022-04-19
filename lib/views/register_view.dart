import 'package:flutter/material.dart';
import 'package:flutter_project/service/auth/auth_service.dart';

import '../constants/routes.dart';
import '../service/auth/auth_exception.dart';
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
                          await AuthService.firebase().createUser(email: email, password: password);
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(context, 'Email already in use');
                        } on WeakPasswordAuthException {
                          await showErrorDialog(context, 'Weak password');
                        } on InvalidEmailAuthException {
                          await showErrorDialog(context, 'Invalid email');
                        } on GenericAuthException {
                          await showErrorDialog(context, 'Failed to register');
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
