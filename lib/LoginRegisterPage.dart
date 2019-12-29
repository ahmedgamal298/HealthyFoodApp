import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'Authentication.dart';
import 'DialogBox.dart';
class LoginRegisterPage extends StatefulWidget {
  static String tag = "login_page";
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  //define aconstructor
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();
  final _formkey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';

  //Methods
  bool validateAndSave() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "Congrats", "You are loged in  ");

          print("login userId = " + userId);
        }
        else {
          String userId = await widget.auth.signup(_email, _password);
          //dialogBox.information(context, "Congrats", "your account created successfuly ");
          print("Register userId = " + userId);

        }
      widget.onSignedIn();
      }
      catch (e) {
        dialogBox.information(context, "Error", e.toString());
        print("Error = "+e.toString());
      }
    }
  }

  void moveToRegister() {
    _formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInput() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInput() {
    return [
      SizedBox(
        height: 30.0,
      ),
      logo(),
      SizedBox(
        height: 25.0,
      ),
      TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter your email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
        validator: (value) {
          return value.isEmpty ? 'Email is required ' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (value) {
          return value.isEmpty ? 'Password is required ' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }
  Widget logo() {
    return Hero(
      tag: "hero",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset(
          'assets/images/logo.jpg',
        ),
      ),
    );
  }

  List<Widget> createButtons() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: validateAndSubmit,
          padding: EdgeInsets.all(12),
          color: Colors.pink,
          child: Text(
            "Log In",
            style: TextStyle(color: Colors.white, fontSize: 17.0),
          ),
        ),
      ),
      FlatButton(
        child: Text(
          'Dont have an account ? Register',
          style: TextStyle(color: Colors.purple, fontSize: 15),
        ),
        onPressed: moveToRegister,
      ),
    ];
  }
}
