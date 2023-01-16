import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:thesis/model/doctor.dart';
import 'package:thesis/model/volunteer.dart';
import 'package:thesis/widgets/emergency_number_tile.dart';
import 'package:thesis/widgets/numbers_card.dart';

class EmergencyNumbers extends StatelessWidget {
  final Volunteer volunteer;
  final Doctor doctor;
  final bool logged;
  EmergencyNumbers(this.logged, {this.volunteer, this.doctor});

  @override
  Widget build(BuildContext context) {
    return logged
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Numeri Utili"),
                bottom: TabBar(
                  tabs: (kIsWeb &&
                          MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height)
                      ? [
                          Tab(icon: Icon(Icons.add_call), text: "Contatti"),
                          Tab(
                              icon: Icon(Icons.warning_rounded),
                              text: "Emergenza"),
                        ]
                      : [
                          Tab(icon: Icon(Icons.add_call)),
                          Tab(icon: Icon(Icons.warning_rounded)),
                        ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildContacts(context),
                  _buildEmergency(context),
                ],
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text("Numeri di Emergenza"),
            ),
            body: _buildEmergency(context),
          );
  }

  Widget _buildContacts(context) {
    return (kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/contacts-web.png"),
              ),
              Flexible(
                  child: Scrollbar(
                child: ListView(
                  children: [
                    NumbersCard(
                        Icon(Icons.local_hospital),
                        doctor.fullName(),
                        "Medico di base",
                        doctor.telefono == "-"
                            ? "Non fornito"
                            : doctor.telefono,
                        doctor.email == "-" ? "Non fornito" : doctor.email),
                    NumbersCard(
                        Icon(Icons.work),
                        volunteer.fullName(),
                        "Volontario comunale",
                        volunteer.telefono == "-"
                            ? "Non fornito"
                            : volunteer.telefono,
                        volunteer.email == "-"
                            ? "Non fornito"
                            : volunteer.email)
                  ],
                ),
              ))
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/contacts.png"),
              ),
              NumbersCard(
                  Icon(Icons.local_hospital),
                  doctor.fullName(),
                  "Medico di base",
                  doctor.telefono == "-" ? "Non fornito" : doctor.telefono,
                  doctor.email == "-" ? "Non fornito" : doctor.email),
              NumbersCard(
                  Icon(Icons.work),
                  volunteer.fullName(),
                  "Volontario comunale",
                  volunteer.telefono == "-"
                      ? "Non fornito"
                      : volunteer.telefono,
                  volunteer.email == "-" ? "Non fornito" : volunteer.email)
            ],
          );
  }

  Widget _buildEmergency(context) {
    return (kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/emergency-web.png"),
              ),
              Flexible(
                  child: Scrollbar(
                      child: ListView(
                children: [
                  EmergencyNumberTile(
                      Icon(HumanitarianIcons.community_building),
                      "112",
                      "Carabinieri"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.police_station),
                      "113", "Polizia di Stato"),
                  EmergencyNumberTile(
                      Icon(HumanitarianIcons.fire), "115", "Vigili del Fuoco"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.emergency_telecom),
                      "117", "Guardia di Finanza"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.ambulance), "118",
                      "Emergenza Sanitaria"),
                ],
              )))
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/emergency.png"),
              ),
              EmergencyNumberTile(Icon(HumanitarianIcons.community_building),
                  "112", "Carabinieri"),
              EmergencyNumberTile(Icon(HumanitarianIcons.police_station), "113",
                  "Polizia di Stato"),
              EmergencyNumberTile(
                  Icon(HumanitarianIcons.fire), "115", "Vigili del Fuoco"),
              EmergencyNumberTile(Icon(HumanitarianIcons.emergency_telecom),
                  "117", "Guardia di Finanza"),
              EmergencyNumberTile(Icon(HumanitarianIcons.ambulance), "118",
                  "Emergenza Sanitaria"),
            ],
          );
  }
}
