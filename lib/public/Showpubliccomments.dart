import 'package:circle/public/Addpubliccomments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class Showpubliccomments extends StatefulWidget {
  const Showpubliccomments(
      {Key? key,
      required this.postid,
      required this.name,
      required this.uid,
      required this.photo})
      : super(key: key);
  final String postid;
  final String name;
  final String uid;
  final String photo;
  @override
  State<Showpubliccomments> createState() => _ShowpubliccommentsState();
}

class _ShowpubliccommentsState extends State<Showpubliccomments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('comments'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  (MaterialPageRoute(
                      builder: (context) => Addpubliccomments(
                            name: widget.name,
                            photo: widget.photo,
                            postid: widget.postid,
                          )))),
              icon: const Icon(Icons.add_comment)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text(
                  ' Single Tap to',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'UpVote',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(' Double Tap to',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'DownVote',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Flexible(
            child: Container(
                height: MediaQuery.of(context).size.height / 1,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('public')
                        .doc(widget.postid)
                        .collection('comments')
                        .orderBy('votes', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error Occured");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/nocomment.json', height: 300),
                            const Text('no comments')
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.requireData;
                        return Column(children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  List votes = data.docs[index]['votes'];
                                  bool voted = false;
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        child: Card(
                                          elevation: 25,
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12, left: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipOval(
                                                              child:
                                                                  Image.network(
                                                                data.docs[index]
                                                                    [
                                                                    'profilephoto'],
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 40,
                                                                width: 40,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Text(
                                                                data.docs[index]
                                                                    [
                                                                    'username'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    (FirebaseAuth.instance.currentUser!.uid ==
                                                                            data.docs[index][
                                                                                'uid'])
                                                                        ? {
                                                                            FirebaseFirestore.instance
                                                                                .collection('public')
                                                                                .doc(widget.postid)
                                                                                .collection('comments')
                                                                                .doc(
                                                                                  data.docs[index]['commentid'],
                                                                                )
                                                                                .delete(),
                                                                            Fluttertoast.showToast(msg: 'comment deleted'),
                                                                          }
                                                                        : Fluttertoast.showToast(
                                                                            msg:
                                                                                'this is not your comment');
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete)),
                                                              IconButton(
                                                                  color: (votes.contains(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .red),
                                                                  onPressed:
                                                                      () async {
                                                                    (voted =
                                                                            !voted)
                                                                        ? FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'public')
                                                                            .doc(widget
                                                                                .postid)
                                                                            .collection(
                                                                                'comments')
                                                                            .doc(data.docs[index][
                                                                                'commentid'])
                                                                            .update({
                                                                            'votes':
                                                                                FieldValue.arrayUnion([
                                                                              FirebaseAuth.instance.currentUser!.uid
                                                                            ])
                                                                          })
                                                                        : FirebaseFirestore
                                                                            .instance
                                                                            .collection('public')
                                                                            .doc(widget.postid)
                                                                            .collection('comments')
                                                                            .doc(data.docs[index]['commentid'])
                                                                            .update({
                                                                            'votes':
                                                                                FieldValue.arrayRemove([
                                                                              FirebaseAuth.instance.currentUser!.uid
                                                                            ])
                                                                          });
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .arrow_circle_up_outlined)),
                                                              Text(data
                                                                  .docs[index]
                                                                      ['votes']
                                                                  .length
                                                                  .toString()),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Text(
                                                      data.docs[index]
                                                          ['comment'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ]);
                      }
                      return const Text('none');
                    })),
          ),
        ],
      ),
    );
  }
}
