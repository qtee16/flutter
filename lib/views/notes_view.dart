import 'package:flutter/material.dart';
import 'package:flutter_project/service/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_actions.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch(value) {
                  case MenuAction.logout:
                    final resultLogout = await showLogOutDialog(context);
                    if (resultLogout) {
                      AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Log out')
                  )
                ];
              })
        ],
      ),
      body: const Text('Hello world'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold),),
          content: const Text('Are you sure you want to sign out ?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No')
            ),
          ],
        );
      }
  ).then((value) => value ?? false);
}