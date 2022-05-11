import 'package:flutter/material.dart';
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
  final _firestore = FirebaseFirestore.instance.collection('socialLinks');

  Widget buildFacebook() {
    return Column(
      children: [
        TextFormField(
          controller: facebookController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Facebook",
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
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
        const SizedBox(
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
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
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
        const SizedBox(
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
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
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
        const SizedBox(
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

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Updated",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            //print(e);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Error occured",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.red,
            ));
          }

          setState(() {
            getCurrentData();
            facebookController.clear();
            instagramController.clear();
            youtubeController.clear();
          });
        }
      },
      child: const Text("UPDATE"),
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

    //print(details.data()!['name']);
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
            return const CircularProgressIndicator();
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
            return const Text(('Error!'));
          }
          return const Scaffold(
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
      child: Text("Current Facebook: ${currentFacebook}"),
    );
  }

  Widget showCurrentInstagram() {
    return Card(
      child: Text("Current Instagram: ${currentInstagram}"),
    );
  }

  Widget showCurrentYoutube() {
    return Card(
      child: Text("Current Youtube: ${currentYoutube}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Links')),
      body: Container(
        padding: const EdgeInsets.all(10.0),
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
