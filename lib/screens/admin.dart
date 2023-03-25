import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('admin'),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                    List grp = data['admin'];
                    return ListView.builder(
                        itemCount: grp.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                      width: 4, color: Colors.transparent),
                                ),
                                child: ExpansionTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0, left: 25),
                                    child: Text(grp[index]),
                                  ),
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Column(children: [
                                        Flexible(
                                          flex: 1,
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection(grp[index])
                                                  .doc(grp[index])
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text(
                                                      "Error Occured");
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                if (snapshot.hasData) {
                                                  Map<String, dynamic> data =
                                                      snapshot.data!.data()
                                                          as Map<String,
                                                              dynamic>;

                                                  List accept = data['request'];

                                                  // Map map = accept.asMap();

                                                  return ListView.builder(
                                                      itemCount: 1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              snapshot) {
                                                        return Column(
                                                          children: [
                                                            const Text(
                                                              'requesting users',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 16),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            for (var users
                                                                in accept)
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Card(
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .transparent),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          20),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        Text(
                                                                          users,
                                                                          style:
                                                                              const TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  print(users);
                                                                                  await FirebaseFirestore.instance.collection('users').doc('$users'.substring(0, 28)).update({
                                                                                    'group': FieldValue.arrayUnion([
                                                                                      grp[index]
                                                                                    ])
                                                                                  });

                                                                                  await FirebaseFirestore.instance.collection(grp[index]).doc(grp[index]).update({
                                                                                    'users': FieldValue.arrayUnion([
                                                                                      users
                                                                                    ])
                                                                                  });
                                                                                  await FirebaseFirestore.instance.collection(grp[index]).doc(grp[index]).update({
                                                                                    'request': FieldValue.arrayRemove([
                                                                                      users
                                                                                    ])
                                                                                  });

                                                                                  Fluttertoast.showToast(msg: 'added into your group');
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.add,
                                                                                  color: Colors.blue,
                                                                                  size: 20,
                                                                                )),
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  await FirebaseFirestore.instance.collection(grp[index]).doc(grp[index]).update({
                                                                                    'request': FieldValue.arrayRemove([
                                                                                      users
                                                                                    ])
                                                                                  });
                                                                                  await FirebaseFirestore.instance.collection('circle').doc('grp').collection('collection').doc(grp[index]).update({
                                                                                    'request': FieldValue.arrayRemove([
                                                                                      users
                                                                                    ])
                                                                                  });
                                                                                  await FirebaseFirestore.instance.collection('users').doc('$users'.substring(0, 28)).update({
                                                                                    'request': FieldValue.arrayRemove([
                                                                                      grp[index]
                                                                                    ])
                                                                                  });
                                                                                  await Fluttertoast.showToast(msg: 'deleted the request ');
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.red,
                                                                                  size: 20,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      });
                                                }
                                                return const Text('noo');
                                              }),
                                        ),
                                      ]),
                                    )
                                  ],
                                )),
                          );
                        });
                  }
                  return const Text('nothing');
                }),
          )),
    );
  }
}
