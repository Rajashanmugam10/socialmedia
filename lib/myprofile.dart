import 'package:circle/editprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
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
                  String Name = '${data['username']}';
                  String uid = '${data['uid']}';
                  String bio = '${data['bio']}';
                  String email = '${data['email']}';
                  String photo = '${data['photourl']}';
                  String password = '${data['password']}';
                  List grp = data['group'];
                  List<String> intrest = List.from(data['intrest']);
                  print(intrest);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'profile',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Editprofile(
                                                    grp: grp,
                                                  ))),
                                      color: Colors.blue,
                                      child: const Text('edit profile'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        elevation: 30,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Text(Name,
                                                  style: const TextStyle(
                                                      fontSize: 23,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(bio,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        maxRadius: 45,
                                        backgroundImage: NetworkImage(photo),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 300,
                                  color: Colors.transparent,
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Intrest',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20),
                                      ),
                                      Flexible(
                                        child: Card(
                                          elevation: 30,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                                itemCount: intrest.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                      intrest[index],
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    trailing: IconButton(
                                                      icon: const Icon(Icons
                                                          .delete_forever_outlined),
                                                      color: Colors.red,
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'intrest': FieldValue
                                                              .arrayRemove([
                                                            intrest[index]
                                                          ]),
                                                        });
                                                        await Fluttertoast
                                                            .showToast(
                                                                msg:
                                                                    '${intrest[index]} removed from your intrest');
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.height /
                                        6.5,
                                    child: Card(
                                      elevation: 30,
                                      color: Colors.blue[400],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'account verification status',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('''waiting for blue tik 
                                            is in developing''')
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 500,
                          child: const Text('more to come'),
                        )
                      ],
                    ),
                  );
                }
                return const Text('nothing');
              }),
        ],
      ),
    ));
  }
}
