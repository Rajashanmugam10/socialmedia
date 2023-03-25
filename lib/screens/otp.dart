import 'dart:ui';

import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/signup.dart';
import 'package:email_auth/email_auth.dart';

// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../tools/test.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

// String verificationid = '';

bool _visible = true;
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _phone = TextEditingController();
TextEditingController _otpcontroller = TextEditingController();

void verify(context) {
  var res = EmailAuth.validate(
    receiverMail: _emailcontroller.value.text,
    userOTP: _otpcontroller.value.text,
  );
  (res)
      ? {
          Fluttertoast.showToast(msg: 'otp verified'),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Signup(email: _emailcontroller.text))))
        }
      : Fluttertoast.showToast(msg: 'otp incorrect');
}

void sendOtp() async {
  EmailAuth.sessionName = 'Test Session';
  var res = await EmailAuth.sendOtp(receiverMail: _emailcontroller.value.text);
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Lottie.asset('assets/email.json'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _emailcontroller,
                  hintText: ' email id  is required',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _otpcontroller,
                  hintText: 'enter otp',
                  textInputType: TextInputType.number),
              Visibility(
                visible: _visible,
                child: TextButton(
                    onPressed: () {
                      {
                        (_emailcontroller.text.isNotEmpty)
                            ? {
                                sendOtp(),
                                Fluttertoast.showToast(
                                    msg: 'otp will send to this phone number'),
                                setState(() {
                                  _visible = !_visible;
                                })
                              }
                            : Fluttertoast.showToast(msg: 'enter email id');
                      }
                    },
                    child: const Text('send otp')),
              ),
              TextButton(
                  onPressed: () {
                    verify(context);
                  },
                  child: const Text('verify'))
            ],
          ),
        ),
      ),
    );
  }
}
