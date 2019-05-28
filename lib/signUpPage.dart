import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markdown_notes_flutter/CardItemModel.dart';

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



  void _onPressedSignUpButton() async {
    if(validateEmail(_emailController.text) != null)
    {
      _showError("Incorrect email");
      return;
    }
    if(!_passwordsEqual || _passwordConfirmController.text == null)
    {
      _showError("Passwords must be the same");
      return;
    }
    try{
      await createUserWithEmailAndPassword(_emailController.text, _passwordConfirmController.text);
    }
    on PlatformException
    {
      _showError("Password should be stronger");
      return;
    }
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

    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = await _auth.currentUser();

    DocumentReference userCardsReference =
    Firestore.instance.collection('cards').document(currentUser.uid);

    List<CardItemModel> cards = new List<CardItemModel>();

    var serializedCards = {
      'cards': cards.map((c) => c.toStore()).toList(),
    };

    await userCardsReference.setData(serializedCards);

    return user.uid;
  }

  void _showError(String title, {String msg = ""})
  {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}