import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'greeter.g.dart';

@JsonSerializable()
class FormData {
  String name;

  FormData({
    this.name,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

@JsonSerializable()
class ResponseData {
  String message;
  String greeting;

  ResponseData({
    this.message,
    this.greeting,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

class Greeter extends StatefulWidget {
  final http.Client httpClient;

  const Greeter({
    this.httpClient,
    Key key,
  }) : super(key: key);

  @override
  _GreeterState createState() => _GreeterState();
}

class _GreeterState extends State<Greeter> {
  FormData formData = FormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                      hintText: 'Your name',
                      labelText: 'Name',
                    ),
                    onChanged: (value) {
                      formData.name = value;
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: const [
                        Icon(Icons.home),
                        Text('hello'),
                      ],
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String token = prefs.getString("token");
                      token ??= "";
                      formData.name ??= "";

                      var result = await widget.httpClient.get(
                          'https://test.0pointer.org/api/hello?name=' + formData.name,
                          headers: {
                            'content-type': 'application/json',
                            'authorization': 'Bearer '+token,
                          });

                      var resp = ResponseData.fromJson(json.decode(result.body));
                      if (result.statusCode == 200) {
                        _showDialog('Success: '+resp.greeting);
                      } else {
                        _showDialog('Failure: '+resp.message);
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
