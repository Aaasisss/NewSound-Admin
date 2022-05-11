import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsound_admin/Models/event_model.dart';
import 'package:newsound_admin/Services/storage.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  final String eventId;
  const EditEvent({
    Key? key,
    required this.event,
    required this.eventId,
  }) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _firestore = FirebaseFirestore.instance.collection('events');
  final storage = StorageService();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      titleController.text = widget.event.title;
      descriptionController.text = widget.event.description;
      venueController.text = widget.event.venue;
    });
  }

  Widget buildTitle() {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Title",
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put title";
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

  Widget buildDescription() {
    return Column(
      children: [
        TextFormField(
          controller: descriptionController,
          minLines: 2,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Description",
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put description";
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

  Widget buildVenue() {
    return Column(
      children: [
        TextFormField(
          controller: venueController,
          decoration: InputDecoration(
            labelText: "Venue",
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please put vanue";
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

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedDateToString = '';
  String selectedTimeToString = '';

  void pickDate(BuildContext context) async {
    final initialDate = DateFormat("dd/MM/yy").parse(widget.event.date);
    selectedDate = initialDate;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    setState(() {
      selectedDate = newDate ?? selectedDate;
      //print(selectedDateToString);
    });
  }

  void pickTime(BuildContext context) async {
    String currentTime = widget.event.time;
    final initialTime = TimeOfDay(
        hour: int.parse(currentTime.split(":")[0]),
        minute: int.parse(currentTime.split(":")[1]));
    selectedTime = initialTime;
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    setState(() {
      selectedTime = newTime ?? selectedTime;
    });
  }

  String getDate() {
    if (selectedDate == null) {
      selectedDateToString = widget.event.date;
      return selectedDateToString;
    } else {
      selectedDateToString = DateFormat('dd/MM/yyyy').format(selectedDate!);
      return selectedDateToString;
    }
  }

  String getTime() {
    if (selectedTime == null) {
      selectedTimeToString = widget.event.time;
      return selectedTimeToString;
    } else {
      final hours = selectedTime!.hour.toString().padLeft(2, '0');
      final minutes = selectedTime!.minute.toString().padLeft(2, '0');
      selectedTimeToString = "${hours}:${minutes}";
      return selectedTimeToString;
    }
  }

  Widget buildDateTime() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            style: const ButtonStyle(alignment: Alignment.centerLeft),
            child: Text(
              getDate(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
            onPressed: () => pickDate(context),
          ),
          OutlinedButton(
            style: const ButtonStyle(alignment: Alignment.centerRight),
            child: Text(
              getTime(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
            onPressed: () => pickTime(context),
          ),
        ],
      ),
    );
  }

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
              child: const Text("Select Photo"),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Column(
                children: [
                  _image == null
                      ? const Text("No file chosen")
                      : Text(
                          (_imageName!),
                          style:
                              const TextStyle(overflow: TextOverflow.visible),
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
        // print(titleController.text);
        // print(descriptionController.text);
        // print(venueController.text);
        // print(selectedDateToString);
        // print(selectedTimeToString);
        // print(_imageName);
        // print(_imagePath);

        if (_image == null) {
          try {
            await _firestore.doc(widget.eventId).set({
              'title': titleController.text,
              'description': descriptionController.text,
              'venue': venueController.text,
              'date': selectedDateToString,
              'time': selectedTimeToString,
            }, SetOptions(merge: true)).then((value) async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('event updated.'),
                  backgroundColor: Colors.green,
                ),
              );
            });
            Navigator.pop(context);
          } on FirebaseException catch (e) {
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

        if (_image != null) {
          try {
            //updates the image
            await storage
                .uploadFile(_image!, widget.eventId)
                .then((value) async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('image updated'),
                backgroundColor: Colors.green,
              ));

              try {
                //update the document
                await _firestore.doc(widget.eventId).set({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'venue': venueController.text,
                  'date': selectedDateToString,
                  'time': selectedTimeToString,
                }, SetOptions(merge: true)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('event updated.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                });
              } on FirebaseException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Error updating document",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  backgroundColor: Colors.red,
                ));
                //print(e);
              }
            });
          } on FirebaseException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Error updating image",
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.red,
            ));
            //print(e);
          }
        }
      },
      child: const Center(child: Text("UPDATE")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.event.photoUrl,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid)),
                child: _image == null
                    ? Image(
                        image: NetworkImage(widget.event.photoUrl),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: FileImage(_image!),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10.0),
            buildTitle(),
            buildDescription(),
            buildVenue(),
            buildDateTime(),
            buildSelectPhoto(),
            buildUpdateButton(),
          ],
        ),
      ),
    );
  }
}
