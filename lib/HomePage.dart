import 'package:flutter/material.dart';
import 'package:healthy_food/PhotoUpload.dart';
import 'Authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Methods
  void _logoutUser() async {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e){
      print( " Error = " + e.toString());
    }

  }

  //design
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: const EdgeInsets.only(left: 70.0 , right: 70.0),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_car_wash),
                iconSize: 50,
                color: Colors.white,
                onPressed : _logoutUser,
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 50.0,
                color: Colors.pinkAccent,
                onPressed: (){
                  Navigator.push
                    (context,
                      MaterialPageRoute(builder: (context){
                        return UploadPhotoPage();
                      })
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
