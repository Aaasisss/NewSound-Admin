import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final mapsController = TextEditingController();
  String currentPhone = '';
  String currentEmail = '';
  String currentAddress = '';
  String currentMap = '';
  final _firestore = FirebaseFirestore.instance.collection('churchInformation');

  Widget buildPhone() {
    return Column(
      children: [
        TextFormField(
          controller: phoneController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Phone",
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
              return "Please put phone number";
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

  Widget buildAddress() {
    return Column(
      children: [
        TextFormField(
          controller: addressController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Address",
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
              return "Please put address";
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

  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Email",
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
              return "Please put email";
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
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          formKey.currentState!.save();
          try {
            _firestore.doc('churchInfo').set({
              'address': addressController.text.trim(),
              'email': emailController.text.trim(),
              'phone': phoneController.text.trim(),
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Updated",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.green,
            ));

            //clear input fields
            setState(() {
              getCurrentData();
              phoneController.clear();
              emailController.clear();
              addressController.clear();
            });
          } catch (e) {
            //print(e);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Error occured",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.green,
            ));
          }
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
    final details = await _firestore.doc('churchInfo').get();

    // print(details.data()!['name']);
    // print(details.data()!['bsb']);
    // print(details.data()!['number']);
    setState(() {
      currentPhone = details.data()!['phone'];
      currentEmail = details.data()!['email'];
      currentAddress = details.data()!['address'];
    });
  }

  Widget buildCurrentInfo() {
    return FutureBuilder(
        future: _firestore.doc('accountDetails').get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                showCurrentPhone(),
                showCurrentEmail(),
                showCurrentAddress(),
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

  Widget showCurrentPhone() {
    return Card(
      child: Text("Current Phone: ${currentPhone}"),
    );
  }

  Widget showCurrentEmail() {
    return Card(
      child: Text("Current Email: ${currentEmail}"),
    );
  }

  Widget showCurrentAddress() {
    return Card(
      child: Text("Current Address: ${currentAddress}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildPhone(),
              buildAddress(),
              buildEmail(),
              buildUpdateButton(),
              buildCurrentInfo(),
            ],
          ),
        )),
      ),
    );
  }
}
