import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key}) : super(key: key);

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  String newEventTitle = '';
  String newEventDescription = '';
  String newEventVenue = '';
  String newEventDate = '';
  String newEventTime = '';
  String newEventTimeZone = '';

  Widget buildTitle() {
    return Column(
      children: [
        TextFormField(
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: (value) => setState(() {
                  newEventTitle = value;
                })),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      children: [
        TextFormField(
          minLines: 2,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Description",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildVenue() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: "Venue",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;
    setState(() {
      selectedDate = newDate;
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? initialTime,
    );
    if (newTime == null) return;
    setState(() {
      selectedTime = newTime;
    });
  }

  String getDate() {
    if (selectedDate == null) {
      return "Select Date";
    } else {
      return DateFormat('MM/dd/yyyy').format(selectedDate!);
      //return "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    }
  }

  String getTime() {
    if (selectedTime == null) {
      return "Select Time";
    } else {
      final hours = selectedTime!.hour.toString().padLeft(2, '0');
      final minutes = selectedTime!.minute.toString().padLeft(2, '0');
      return "${hours}:${minutes}";
    }
  }

  Widget buildDateTime() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            child: Text(
              getDate(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            onPressed: () => pickDate(context),
          ),
          OutlinedButton(
            style: ButtonStyle(alignment: Alignment.centerRight),
            child: Text(
              getTime(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            onPressed: () => pickTime(context),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildTimeZoneItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));

  final timeZoneItems = ["Sydney", "Melbourne", "Perth", "Canberra"];
  String? selectedTimeZone;

  Widget buildTimeZone() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'TimeZone',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          DropdownButton<String>(
              value: selectedTimeZone,
              items: timeZoneItems.map(buildTimeZoneItems).toList(),
              onChanged: (value) => setState(() {
                    selectedTimeZone = value!;
                  })),
        ],
      ),
    );
  }

  Widget buildSelectPicture() {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton(
              onPressed: _optionsDialogueBox,
              child: Text("Select Photo"),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              child: _image == null
                  ? Text("No file chosen")
                  : Image.file(
                      _image!,
                      height: 150,
                      width: 150,
                    ),
            ),
          ],
        ),
        SizedBox(height: 10.0)
      ],
    );
  }

  //the image file that will be selected by the use, which is initially set to null
  File? _image = null;
  //create an instance of image_picker
  final ImagePicker _picker = ImagePicker();

  Future<void> _optionsDialogueBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text(
                    "Take a Picture",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onTap: openCamera,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: Text(
                    "Select Image From gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onTap: openGallery,
                )
              ]),
            ),
          );
        });
  }

  Future openCamera() async {
    try {
      var imageFromCamera = await _picker.pickImage(source: ImageSource.camera);
      if (imageFromCamera == null) return;
      setState(() {
        _image = File(imageFromCamera.path);
        //widget.file = File(imageFromCamera!.path);
      });
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
    Navigator.of(context).pop();
  }

  Future openGallery() async {
    try {
      var imageFromGallery =
          await _picker.pickImage(source: ImageSource.gallery);
      if (imageFromGallery == null) return;

      setState(() {
        _image = File(imageFromGallery.path);
        //widget.file = File(imageFromGallery!.path);
      });
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
    Navigator.of(context).pop();
  }

  Widget buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/home');
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomePage()));
      },
      child: Text("Update"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Events')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          child: Column(
            children: <Widget>[
              buildTitle(),
              buildDescription(),
              buildVenue(),
              buildDateTime(),
              buildTimeZone(),
              buildSelectPicture(),
              buildUpdateButton(),
            ],
          ),
        )),
      ),
    );
  }
}
