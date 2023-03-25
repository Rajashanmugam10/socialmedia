import 'package:flutter/material.dart';

class Instantchat extends StatefulWidget {
  const Instantchat({
    Key? key,
    required this.name,
    required this.photo,
    required this.uid,
  }) : super(key: key);
  final String name, photo, uid;
  @override
  State<Instantchat> createState() => _InstantchatState();
}

class _InstantchatState extends State<Instantchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('instant chat')),
        body: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage(widget.photo),
                    ),
                  ),
                  Text(widget.name),
                ],
              ),
            )
          ],
        ));
  }
}
