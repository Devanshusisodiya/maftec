import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:vca_app2/api/api.dart';

class Uploading extends StatefulWidget {
  const Uploading({Key? key}) : super(key: key);

  @override
  State<Uploading> createState() => _UploadingState();
}

class _UploadingState extends State<Uploading> {
  // defining constant data placeholders
  String imagepath = "";
  late Uint8List imgBytes;
  TextEditingController nameController = TextEditingController();
  bool loaded = false;

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
    // checking if there is data in the bytestream
    if (imgBytes.isNotEmpty) {
      var request = await http.post(Uri.parse(APIRoutes.uploadRoute),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'bytes': imgBytes,
            'fileName': nameController.text
          }));

      if (request.statusCode == 200) {
        displaySnackBar('Image successfuly uploaded to the server!');
      } else {
        displaySnackBar('Error occured uploading image to the server.');
      }

      // if the bytestream is empty
      if (!imgBytes.isNotEmpty) {
        displaySnackBar('Image not selected');
      }
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
