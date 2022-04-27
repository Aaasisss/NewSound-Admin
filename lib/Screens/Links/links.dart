import 'package:flutter/material.dart';
import 'package:newsound_admin/Screens/Add_Events/add_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  final formKey = GlobalKey<FormState>();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final youtubeController = TextEditingController();
  String currentFacebook = '';
  String currentInstagram = '';
  String currentYoutube = '';
  final _firestore = FirebaseFirestore.instance.collection('socialLink');

  Widget buildFacebook() {
    return Column(
      children: [
        TextFormField(
          controller: facebookController,
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
          controller: instagramController,
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
          controller: youtubeController,
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
      onPressed: () async {
        //Navigator.pushNamed(context, '/home');
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomePage()));
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          formKey.currentState!.save();
          try {
            await _firestore.doc('socialLinks').set({
              'facebook': facebookController.text.trim(),
              'instagram': instagramController.text.trim(),
              'youtube': youtubeController.text.trim()
            });

            final message = "Updated";
            final updateSnackBar = SnackBar(
              content: Text(
                message,
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(updateSnackBar);
          } catch (e) {
            print(e);
          }

          setState(() {
            getCurrentData();
            facebookController.clear();
            instagramController.clear();
            youtubeController.clear();
          });
        }
      },
      child: Text("Update"),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentData();
  }

  void getCurrentData() async {
    final details = await _firestore.doc('socialLinks').get();

    // print(details.data()!['name']);
    // print(details.data()!['bsb']);
    // print(details.data()!['number']);
    setState(() {
      currentFacebook = details.data()!['facebook'];
      currentInstagram = details.data()!['instagram'];
      currentYoutube = details.data()!['youtube'];
    });
  }

  Widget buildCurrentInfo() {
    return FutureBuilder(
        future: _firestore.doc('socialLinks').get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                showCurrentFacebook(),
                showCurrentInstagram(),
                showCurrentYoutube(),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text(('Error!'));
          }
          return Scaffold(
            body: Center(
              child: Text(
                'loading...',
                style: TextStyle(color: Colors.green),
              ),
            ),
          );
        }));
  }

  Widget showCurrentFacebook() {
    return Card(
      child: Text("Current Phone: ${currentFacebook}"),
    );
  }

  Widget showCurrentInstagram() {
    return Card(
      child: Text("Current Email: ${currentInstagram}"),
    );
  }

  Widget showCurrentYoutube() {
    return Card(
      child: Text("Current Address: ${currentYoutube}"),
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
              buildCurrentInfo(),
            ],
          ),
        )),
      ),
    );
  }
}
