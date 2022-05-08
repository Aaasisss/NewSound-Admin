import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newsound_admin/Services/storage.dart';
import 'package:path_provider/path_provider.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key}) : super(key: key);

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final _firestore = FirebaseFirestore.instance.collection('events');
  final StorageService storage = StorageService();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();
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
          controller: titleController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Title",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) => setState(() {
            newEventTitle = value!;
          }),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put title";
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

  Widget buildDescription() {
    return Column(
      children: [
        TextFormField(
          controller: descriptionController,
          minLines: 2,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Description",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) {
            newEventDescription = value!;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put description";
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

  Widget buildVenue() {
    return Column(
      children: [
        TextFormField(
          controller: venueController,
          decoration: InputDecoration(
            labelText: "Venue",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onSaved: (value) {
            newEventVenue = value!;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put vanue";
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

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedDateToString = '';
  String selectedTimeToString = '';

  void pickDate(BuildContext context) async {
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
      //print(selectedDateToString);
    });
  }

  void pickTime(BuildContext context) async {
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
      selectedDateToString = DateFormat('dd/MM/yyyy').format(selectedDate!);
      return selectedDateToString;
      //return "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
    }
  }

  String getTime() {
    if (selectedTime == null) {
      return "Select Time";
    } else {
      final hours = selectedTime!.hour.toString().padLeft(2, '0');
      final minutes = selectedTime!.minute.toString().padLeft(2, '0');
      selectedTimeToString = "${hours}:${minutes}";
      return selectedTimeToString;
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
          const Text(
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

  //the image file that will be selected by the use, which is initially set to null
  File? _image;
  String? _imagePath;
  String? _imageName;

  Widget buildSelectPhoto() {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                );
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No file selected'),
                  ));
                  return;
                }
                //final appDocDir = await getApplicationDocumentsDirectory();

                final path = result.files.single.path;
                final fileName = result.files.single.name;

                //final filePath = "${appDocDir.absolute}/$fileName";
                setState(() {
                  _image = File(path!);
                  _imagePath = path;
                  _imageName = fileName;
                });
                print("path is: ${path}");
                print("filename is: ${fileName}");
              },
              child: Text("Select Photo"),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Column(
                children: [
                  _image == null
                      ? Text("No file chosen")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.file(
                              _image!,
                              height: 150,
                              width: 150,
                            ),
                            Text(
                              (_imageName!),
                              style: TextStyle(overflow: TextOverflow.visible),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0)
      ],
    );
  }

  Widget buildUpdateButton() {
    return ElevatedButton(
      onPressed: () async {
        //validates the form
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          if (selectedDate != null &&
              selectedTime != null &&
              selectedTimeZone != null &&
              _image != null) {
            //if it is valid, current state is saved
            formKey.currentState!.save();

            try {
              await _firestore.add({
                'title': titleController.text,
                'description': descriptionController.text,
                'venue': venueController.text,
                'date': selectedDateToString,
                'time': selectedTimeToString,
                'timeZone': selectedTimeZone,
                'photoUrl': '',
              }).then((value) async {
                final message = "Event added";

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    message,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  backgroundColor: Colors.green,
                ));
                String eventAndImageIdGeneratedByFirebase = value.id;
                print("document id is: ${eventAndImageIdGeneratedByFirebase}");
                //try to upload the image first
                try {
                  await storage
                      .uploadFile(_image!, eventAndImageIdGeneratedByFirebase)
                      .then((_) async {
                    //get the Url of the uploaded image
                    String downloadUrl = await storage
                        .getDownloadUrl(eventAndImageIdGeneratedByFirebase);
                    print("download url is: ${downloadUrl}");
                    final message = "Image uploaded";

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        message,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      backgroundColor: Colors.green,
                    ));

                    if (downloadUrl.isNotEmpty) {
                      try {
                        await _firestore
                            .doc(eventAndImageIdGeneratedByFirebase)
                            .set({
                          'photoUrl': downloadUrl,
                        }, SetOptions(merge: true)).then((_) {
                          final message = "Updated";

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              message,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            backgroundColor: Colors.green,
                          ));
                        });
                      } on FirebaseException catch (e) {
                        print(e);
                      }
                    }
                  });
                } on FirebaseException catch (e) {
                  print(e);
                }
              });

              //reset form fields
              setState(() {
                titleController.clear();
                descriptionController.clear();
                venueController.clear();
                selectedDate = null;
                selectedTime = null;
                selectedTimeZone = null;
                _image = null;
              });
            } catch (e) {
              print(e);
            }

            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text("something went wrong while uploading image")));
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) =>
            //         Text('something went wrong while uploading image'));

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select all the fields")));
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) =>
            //         Text('Please select all the fields'));
          }
        }
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
          key: formKey,
          child: Column(
            children: <Widget>[
              buildTitle(),
              buildDescription(),
              buildVenue(),
              buildDateTime(),
              buildTimeZone(),
              buildSelectPhoto(),
              buildUpdateButton(),
            ],
          ),
        )),
      ),
    );
  }
}
