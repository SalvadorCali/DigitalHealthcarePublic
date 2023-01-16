import 'package:flutter/material.dart';
import "dart:async";
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:thesis/constants.dart';
import 'package:thesis/model/citizen.dart';
import 'package:thesis/model/end_user.dart';
import 'package:thesis/model/searched_citizen.dart';
import 'package:thesis/model/timestamp_citizen.dart';
import 'package:thesis/services/pdf_handler.dart';
import 'package:thesis/widgets/appbar_button.dart';
import 'package:thesis/widgets/volunteer_card.dart';
import 'package:unicorndial/unicorndial.dart';

class VolunteerScreen extends StatefulWidget {
  final EndUser volunteer;
  final List<Citizen> patients;
  final changeScreen;
  const VolunteerScreen(this.volunteer, this.patients, this.changeScreen);

  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  List<String> qrCodeDataList = [];
  List<String> namesList = [];
  List<String> photosList = [];
  List<String> dateList = [];
  List<SearchedCitizen> patients = [];
  List<SearchedCitizen> queryResult = [];
  List<SearchedCitizen> bodyPatients = [];
  List<Citizen> citizens = [];
  List<TimestampCitizen> timestampCitizens = [];

  @override
  void initState() {
    _initializePatient();
    super.initState();
  }

  _initializePatient() {
    setState(() {
      widget.patients.forEach((element) {
        patients.add(SearchedCitizen(element, false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: bodyPatients.length > 1
            ? _buildFloatingButton()
            : SizedBox.shrink(),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.volunteer.photoURL),
            ),
          ),
          title: Text("Homepage"),
          actions: [
            AppBarButton(Icon(Icons.logout), widget.changeScreen),
          ],
        ),
        body: _searchScreen());
  }

  Widget _searchScreen() {
    return Stack(fit: StackFit.expand, children: [
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 66,
            ),
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: bodyPatients.length,
                itemBuilder: (context, index) {
                  return bodyPatients[index].body
                      ? VolunteerCard(bodyPatients[index].citizen, index,
                          _getDate, _setDate, _removeElement)
                      : SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
      _buildSearchBar(),
    ]);
  }

  FloatingSearchBar _buildSearchBar() {
    return FloatingSearchBar(
      hint: 'Cerca...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: MediaQuery.of(context).size.width,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query != "") {
          setState(() {
            queryResult = patients
                .where((element) =>
                    element.citizen.fullName
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element.citizen.cf
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
          });
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...createQueryResults(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> createQueryResults() {
    List<Widget> widgets = [];
    queryResult.forEach((element) {
      widgets.add(ListTile(
        title: Text(element.citizen.fullName),
        subtitle: Text(element.citizen.cf),
        trailing: element.body
            ? SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    element.body = true;
                    bodyPatients.add(element);
                    citizens.add(element.citizen);
                    dateList.add(element.citizen.data.keys.last);
                  });
                },
                child: Text("Aggiungi")),
      ));
    });
    return widgets;
  }

  String _getDate(int index, String newDate) {
    return dateList[index];
  }

  _setDate(int index, String newDate) {
    setState(() {
      dateList[index] = newDate;
    });
  }

  _removeElement(String tin) {
    bool exit = false;
    for (int i = 0; i < bodyPatients.length; i++) {
      if (bodyPatients[i].citizen.cf == tin) {
        setState(() {
          patients.forEach((member) {
            if (member.citizen.cf == tin) {
              member.body = false;
            }
          });
          bodyPatients.remove(bodyPatients[i]);
          citizens.remove(citizens[i]);
          dateList.remove(dateList[i]);
          exit = true;
        });
        if (exit) break;
      }
    }
  }

  Widget _buildFloatingButton() {
    return UnicornDialer(
      parentButton: Icon(Icons.print),
      childButtons: [
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleData,
            child: icons[0],
          ),
        ),
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleSheet,
            child: icons[1],
          ),
        ),
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleCIS,
            child: icons[2],
          ),
        ),
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleBadge,
            child: icons[3],
          ),
        ),
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleBracelet,
            child: icons[4],
          ),
        ),
        UnicornButton(
          currentButton: FloatingActionButton(
            mini: true,
            onPressed: generateMultipleGreenPass,
            child: icons[5],
          ),
        ),
      ],
    );
  }

  generateMultipleBadge() {
    _createData();
    Future.delayed(Duration(seconds: 1), () async {
      await PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleBadge()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleCIS() {
    _createData();
    Future.delayed(Duration(seconds: 1), () async {
      await PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleCIS()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleBracelet() async {
    _createData();
    await Future.delayed(Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleBracelet()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleSheet() async {
    _createData();
    await Future.delayed(Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleSheet()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleData() async {
    _createData();
    await Future.delayed(Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleData()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleGreenPass() async {
    _createData();
    await Future.delayed(Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, timestampCitizens: timestampCitizens)
          .openMultipleGreenPass()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  _createData() {
    _showLoadingDialog();
    for (int i = 0; i < bodyPatients.length; i++) {
      timestampCitizens.add(bodyPatients[i].citizen.data[dateList[i]]);
      citizens.add(bodyPatients[i].citizen);
    }
  }

  _resetData() {
    timestampCitizens.clear();
    citizens.clear();
    Navigator.of(context).pop();
  }

  Future<void> _showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.upload_file),
                ),
                Center(child: Text('Generazione documento in corso...')),
              ],
            ),
          ),
        );
      },
    );
  }
}
