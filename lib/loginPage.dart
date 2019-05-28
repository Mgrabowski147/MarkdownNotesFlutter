import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ScrollingPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Widget _buildLayoutContainer(BuildContext context) {
    return SingleChildScrollView(
      child: _buildFormWrapper(context),
    );
  }

  Widget _buildFormWrapper(BuildContext context) {
    return Form(
      child: _buildLoginLayout(context),
    );
  }

  Widget _buildLoginLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          //_buildTopLogo(context),
          _buildUsernameField(context),
          SizedBox(
            height: 20,
          ),
          _buildPasswordField(context),
          SizedBox(
            height: 20,
          ),
          _buildSubmitButton(context)
        ],
      ),
    );
  }

  Widget _buildTopLogo(BuildContext context) {
    return SizedBox(
      child: Image.asset("assets/logo.png"),
      height: 200,
      width: 200,
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return TextField(
    controller: _emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      filled: true,
      fillColor: Colors.white,
    ));
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      child: RaisedButton(
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _onPressedLoginButton,
      ),
    );
  }

  void _onPressedLoginButton() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var a = _emailController.text;
    var currentUser = await _auth.signInWithEmailAndPassword(
      //email: 'mail@gmail.com', password: 'test123');
        email: _emailController.text, password: _passwordController.text);
    if(currentUser == null)
      return; // TODO: print some error messsage
    Navigator.of(context)
        .push<HomePage>(new MaterialPageRoute(
      builder: (context) =>
          HomePage(currentUser.uid),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLayoutContainer(context),
    );
  }
}