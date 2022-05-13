import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsound_admin/Screens/View_Feedbacks/view_feedback.dart';

class EditFeedback extends StatefulWidget {
  final String feedbackText;
  final String documentId;
  const EditFeedback({
    Key? key,
    required this.feedbackText,
    required this.documentId,
  }) : super(key: key);

  @override
  State<EditFeedback> createState() => _EditFeedbackState();
}

class _EditFeedbackState extends State<EditFeedback> {
  final _firestore = FirebaseFirestore.instance.collection('feedback');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SingleChildScrollView(
                child: Text(
                  widget.feedbackText,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text(
                            "Warning!",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          content: const Text(
                              "Do you want to delete this feedback?"),
                          elevation: 24.0,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                try {
                                  await _firestore
                                      .doc(widget.documentId)
                                      .delete()
                                      .then((_) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/feedback', (route) => false);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Feedback deleted successfully.",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
                                  });
                                } on FirebaseException {
                                  //print(e);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Error occured!",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              },
                              child: const Text("YES"),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text("NO"),
                            ),
                          ],
                        ),
                    barrierDismissible: true);
              },
              icon: Icon(Icons.delete),
              label: Text('Delete'),
            ),
          )
        ],
      ),
      // ListView(
      //   children: [
      //     Container(
      //       margin: EdgeInsets.fromLTRB(10, 5, 10, 50),
      //       child: Text(
      //         widget.feedbackText,
      //         style: TextStyle(fontSize: 25.0),
      //       ),
      //     ),
      //     Center(
      //       child: ElevatedButton.icon(
      //         onPressed: () async {
      //           showDialog(
      //               context: context,
      //               builder: (_) => AlertDialog(
      //                     title: const Text(
      //                       "Warning!",
      //                       style: TextStyle(color: Colors.redAccent),
      //                     ),
      //                     content: const Text(
      //                         "Do you want to delete this feedback?"),
      //                     elevation: 24.0,
      //                     actions: [
      //                       OutlinedButton(
      //                         onPressed: () async {
      //                           try {
      //                             await _firestore
      //                                 .doc(widget.documentId)
      //                                 .delete()
      //                                 .then((_) {
      //                               Navigator.of(context)
      //                                   .pushNamedAndRemoveUntil(
      //                                       '/feedback', (route) => false);
      //                               ScaffoldMessenger.of(context)
      //                                   .showSnackBar(const SnackBar(
      //                                 content: Text(
      //                                   "Feedback deleted successfully.",
      //                                   style: TextStyle(fontSize: 20.0),
      //                                 ),
      //                                 backgroundColor: Colors.green,
      //                               ));
      //                             });
      //                           } on FirebaseException {
      //                             //print(e);
      //                             Navigator.pop(context);
      //                             ScaffoldMessenger.of(context)
      //                                 .showSnackBar(const SnackBar(
      //                               content: Text(
      //                                 "Error occured!",
      //                                 style: TextStyle(fontSize: 20.0),
      //                               ),
      //                               backgroundColor: Colors.redAccent,
      //                             ));
      //                           }
      //                         },
      //                         child: const Text("YES"),
      //                       ),
      //                       OutlinedButton(
      //                         onPressed: () async {
      //                           Navigator.pop(context);
      //                         },
      //                         child: const Text("NO"),
      //                       ),
      //                     ],
      //                   ),
      //               barrierDismissible: true);
      //         },
      //         icon: Icon(Icons.delete),
      //         label: Text('Delete'),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
