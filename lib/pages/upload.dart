import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vca_app2/api/api.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:vca_app2/pages/up.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // defining constant data placeholders
  final ImagePicker imgpicker = ImagePicker();
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

  // routine to select image
  void openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        // clearing the name controller
        nameController.clear();
        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes =
            await imagefile.readAsBytes(); //converting image to bytes
        print(imagebytes);
        // displaying snackbar for successful image load
        displaySnackBar('Image loaded!');
        // saving the imagebytes in an array to send and turning loaded semaphore
        setState(() {
          imgBytes = imagebytes;
          loaded = true;
        });
      } else {
        displaySnackBar('No image is selected');
      }
    } catch (e) {
      displaySnackBar('Error while picking file');
    }
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
    } else {
      displaySnackBar('Image not selected');
    }
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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Stack(
                children: [
                  // complete block for image upload
                  !loaded
                      ? GestureDetector(
                          onTap: openImage,
                          child: DottedBorder(
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [20, 8],
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                  height: 200,
                                  width: 200,
                                  color:
                                      const Color.fromARGB(255, 187, 183, 183),
                                  child: Column(
                                    children: const [
                                      // text for image upload
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Tap here to upload image',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // icon for image upload
                                      Icon(
                                        Icons.pan_tool_alt,
                                        size: 100,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            File(imagepath),
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),
            ),
            // name field
            !loaded
                ? Container()
                : TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'File name'),
                  ),
            // choose image file
            !loaded
                ? Container()
                : ElevatedButton(
                    // style: const ButtonStyle(),
                    onPressed: openImage,
                    child: const Text('Load another')),
            // call upload image page
            !loaded
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UploadingClass(
                                    imagePath: imagepath,
                                    fileName: nameController.text,
                                    byteStream: imgBytes,
                                  )));
                    },
                    child: const Text('Upload')),
            // !loaded ? Container() : CircularProgressIndicator()
          ],
        )),
      ),
    );
  }
}
