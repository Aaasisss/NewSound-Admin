import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsound_admin/Screens/View_Feedbacks/edit_feedback.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({Key? key}) : super(key: key);

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  final _firestore = FirebaseFirestore.instance.collection("feedback");

  Widget feedbackWidget(String feedbackText, String id) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
              color: Colors.black, width: 2, style: BorderStyle.solid),
        ),
        shadowColor: Colors.black,
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: Colors.blueAccent,
        elevation: 50.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Text(
              feedbackText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => EditFeedback(
                  feedbackText: feedbackText,
                  documentId: id,
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VIEW FEEDBACKS")),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firestore.orderBy("serverTimeStamp", descending: true).get(),
        builder: (context, asyncSnapshot) {
          List<Widget> feedbackWidgetList = [];
          if (asyncSnapshot.hasData) {
            final documents = asyncSnapshot.data!.docs;
            for (var document in documents) {
              String documentId = document.id;
              Map<String, dynamic> data = document.data();
              String feedbackText = data['feedback'];

              feedbackWidgetList.add(feedbackWidget(feedbackText, documentId));
            }

            return ListView(
              children: feedbackWidgetList,
            );
          } else if (asyncSnapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading data.",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
