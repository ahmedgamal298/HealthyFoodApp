import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'Authentication.dart';
import 'DialogBox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LoginForm.dart';
import 'SignupForm.dart';


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
          dialogBox.information(context, "Congrats", "You are loged in  ");

          print("login userId = " + userId);
        }
        else {
          String userId = await widget.auth.signup(_email, _password);
          dialogBox.information(context, "Congrats", "your account created successfuly ");
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
  bool formVisible;
  int _formsIndex;
  @override
  void initState() {
    super.initState();
    formVisible = false;
    _formsIndex = 1;
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.black54,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: kToolbarHeight + 40),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Welcome",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 30.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "Welcome to this awesome login app. \n You are awesome.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            " ~Ahmed Gamal",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text("Login"),
                            onPressed: () {
                              setState(() {
                                formVisible = true;
                                _formsIndex = 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.grey.shade700,
                            textColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text("Signup"),
                            onPressed: () {
                              setState(() {
                                formVisible = true;
                                _formsIndex = 2;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    OutlineButton.icon(
                      borderSide: BorderSide(color: Colors.red),
                      color: Colors.red,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      icon: Icon(FontAwesomeIcons.google),
                      label: Text("Continue with Google"),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: (!formVisible)
                    ? null
                    : Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            textColor: _formsIndex == 1
                                ? Colors.white
                                : Colors.black,
                            color:
                            _formsIndex == 1 ? Colors.red : Colors.white,
                            child: Text("Login"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              setState(() {
                                _formsIndex = 1;
                              });
                            },
                          ),
                          const SizedBox(width: 10.0),
                          RaisedButton(
                            textColor: _formsIndex == 2
                                ? Colors.white
                                : Colors.black,
                            color:
                            _formsIndex == 2 ? Colors.red : Colors.white,
                            child: Text("Signup"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              setState(() {
                                _formsIndex = 2;
                              });
                            },
                          ),
                          const SizedBox(width: 10.0),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                formVisible = false;
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child:
                          _formsIndex == 1 ? LoginForm() : SignupForm(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }



  //extra

}
