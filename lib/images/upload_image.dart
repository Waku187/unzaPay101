//Caution: Only works on Android & iOS platforms
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  late File _imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);

    // Use FirebaseStorage.instance.ref() to get a reference to the root of your storage
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');

    // Use putFile to upload the file
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

    // Wait for the upload to complete and get the TaskSnapshot
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    // Get the download URL of the uploaded image
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Print the download URL
    print("Done: $downloadUrl");
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Firebase Storage Demo'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           _imageFile == null
  //               ? Text('No image selected.')
  //               : Image.file(_imageFile),
  //           ElevatedButton(
  //             onPressed: pickImage,
  //             child: Text('Pick Image'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => uploadImageToFirebase(context),
  //             child: Text('Upload Image'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploading Image to Firebase Storage",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile)
                              : ElevatedButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: ElevatedButton(
              onPressed: () => uploadImageToFirebase(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
