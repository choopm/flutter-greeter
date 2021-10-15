import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOut extends StatefulWidget {
  const SignOut({
    Key key,
  }) : super(key: key);

  @override
  _SignOutState createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Logout'),
        ),
        body: Scrollbar(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  ...[
                    TextButton(
                      child: Row(
                        children: const [
                          Icon(Icons.logout),
                          Text('Logout'),
                        ],
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove("token");
                        prefs.remove("username");

                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Successfully signed out'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]
                ]))));
  }
}
