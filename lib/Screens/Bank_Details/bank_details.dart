import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final formKey = GlobalKey<FormState>();
  final accountNameController = TextEditingController();
  final accountBsbController = TextEditingController();
  final accountNumberController = TextEditingController();
  String currentAccountName = '';
  String currentAccountBsb = '';
  String currentAccountNumber = '';
  final _firestore = FirebaseFirestore.instance.collection('bankAccountDetail');

  Widget buildAccountName() {
    return Column(
      children: [
        TextFormField(
          controller: accountNameController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Account Name",
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
              return "Please put account name";
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

  Widget buildBSB() {
    return Column(
      children: [
        TextFormField(
          controller: accountBsbController,
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "BSB",
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
              return "Please put account bsb";
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

  Widget buildAccountNumber() {
    return Column(
      children: [
        TextFormField(
          controller: accountNumberController,
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Account Number",
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
              return "Please put account number";
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
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          formKey.currentState!.save();

          try {
            await _firestore.doc('accountDetails').set({
              'number': accountNumberController.text.trim(),
              'bsb': accountBsbController.text.trim(),
              'name': accountNameController.text.trim()
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Updated",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.green,
            ));

            //clear the fields
            setState(() {
              getInfo();
              accountNameController.clear();
              accountBsbController.clear();
              accountNumberController.clear();
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
      child: const Text(
        "UPDATE",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  void getInfo() async {
    final details = await _firestore.doc('accountDetails').get();

    // print(details.data()!['name']);
    // print(details.data()!['bsb']);
    // print(details.data()!['number']);
    setState(() {
      currentAccountName = details.data()!['name'];
      currentAccountBsb = details.data()!['bsb'];
      currentAccountNumber = details.data()!['number'];
    });
  }

  Widget buildCurrentInfo() {
    return FutureBuilder(
        future: _firestore.doc('accountDetails').get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                showAccountName(),
                showAccountBsb(),
                showAccountNumber(),
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

  Widget showAccountName() {
    return Card(
      child: Text("Current Name: ${currentAccountName}"),
    );
  }

  Widget showAccountBsb() {
    return Card(
      child: Text("Current BSB: ${currentAccountBsb}"),
    );
  }

  Widget showAccountNumber() {
    return Card(
      child: Text("Current Number: ${currentAccountNumber}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Details')),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildAccountName(),
              buildBSB(),
              buildAccountNumber(),
              buildUpdateButton(),
              buildCurrentInfo(),
            ],
          ),
        )),
      ),
    );
  }
}
