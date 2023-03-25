import 'dart:typed_data';

import 'package:circle/services/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../screens/privatechat.dart';
import '../services/firestore.dart';

class Postpublic extends StatefulWidget {
  const Postpublic({Key? key}) : super(key: key);

  @override
  State<Postpublic> createState() => _PostpublicState();
}

class _PostpublicState extends State<Postpublic> {
  Uint8List? _file;
  final TextEditingController _decprtioncontroller = TextEditingController();
  final TextEditingController _blog = TextEditingController();
  bool isloading = false;
  _selectimage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('take photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('take photo from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _show(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        context: ctx,
        builder: (ctx) => Container(
              width: 300,
              height: 250,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 29, horizontal: 30),
                    child: Row(
                      children: [
                        const Text(
                          'For post in  Public page click  here',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              String res =
                                  await FirestoreMethods().uploadpublic(
                                _decprtioncontroller.text,
                                _file!,
                                snapshot.get('uid').toString(),
                                _blog.text,
                                snapshot.get('username').toString(),
                                snapshot.get('photourl').toString(),
                              );

                              if (res == "Success") {
                                setState(() {
                                  isloading = false;
                                });
                                showSnackBar("posted ", context);
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  isloading = false;
                                });
                                showSnackBar(res, context);
                              }
                            } catch (e) {
                              showSnackBar(e.toString(), context);
                            }
                          },
                          child: const Text('Public'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          actions: [
            IconButton(
                icon: const Icon(Icons.upload),
                onPressed: () => (_blog.text.isEmpty ||
                        _decprtioncontroller.text.isEmpty)
                    ? Fluttertoast.showToast(msg: 'blog and message are empty')
                    : _show(context)),
          ],
        ),
        body: _file != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isloading
                      ? const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: Image(
                        image: MemoryImage(_file!),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _blog,
                      decoration: const InputDecoration(
                          hintText: "blog name", border: InputBorder.none),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _decprtioncontroller,
                        decoration: const InputDecoration(
                            hintText: "add message", border: InputBorder.none),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.upload_file,
                        size: 33,
                      ),
                      onTap: () => _selectimage(context),
                    ),
                    Lottie.asset('assets/post.json')
                  ],
                ),
              ));
  }
}
