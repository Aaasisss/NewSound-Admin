import 'package:flutter/material.dart';

final List<Widget> homepageItemList = [
  const ItemSettings(),
  const ItemViewEvents(),
  const ItemAddEvents(),
  const ItemLinks(),
  const ItemBankDetails(),
  const ItemFeedback(),
];

class ItemSettings extends StatefulWidget {
  const ItemSettings({Key? key}) : super(key: key);

  @override
  State<ItemSettings> createState() => _ItemSettingsState();
}

class _ItemSettingsState extends State<ItemSettings> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/settings');
      },
      child: const ListTile(
        leading: Icon(Icons.settings),
        title: const Text('Settings'),
      ),
    );
  }
}

class ItemViewEvents extends StatefulWidget {
  const ItemViewEvents({Key? key}) : super(key: key);

  @override
  State<ItemViewEvents> createState() => _ItemViewEventsState();
}

class _ItemViewEventsState extends State<ItemViewEvents> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/view_events');
      },
      child: const ListTile(
        leading: const Icon(Icons.remove_red_eye),
        title: const Text('View Events'),
      ),
    );
  }
}

class ItemAddEvents extends StatefulWidget {
  const ItemAddEvents({Key? key}) : super(key: key);

  @override
  State<ItemAddEvents> createState() => _ItemAddEventsState();
}

class _ItemAddEventsState extends State<ItemAddEvents> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/add_events');
      },
      child: const ListTile(
        leading: Icon(Icons.add),
        title: Text('Add Events'),
      ),
    );
  }
}

class ItemLinks extends StatefulWidget {
  const ItemLinks({Key? key}) : super(key: key);

  @override
  State<ItemLinks> createState() => _ItemLinksState();
}

class _ItemLinksState extends State<ItemLinks> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/links');
      },
      child: const ListTile(
        leading: Icon(Icons.link),
        title: Text('Social Links'),
      ),
    );
  }
}

class ItemBankDetails extends StatefulWidget {
  const ItemBankDetails({Key? key}) : super(key: key);

  @override
  State<ItemBankDetails> createState() => _ItemBankDetailsState();
}

class _ItemBankDetailsState extends State<ItemBankDetails> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/bank_details');
      },
      child: const ListTile(
        leading: Icon(Icons.money),
        title: Text('Bank Details'),
      ),
    );
  }
}

class ItemFeedback extends StatefulWidget {
  const ItemFeedback({Key? key}) : super(key: key);

  @override
  State<ItemFeedback> createState() => _ItemFeedbackState();
}

class _ItemFeedbackState extends State<ItemFeedback> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/feedback');
      },
      child: const ListTile(
        leading: Icon(Icons.feedback),
        title: Text('View Feedbacks'),
      ),
    );
  }
}
