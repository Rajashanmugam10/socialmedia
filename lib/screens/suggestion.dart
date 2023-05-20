import 'package:circle/instantchat.dart';
import 'package:circle/tools/test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({
    Key? key,
    required this.uid,
    name,
  }) : super(
          key: key,
        );
  final String uid;

  @override
  State<Suggestion> createState() => _SuggestionState();
}

bool _check = false;
TextEditingController _search = TextEditingController();
TextEditingController _intrest = TextEditingController();
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(ctx).size.width / 2,
                  color: Colors.white,
                  child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_c1jtrokn.json',
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: TextFieldInput(
                    textEditingController: _intrest,
                    hintText: 'edit your intrest',
                    textInputType: TextInputType.name),
              ),
              TextButton(
                  onPressed: () async {
                    (_intrest.text.isEmpty)
                        ? (Fluttertoast.showToast(msg: 'enter your intrest'))
                        : {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'intrest': FieldValue.arrayUnion([_intrest.text])
                            }),
                            Fluttertoast.showToast(msg: 'intrest updated'),
                            Navigator.pop(ctx),
                          };
                  },
                  child: const Text('change'))
            ],
          )));
}

class _SuggestionState extends State<Suggestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestion'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Error Occured");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                String name = '${data['username']}';
                String photo = '${data['photourl']}';
                return Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height / 3.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Lottie.asset('assets/search.json', height: 100),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CircleAvatar(
                                  minRadius: 30,
                                  maxRadius: 35,
                                  backgroundImage: NetworkImage(photo),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldInput(
                                      textEditingController: _search,
                                      onchanged: (value) {
                                        setState(() {
                                          _search.clear();
                                        });
                                      },
                                      hintText: 'type here eg: developer',
                                      textInputType: TextInputType.name),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    color: Colors.blue,
                                    child: const Text('add intrest',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () => _show(context),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () async {
                                (setState(() {
                                  _check = true;
                                }));
                                _check = false;
                              },
                              child: const Text('search')),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'suggested people',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          (_search.text.isNotEmpty)
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('intrest',
                                            arrayContains: _search.text)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text("Error Occured");
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (!snapshot.hasData) {
                                        return const Text(
                                            "Document does not exist");
                                      }
                                      final data = snapshot.requireData;

                                      return ListView.builder(
                                        itemCount: data.size,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot ds =
                                              snapshot.data!.docs[index];
                                          print(data.docs[index]['username']);
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListTile(
                                                subtitle: Text(
                                                  data.docs[index]['bio'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                leading: ClipOval(
                                                  child: Image.network(
                                                    data.docs[index]
                                                        ['photourl'],
                                                    width: 50,
                                                    height: 75,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: Text(data.docs[index]
                                                    ['username']),
                                                trailing: (data.docs[index]
                                                            ['uid'] ==
                                                        widget.uid)
                                                    ? const Text('you')
                                                    : MaterialButton(
                                                        child: const Icon(
                                                          Icons
                                                              .person_pin_circle,
                                                          color: Colors.blue,
                                                          size: 40,
                                                        ),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(data.docs[
                                                                  index]['uid'])
                                                              .collection(
                                                                  'friends')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .set({
                                                            'uid': FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            'username': name,
                                                            'photo': photo,
                                                            'group':
                                                                'suggestion',
                                                            "rname": data
                                                                    .docs[index]
                                                                ['username'],
                                                            "ruid":
                                                                data.docs[index]
                                                                    ['uid'],
                                                            'rphoto':
                                                                data.docs[index]
                                                                    ['photourl']
                                                          });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(data.docs[
                                                                  index]['uid'])
                                                              .update({
                                                            'friends request':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                            ])
                                                          });
                                                        })),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Lottie.network(
                                  'https://assets6.lottiefiles.com/packages/lf20_4cntnmut.json',
                                  height: 200)
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Text('d');
            }),
      ),
    );
  }
}
