import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ScrollingPage.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({this.title});

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _passwordsEqual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLayoutContainer(context),
    );
  }

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
          _buildConfirmPasswordField(context),
          SizedBox(
            height: 20,
          ),
          _buildSubmitButton(context),
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
    return TextFormField(

      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return TextField(
      onChanged: (str) {
        setState(() {
          if(str == this._passwordController.text)
            _passwordsEqual = true;
          else
            _passwordsEqual = false;
        });
      },
      controller: _passwordConfirmController,
      obscureText: true,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: _passwordsEqual? Colors.teal : Colors.red)),
        labelText: 'Confirm password',
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
          "Sign up",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _onPressedSignUpButton,
      ),
    );
  }



  void _onPressedSignUpButton() {
    if(validateEmail(_emailController.text) != null)
    {
      //TODO: handle incorrect email
      return;
    }
    if(!_passwordsEqual || _passwordConfirmController.text == null)
    {
      //TODO: handle incorrect passwords
      return;
    }
    createUserWithEmailAndPassword(_emailController.text, _passwordConfirmController.text);
    Navigator.pop(context);
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      //AppUtil().showAlert("Email is Required");
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      //AppUtil().showAlert("Invalid Email");
      return "Invalid Email";
    } else {
      return null;
    }
  }

  Future<String>createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
}