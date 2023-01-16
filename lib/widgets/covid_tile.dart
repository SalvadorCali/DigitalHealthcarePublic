import 'package:flutter/material.dart';
import 'package:thesis/services/pdf_handler.dart';
import 'package:thesis/widgets/function_button.dart';

class CovidTile extends StatelessWidget {
  final String title;
  final String result;
  final String date;
  final String document;
  const CovidTile(this.title, this.result, this.date, this.document);

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(result),
              trailing: document != ""
                  ? FunctionButton(
                      _openDocument, Icon(Icons.picture_as_pdf), "Apri")
                  : SizedBox.shrink(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  _openDocument() {
    PDFHandler().openOnlinePDF(document);
  }
}
