import 'package:circle/public/postpublic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import 'Showpubliccomments.dart';

class Publichome extends StatefulWidget {
  const Publichome({
    Key? key,
  }) : super(key: key);

  @override
  State<Publichome> createState() => _PublichomeState();
}

TextEditingController _search = TextEditingController();

class _PublichomeState extends State<Publichome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              String Name = '${data['username']}';
              String photo = '${data['photourl']}';
              List<String> pointlist = ['${data['group']}'];
              List v = data['group'];
              List saved = data['saved'];
              String uid = '${data['uid']}';
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'welcome $Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Postpublic()));
                          },
                          icon: const Icon(Icons.post_add_rounded))
                    ],
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('public')
                            .orderBy('dateposted', descending: true)
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
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/blog.json',
                                    height:
                                        MediaQuery.of(context).size.height / 2),
                                const Text(
                                  'no post',
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.requireData;

                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  // DocumentSnapshot ds = snapshot.data!.docs[];
                                  String saveid = const Uuid().v1();
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'blog:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data.docs[index]['blog'],
                                                style: const TextStyle(
                                                    // color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          elevation: 30,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                            side: BorderSide(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                Stack(children: [
                                                  Image.network(
                                                    data.docs[index]['posturl'],
                                                    fit: BoxFit.contain,
                                                    width: double.infinity,
                                                    height: 350,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 10),
                                                    child: Text(
                                                      DateFormat.yMMMd().format(
                                                          data.docs[index]
                                                                  ['dateposted']
                                                              .toDate()),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ]),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: ExpansionTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'proImage']),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'username'],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        // Text(data.docs[index]
                                                        //     ['blog']),
                                                        IconButton(
                                                            onPressed: () =>
                                                                Navigator.push(
                                                                    context,
                                                                    (MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            Showpubliccomments(
                                                                              name: Name,
                                                                              photo: photo,
                                                                              uid: uid,
                                                                              postid: data.docs[index]['postid'],
                                                                            )))),
                                                            icon: const Icon(Icons
                                                                .comment_rounded)),
                                                        (FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid ==
                                                                data.docs[index]
                                                                    ['uid'])
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'public')
                                                                      .doc(data.docs[
                                                                              index]
                                                                          [
                                                                          'postid'])
                                                                      .delete();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'post deleted');
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                            : (saved.contains(
                                                                    saveid))
                                                                ? const Text(
                                                                    'data')
                                                                : TextButton
                                                                    .icon(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('users')
                                                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                              .update({
                                                                            'saved':
                                                                                FieldValue.arrayUnion([
                                                                              saveid
                                                                            ])
                                                                          });

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('users')
                                                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                              .collection('saved')
                                                                              .doc(saveid)
                                                                              .set({
                                                                            'photourl':
                                                                                data.docs[index]['posturl'],
                                                                            'group':
                                                                                'public',
                                                                            'saveid':
                                                                                saveid,
                                                                            'blog':
                                                                                data.docs[index]['blog'],
                                                                            'description':
                                                                                data.docs[index]['description'],
                                                                            'savedtime':
                                                                                DateTime.now(),
                                                                            'postedby':
                                                                                data.docs[index]['username'],
                                                                            'photo':
                                                                                data.docs[index]['proImage']
                                                                          });
                                                                          Fluttertoast.showToast(
                                                                              msg: 'saved');
                                                                        },
                                                                        icon: const Icon(Icons
                                                                            .save),
                                                                        label: const Text(
                                                                            'save')),
                                                      ],
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          data.docs[index]
                                                              ['description'],
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style:
                                                              const TextStyle(
                                                                  wordSpacing:
                                                                      1.0,
                                                                  letterSpacing:
                                                                      .4),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ]));
                                });
                          }
                          return const Text('jbhb');
                        }),
                  ),
                ],
              );
            }
            return const Text('no problem');
          }),
    );
  }
}
