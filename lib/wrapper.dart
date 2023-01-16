import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis/constants.dart';
import 'package:thesis/model/doctor.dart';
import 'package:thesis/model/end_user.dart';
import 'package:thesis/model/citizen.dart';
import 'package:thesis/model/volunteer.dart';
import 'package:thesis/screens/emergency_numbers.dart';
import 'package:thesis/screens/homepage.dart';
import 'package:thesis/screens/login.dart';
import 'package:thesis/screens/qr_code_scanner.dart';
import 'package:thesis/screens/volunteer_screen.dart';
import 'package:thesis/services/database_service.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool logged = false;

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        logged = false;
      });
    } else {
      setState(() {
        logged = true;
      });
    }
    // alternativa web che lancia eccezioni in fase di login
    /* FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {
          logged = false;
        });
      } else {
        setState(() {
          logged = true;
        });
      }
    }); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (logged) {
      return FutureBuilder<EndUser>(
          future: DatabaseService().getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              EndUser endUser = snapshot.data;
              if (snapshot.data.userType == cittadino) {
                return FutureBuilder<List<dynamic>>(
                    future: DatabaseService().getCitizen(endUser.cf),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Citizen citizen = snapshot.data[0];
                        Volunteer volunteer = snapshot.data[1];
                        Doctor doctor = snapshot.data[2];
                        return Homepage(
                            citizen,
                            volunteer,
                            doctor,
                            openQRCodeScanner,
                            openEmergencyNumbersLogged,
                            logout);
                      } else {
                        return Scaffold(
                            body: Center(child: CircularProgressIndicator()));
                      }
                    });
              } else if (snapshot.data.userType == volontario) {
                return FutureBuilder<List<Citizen>>(
                    future: DatabaseService().getCitizensList(endUser.cf),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Citizen> citizens = snapshot.data;
                        DatabaseService().populateCitizensData(citizens);
                        return VolunteerScreen(endUser, citizens, logout);
                      } else {
                        return Scaffold(
                            body: Center(child: CircularProgressIndicator()));
                      }
                    });
              } else {
                return Login(setLogged, openQRCodeScanner,
                    openEmergencyNumbersNotLogged);
              }
            } else {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          });
    } else {
      return Login(setLogged, openQRCodeScanner, openEmergencyNumbersNotLogged);
    }
  }

  setLogged() {
    setState(() {
      logged = true;
    });
  }

  openQRCodeScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRCodeScanner()),
    );
  }

  openEmergencyNumbersLogged(Volunteer volunteer, Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmergencyNumbers(
                true,
                volunteer: volunteer,
                doctor: doctor,
              )),
    );
  }

  openEmergencyNumbersNotLogged() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmergencyNumbers(false)),
    );
  }

  logout() async {
    _showLoadingDialog();
  }

  Future<void> _showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                        'Vuoi eseguire il logout dal sistema e tornare alla schermata di login?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('INDIETRO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('LOGOUT'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                setState(() {
                  logged = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
