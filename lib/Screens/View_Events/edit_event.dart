import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key? key}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event"),
      ),
      body: ListView(
        children: [
          Hero(
            tag: AssetImage("lib/Images/pasters.png"),
            child: Container(
              child: Image(
                image: AssetImage("lib/Images/pasters.png"),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
