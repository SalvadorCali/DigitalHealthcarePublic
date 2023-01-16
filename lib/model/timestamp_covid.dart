import 'package:thesis/constants.dart';

class TimestampCovid {
  String data;
  String esito;
  String link;
  String nomeVaccino;
  String tipologia;

  TimestampCovid({
    this.data,
    this.esito,
    this.link,
    this.nomeVaccino,
    this.tipologia,
  });

  String _getTitle() {
    if (tipologia == "Vaccinazione") {
      return tipologia + space + nomeVaccino + space + dash + space + esito;
    } else {
      return tipologia + space + esito;
    }
  }

  String getCovidInformation() {
    return data + colon + space + _getTitle() + aCapo;
  }
}
