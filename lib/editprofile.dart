import 'package:circle/tools/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key, required this.grp}) : super(key: key);
  final List grp;
  @override
  State<Editprofile> createState() => _EditprofileState();
}

TextEditingController _password = TextEditingController();
TextEditingController _newpassword = TextEditingController();
TextEditingController _bio = TextEditingController();
TextEditingController _username = TextEditingController();

class _EditprofileState extends State<Editprofile> {
  @override
  Widget build(BuildContext context) {
    List r = widget.grp;
    Map map = r.asMap();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: Center(
              child: Text(
            'change profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
        ),
        Card(
          elevation: 20,
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      'password',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextFieldInput(
                    textEditingController: _password,
                    hintText: 'enter current password',
                    textInputType: TextInputType.emailAddress),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text(
                    'forgot password',
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(
                        email: FirebaseAuth.instance.currentUser!.email!);
                    Fluttertoast.showToast(
                        msg: 'password reset link will send to email ');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFieldInput(
                    textEditingController: _newpassword,
                    hintText: 'new password',
                    textInputType: TextInputType.emailAddress),
              ),
              MaterialButton(
                onPressed: () async {
                  (_newpassword.text.isNotEmpty && _password.text.isNotEmpty)
                      ? await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                          password: _newpassword.text)
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("am i idiot ? ")));

                  FirebaseAuth.instance.currentUser!
                      .updatePassword(_newpassword.text);
                  print(_newpassword.text);
                },
                color: Colors.blue,
                child: const Text(
                  'change',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFieldInput(
                    textEditingController: _bio,
                    hintText: 'update bio',
                    textInputType: TextInputType.emailAddress),
              ),
            ),
            TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'bio': _bio.text});
                  Fluttertoast.showToast(
                    msg: 'bio updated',
                  );
                  _bio.clear();
                },
                child: const Text('update bio'))
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
              'We are working for update profilephoto,email id,username \n                                           stay tuned'),
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFieldInput(
                    textEditingController: _username,
                    hintText: 'usrename',
                    textInputType: TextInputType.emailAddress),
              ),
            ),
            TextButton(
                onPressed: () {
                  print(widget.grp);
                  var i;
                  for (i = 0; i < r.length; i++) {
                    // FirebaseFirestore.instance
                    //     .collection(r[i])
                    //     .doc('post')
                    //     .collection(r[i])
                    //     .where('uid',
                    //         isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    //     .get()
                    //     .toString();
                  }
                },
                child: const Text('username'))
          ],
        ),
      ]),
    );
  }
}
