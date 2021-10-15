import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in.g.dart';

@JsonSerializable()
class FormData {
  String username;
  String password;

  FormData({
    this.username,
    this.password,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

@JsonSerializable()
class ResponseData {
  String message;
  String username;
  String token;

  ResponseData({
    this.message,
    this.username,
    this.token
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

class SignIn extends StatefulWidget {
  final http.Client httpClient;

  const SignIn({
    this.httpClient,
    Key key,
  }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FormData formData = FormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Your username',
                      labelText: 'Username',
                    ),
                    onChanged: (value) {
                      formData.username = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      formData.password = value;
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: const [
                        Icon(Icons.login),
                        Text('Login'),
                      ],
                    ),
                    onPressed: () async {
                      // Use a JSON encoded string to send
                      var result = await widget.httpClient.post(
                          'https://test.0pointer.org/auth',
                          body: json.encode(formData.toJson()),
                          headers: {'content-type': 'application/json'});

                      var resp = ResponseData.fromJson(json.decode(result.body));

                      if (result.statusCode == 200) {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString("token", resp.token);

                        _showDialog('Successfully signed in: '+resp.username);
                      } else {
                        _showDialog('Unable to sign in: '+resp.message);
                      }
                    },
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
