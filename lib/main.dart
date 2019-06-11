import 'package:flutter/material.dart';
import 'ScrollingPage.dart';
import 'cardDisplay.dart';
import 'package:markdown_notes_flutter/loginPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        '/loginscreen': (BuildContext context) => new LoginPage(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name == '/cardDisplay') {
      // FooRoute constructor expects SomeObject
      return _buildRoute(settings, new CardDisplay(settings.arguments));
    }

    return null;
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
