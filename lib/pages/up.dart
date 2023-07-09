import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:vca_app2/api/api.dart';

class UploadingClass extends StatefulWidget {
  final String imagePath;
  final String fileName;
  final Uint8List byteStream;
  const UploadingClass(
      {Key? key,
      required this.imagePath,
      required this.fileName,
      required this.byteStream})
      : super(key: key);

  @override
  State<UploadingClass> createState() => _UploadingClassState();
}

class _UploadingClassState extends State<UploadingClass> {
  // defining constant data placeholders
  bool uploaded = false;
  bool classified = false;
  bool pressed = false;
  String img = 'class';

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

  // routine to send byte stream to the server
  void sendByteStream() async {
    // delay of 2 seconds before sending the byte stream of images
    Future.delayed(const Duration(seconds: 2));
    // sending the upload data
    if (widget.byteStream.isNotEmpty) {
      var request = await http.post(Uri.parse(APIRoutes.uploadRoute),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'bytes': widget.byteStream,
            'fileName': widget.fileName
          }));

      if (request.statusCode == 200) {
        displaySnackBar('Image successfully uploaded to the server!');
        // setting the upload semaphore to true
        setState(() {
          uploaded = true;
        });
      } else {
        displaySnackBar('Some error occured uploading the image');
      }
    } else {
      displaySnackBar('Image not selected');
    }
  }

  // routine to get classification response
  void getClass() async {
    setState(() {
      pressed = true;
    });
    var request = await http.post(Uri.parse(APIRoutes.classificationRoute),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, dynamic>{'fileName': widget.fileName})); // problem is here

    var res = jsonDecode(request.body);

    if (request.statusCode == 200) {
      setState(() {
        img = res['class'];
        classified = true;
        pressed = false;
      });
    }
  }

  // intializing state of the page
  @override
  void initState() {
    sendByteStream();
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text(
          'Maftec',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: !uploaded
          ? const Center(
              child: SizedBox(
                  height: 300, width: 300, child: CircularProgressIndicator()),
            )
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Stack(
                      children: [
                        // complete block for image upload
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            File(widget.imagePath),
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: pressed
                        ? const SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : classified
                            ? Text(
                                img,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )
                            : Container(),
                  ),
                ],
              ),
            ),
    );
  }
}
