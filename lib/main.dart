import 'package:flutter/material.dart';
import 'package:greeter/sign_in.dart';
import 'package:greeter/sign_out.dart';
import 'package:greeter/greeter.dart';
import 'package:http/http.dart' as http;

class GreeterApp extends StatelessWidget {
  GreeterApp({Key key}) : super(key: key) {
    tiles =  [
      Tile(
        route: '/greeter',
        builder: (context) => Greeter(
          httpClient: httpClient,
        ),
      ),
      Tile(
        route: '/login',
        builder: (context) => SignIn(
          httpClient: httpClient,
        ),
      ),
      Tile(
        route: '/logout',
        builder: (context) => const SignOut(),
      ),
    ];
  }

  final http.Client httpClient = http.Client();
  List<Tile> tiles;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1;

    return MaterialApp(
      title: 'greeter',
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: Map.fromEntries(tiles.map((d) => MapEntry(d.route, d.builder))),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('greeter'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, '/greeter');
                },
              ),
              PopupMenuButton(
                onSelected: (value) {
                  Navigator.pushNamed(context, value);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget> [
                        Icon(Icons.login, color: textStyle.color),
                        Text('Login', style: textStyle),
                      ],
                    ),
                    value: '/login',
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.logout, color: textStyle.color),
                        Text('Logout', style: textStyle),
                      ],
                    ),
                    value: '/logout',
                  )
                ],
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Please use the appbar to navigate"),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(GreeterApp());
}

class Tile {
  final String route;
  final WidgetBuilder builder;

  const Tile({this.route, this.builder});
}