import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UploadPhotoPage extends StatefulWidget
{
  State<StatefulWidget> createState ()
  {
    return _UploadPhotoPageState();
  }

}
class _UploadPhotoPageState extends  State<UploadPhotoPage>
{
  File sampleImage ;
  String _myValue;
  String url;
  final formkey = GlobalKey <FormState>();



  //methods
  Future getImage()async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage ;
    });

  }
  void uploadStatusImage()async{
    if(validateAndSave())
      {
        final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post images");
        var timeKey = DateTime.now();
        final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() +".jpg").putFile(sampleImage);
        var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        url = ImageUrl.toString();
        print("Image url " + url);
        goToHomePage ();
        saveToDatabase(url);
      }

  }

  void saveToDatabase(url)
  {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d,yyyy');
    var formatTime = DateFormat('EEEE ,hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data =
    {
      "image" :url ,
      "description " :_myValue,
      "date" :date,
      "time" :time,

    };

    ref.child("posts").push().set(date);


  }

  void goToHomePage ()
  {
     Navigator.push
       (
         context,
         MaterialPageRoute(builder: (context)
             {
               return HomePage();
             }
         )

     );
  }

  bool validateAndSave(){
    final form = formkey.currentState;
    if (form.validate())
      {
        form.save();
        return true;
      }
    else{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold (

      appBar:  AppBar(
        title: Text("Upload Photo"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an Image "): enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Add Image ",
        child: Icon(Icons.add_a_photo),
      ),

    );
  }

 Widget enableUpload (){
    return Container (
     child:  Form(

       key: formkey,
       child: Column (
         children: <Widget>[
           Image.file(sampleImage,height: 310.0,width: 660.0,),
           SizedBox(height: 15.0,),
           TextFormField(
               decoration: InputDecoration (
                 labelText:  "Description",
               ),
               validator: (value){
                 return value.isEmpty ? 'Description is required  ': null;
               },
               onSaved: (value)
               {
                 return _myValue = value;
               }

           ),

           SizedBox(height: 15.0,),
           RaisedButton(
             elevation: 10.0,
             child: Text("Add new post "),
             textColor: Colors.white,
             color: Colors.pink,
             onPressed: uploadStatusImage,
           )


         ],
       ),


     ),
    );

 }
}