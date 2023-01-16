import 'package:flutter/material.dart';

String datiSalvavita = "DATI SALVAVITA";
String greenPass = "GREEN PASS";
String space = " ";
String aCapo = "\n";
String colon = ":";
String dash = "-";
String cittadino = "cittadino";
String volontario = "volontario";
String medico = "medico";

List<Image> images = [
  Image.asset("assets/images/summary.png"),
  Image.asset("assets/images/sheet.png"),
  Image.asset("assets/images/cis.png"),
  Image.asset("assets/images/badge.png"),
  Image.asset("assets/images/bracelet.png"),
];

List<String> functionalities = [
  "Profilo Sanitario Sintetico",
  "Scheda",
  "CIS",
  "Badge",
  "Braccialetto",
  "Green Pass"
];

List<String> subtitles = [
  "Patient Summary",
  "Scheda Salvavita",
  "Carta d'Identità Salvavita",
  "Badge Salvavita",
  "Braccialetto Salvavita",
];

List<String> descriptions = [
  "Il Profilo Sanitario Sintetico (PSS) è il documento sanitario che riassume la storia clinica del paziente e la sua situazione corrente. Tale documento è creato ed aggiornato dal medico di famiglia.",
  "La Scheda Salvavita contiene il QR code, la foto del cittadino, i dati dell'ATS, le informazioni personali e salvavita e i contatti di emergenza. Tale documento è stato pensato per essere inserito all'interno della Busta Rossa.",
  "La C.I.S. è un tesserino cartaceo che riporta sulla facciata interna sinistra i dati anagrafici, i numeri di telefono da chiamare in caso di emergenza e le informazioni salvavita.",
  "Il badge contiene la foto del cittadino e un QR code che mostra tutte le informazioni salvavita. Il QR può essere letto dal soccorritore con il suo cellulare.",
  "Il Braccialetto Salvavita contiene il QR code e che segnala ai soccorritori che la persona che lo porta è dotata di una Carta d'Identità Salvavita.",
];

List<Icon> icons = [
  Icon(Icons.person),
  Icon(Icons.assignment_rounded),
  Icon(Icons.portrait),
  Icon(Icons.badge),
  Icon(Icons.calendar_view_day),
  Icon(Icons.qr_code),
];

String fromListToString(List<String> list) {
  String returnedString = "";
  for (int i = 0; i < list.length; i++) {
    if (i == list.length - 1) {
      returnedString = returnedString + list[i];
    } else {
      returnedString = returnedString + list[i] + ", ";
    }
  }
  return returnedString;
}

String fromStringToDate(String date) {
  List<String> splittedDate = date.split("-");
  return splittedDate[2] +
      " " +
      _getMonth(int.parse(splittedDate[1])) +
      " " +
      splittedDate[0];
}

String fromMillisecondsToDate(String date) {
  int dateInt = int.parse(date);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateInt);
  return formatDate(dateTime);
}

String formatDate(DateTime date) {
  return date.day.toString() +
      " " +
      _getMonth(date.month) +
      " " +
      date.year.toString();
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return "Gennaio";
    case 2:
      return "Febbraio";
    case 3:
      return "Marzo";
    case 4:
      return "Aprile";
    case 5:
      return "Maggio";
    case 6:
      return "Giugno";
    case 7:
      return "Luglio";
    case 8:
      return "Agosto";
    case 9:
      return "Settembre";
    case 10:
      return "Ottobre";
    case 11:
      return "Novembre";
    case 12:
      return "Dicembre";
    default:
      return "";
  }
}
