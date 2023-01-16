import 'package:thesis/constants.dart';
import 'package:thesis/model/timestamp_citizen.dart';
import 'package:thesis/model/timestamp_covid.dart';

class Citizen {
  String cf;
  String cfVolunteer;
  String cfDoctor;
  String name;
  String surname;
  String photoURL;
  Map<String, TimestampCitizen> data;
  Map<String, TimestampCovid> covid;

  Citizen(this.cf, this.cfVolunteer, this.cfDoctor, this.name, this.surname,
      this.photoURL, this.data, this.covid);

  String get fullName {
    return name + " " + surname;
  }

  String getCovidQRCode() {
    String qrCode = greenPass + aCapo + "Nome: " + fullName + aCapo;
    covid.forEach((key, value) {
      qrCode = qrCode + value.getCovidInformation();
    });
    return qrCode;
  }
}
