import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

enum AuthStatus { notSignIn, signedIn }

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignIn;

  @override
  void iniState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus =
            firebaseUserId == null ? AuthStatus.notSignIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signout() {
    setState(() {
      authStatus = AuthStatus.notSignIn;
    });
  }

  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignIn:
        return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:
        return new HomePage(auth: widget.auth, onSignedOut: _signout);
    }
    return null;
  }
}
