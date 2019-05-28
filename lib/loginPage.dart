import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ScrollingPage.dart';
import 'package:flutter/services.dart';
import 'signUpPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

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
          _buildSubmitButton(context),
          _buildSignUpText(context),
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

  Widget _buildSignUpText(BuildContext context) {
    return Center(
     child: Column(
       mainAxisSize: MainAxisSize.min,
       children: <Widget>[
         SizedBox(
           height: 20,
         ),
         Text("Don't have an account? "),
         FlatButton(
          textColor: Colors.blue,
          onPressed: _onPressedSignUp,
          child: Text("Sign up"),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent))
       )
      ]
     )
    );
  }

  void _onPressedLoginButton() async {
    if(!_isLoading) {
      _isLoading = true;

      FirebaseAuth _auth = FirebaseAuth.instance;
      var a = _emailController.text;
      var currentUser;
      try {
        currentUser = await _auth.signInWithEmailAndPassword(
          //email: 'mail@gmail.com', password: 'test123');
            email: _emailController.text, password: _passwordController.text);
      }
      on PlatformException catch (error)
      {
        print(error);
        // TODO: display error message
      }

      if(currentUser == null) {
        _isLoading = false;
        return; // TODO: print some error messsage
      }
      Navigator.of(context)
          .push<HomePage>(new MaterialPageRoute(
        builder: (context) =>
            HomePage(),
      ));
      _isLoading = false;
    }
  }

  void _onPressedSignUp() {
    Navigator.of(context)
        .push<SignUpPage>(new MaterialPageRoute(
      builder: (context) =>
          SignUpPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLayoutContainer(context),
    );
  }
}