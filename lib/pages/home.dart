import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:vca_app2/api/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // defining constant data placeholders
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late Uint8List imgBytes;
  TextEditingController nameController = TextEditingController();

  // routine to call a snackbar
  void displaySnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // sending the image bytestream
  void sendByteStream() async {
    if (imgBytes.isNotEmpty) {
      var request = await http.post(Uri.parse(APIRoutes.uploadRoute),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'bytes': imgBytes,
            'fileName': nameController.text
          }));

      if (request.statusCode == 200) {
        displaySnackBar('Image successfuly uploaded to the server');
      } else {
        displaySnackBar('Image not uploaded, some error occured');
      }
    } else {
      displaySnackBar('Image not selected');
    }
  }

  // routine to select image
  void openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        print(imagepath);
        // clearing the name controller
        nameController.clear();
        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes =
            await imagefile.readAsBytes(); //converting image to bytes
        // displaying snackbar for successful image load
        displaySnackBar('Image loaded!');
        // saving the imagebytes in an array to send
        setState(() {
          imgBytes = imagebytes;
        });
      } else {
        displaySnackBar('No image is selected');
      }
    } catch (e) {
      displaySnackBar('Error while picking file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Culprit Detector")),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              imagepath != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(File(imagepath)),
                    )
                  : const Text("No Image selected."),
              imagepath != ""
                  ? TextField(
                      decoration: const InputDecoration(
                          hintText: 'file name to be saved'),
                      controller: nameController,
                    )
                  : Container(),
              //open button ----------------
              ElevatedButton(
                  onPressed: () {
                    openImage();
                  },
                  child: const Text("Open Image")),
              ElevatedButton(
                  onPressed: () {
                    sendByteStream();
                  },
                  child: const Text("Send Image"))
            ]),
          ),
        ));
  }
}
