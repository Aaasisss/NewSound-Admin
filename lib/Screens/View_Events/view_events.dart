import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newsound_admin/Models/event_model.dart';
import 'package:newsound_admin/Screens/View_Events/edit_event.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({Key? key}) : super(key: key);

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  final _firestore = FirebaseFirestore.instance.collection('events');

  Widget buildEventTile(Event event, String eventId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.amber,
          border: Border.all(color: Colors.black, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Hero(
                    tag: event.photoUrl,
                    child: Image(
                      image: NetworkImage(
                        event.photoUrl,
                      ),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditEvent(
                          event: event,
                          eventId: eventId,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${event.title}",
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${event.date}, ${event.time}: ${event.timeZone} time",
                        style: const TextStyle(fontSize: 15.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditEvent(
                                    event: event,
                                    eventId: eventId,
                                  )));
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text(
                                  "Warning!",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                content: const Text(
                                    "Do you want to delete this event?"),
                                elevation: 24.0,
                                actions: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      try {
                                        await _firestore
                                            .doc(eventId)
                                            .delete()
                                            .then((_) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              "Event deleted successfully.",
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
                    icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Events')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            _firestore.orderBy("serverTimeStamp", descending: true).snapshots(),
        //it creates a stream of documents in the decreasing order of serverTimeStamp field of the document
        builder: (context, asyncSnapshot) {
          //list of the actual widgets shown on the screen
          List<Widget> eventWidgetsList = [];
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasData) {
            //list of querysnapshots
            final events = asyncSnapshot.data!.docs;

            for (var event in events) {
              //document
              final data = event.data();
              String eventId = event.id;

              //create event object from the document
              final eventInstance = Event.fromJson(data);

              eventWidgetsList.add(buildEventTile(eventInstance, eventId));
            }
            //print(eventsMapWithId);

            return ListView(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              children: eventWidgetsList,
            );
          } else if (asyncSnapshot.hasError) {
            return const Text(
              "Problem loading data!",
              style: TextStyle(color: Colors.red),
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
