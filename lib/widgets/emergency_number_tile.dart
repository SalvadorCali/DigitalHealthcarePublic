import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumberTile extends StatelessWidget {
  final Icon icon;
  final String number;
  final String description;
  EmergencyNumberTile(this.icon, this.number, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: icon,
        title: Text(number),
        subtitle: Text(description),
        onTap: _launchURL,
      ),
    );
  }

  _launchURL() async {
    String url = 'tel:' + number;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch';
  }
}
