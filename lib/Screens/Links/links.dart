import 'package:flutter/material.dart';
import 'package:newsound_admin/Screens/Add_Events/add_events.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  final formKey = GlobalKey<FormState>();

  Widget buildFacebook() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Facebook",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) => setState(() {
            //newEventTitle = value!;
          }),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put url";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildInstagram() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Instagram",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) => setState(() {
            //newEventTitle = value!;
          }),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put url";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildYouTube() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "YouTube",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) => setState(() {
            //newEventTitle = value!;
          }),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put url";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        //Navigator.pushNamed(context, '/home');
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomePage()));
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          formKey.currentState!.save();

          final message = "Updated";
          final updateSnackBar = SnackBar(
            content: Text(
              message,
              style: TextStyle(fontSize: 20.0),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(updateSnackBar);
        }
      },
      child: Text("Update"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Links')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildFacebook(),
              buildInstagram(),
              buildYouTube(),
              buildUpdateButton(),
            ],
          ),
        )),
      ),
    );
  }
}
