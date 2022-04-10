import 'package:flutter/material.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final formKey = GlobalKey<FormState>();

  Widget buildAccountName() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Account Name",
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
              return "Please put account name";
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

  Widget buildBSB() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "BSB",
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
              return "Please put account bsb";
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

  Widget buildAccountNumber() {
    return Column(
      children: [
        TextFormField(
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Account Number",
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
              return "Please put account number";
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
      appBar: AppBar(title: Text('Bank Details')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildAccountName(),
              buildBSB(),
              buildAccountNumber(),
              buildUpdateButton(),
            ],
          ),
        )),
      ),
    );
  }
}
