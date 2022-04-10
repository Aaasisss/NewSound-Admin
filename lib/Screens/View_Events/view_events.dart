import 'package:flutter/material.dart';
import 'package:newsound_admin/Screens/View_Events/edit_event.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({Key? key}) : super(key: key);

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  Widget buildEventTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
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
                    tag: AssetImage("lib/Images/pasters.png"),
                    child: Image(
                      image: AssetImage(
                        "lib/Images/pasters.png",
                      ),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditEvent()));
                  },
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Title this is the title it is so long Event Title this is the title it is so long",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Event date, time s the title it is so long Event Title this is t",
                        style: TextStyle(fontSize: 15.0),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditEvent()));
                    },
                    icon: Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
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
      appBar: AppBar(title: Text('View Events')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Form(
          child: Column(
            children: <Widget>[
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
              buildEventTile(),
            ],
          ),
        )),
      ),
    );
  }
}
