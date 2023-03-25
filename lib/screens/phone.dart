import 'package:circle/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  late String verId;
  late String phone;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            codeSent
                ? OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 30,
                    style: const TextStyle(fontSize: 30),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      verifyPin(pin);
                    },
                  )
                : IntlPhoneField(
                    decoration: const InputDecoration(
                        labelText: "phone number",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    initialCountryCode: "IN",
                    onChanged: (phoneNumber) {
                      setState(() {
                        phone = phoneNumber.completeNumber;
                      });
                    },
                  ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  verifyphone();
                },
                child: const Text("verify")),
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: Text("Please dont't share otp to others"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> verifyphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          final snackBar = SnackBar(content: Text("login succes"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (String verificationId, resendToken) {
          setState(() {
            codeSent = true;
            verId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verId = verificationId;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  Future<void> verifyPin(String pin) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final snackBar = SnackBar(content: const Text("login succes"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
