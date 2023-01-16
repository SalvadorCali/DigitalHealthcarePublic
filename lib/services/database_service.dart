import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis/constants.dart';
import 'package:thesis/model/doctor.dart';
import 'package:thesis/model/end_user.dart';
import 'package:thesis/model/citizen.dart';
import 'package:thesis/model/timestamp_citizen.dart';
import 'package:thesis/model/timestamp_covid.dart';
import 'package:thesis/model/volunteer.dart';
import 'package:thesis/services/auth_service.dart';

class DatabaseService {
  AuthService _auth = AuthService();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference citizens =
      FirebaseFirestore.instance.collection('citizens');
  final CollectionReference volunteers =
      FirebaseFirestore.instance.collection('volunteers');
  final CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');

  Future<EndUser> getUser() {
    return users
        .doc(_auth.getCurrentUser().uid)
        .get()
        .then((value) => _userFromFirebase(value));
  }

  EndUser _userFromFirebase(DocumentSnapshot snapshot) {
    return EndUser(
        uid: snapshot.data()['uid'],
        cf: snapshot.data()['CF'],
        email: snapshot.data()['email'],
        photoURL: snapshot.data()['photoURL'],
        userType: snapshot.data()['userType']);
  }

  Future<List<dynamic>> getCitizen(String tin) async {
    List<dynamic> citizenData = [];
    String name;
    String surname;
    String photoURL;
    String cfVolunteer;
    String cfDoctor;
    Volunteer volunteer;
    Doctor doctor;
    Map<String, TimestampCitizen> citizenMap;
    Map<String, TimestampCovid> covidMap;
    await citizens.doc(tin).get().then((value) => {
          name = getField(value, "nome"),
          surname = getField(value, "cognome"),
          photoURL = getField(value, "photoURL"),
          cfVolunteer = getField(value, "CFVolontario"),
          cfDoctor = getField(value, "CFMedico"),
        });
    await citizens.doc(tin).collection('data').get().then((value) {
      citizenMap = _citizenFromFirebase(value);
    });
    await citizens.doc(tin).collection('covid19').get().then((value) {
      if (value.size != 0) {
        covidMap = _covidFromFirebase(value);
      }
    });
    citizenData.add(Citizen(tin, cfVolunteer, cfDoctor, name, surname, photoURL,
        citizenMap, covidMap));
    volunteer = await volunteers.doc(cfVolunteer).get().then((value) =>
        Volunteer(
            getField(value, "CF"),
            getField(value, "nome"),
            getField(value, "cognome"),
            getField(value, "email"),
            getField(value, "pec"),
            getField(value, "telefono")));
    citizenData.add(volunteer);
    doctor = await doctors.doc(cfDoctor).get().then((value) => Doctor(
        getField(value, "CF"),
        getField(value, "nome"),
        getField(value, "cognome"),
        getField(value, "email"),
        getField(value, "pec"),
        getField(value, "telefono")));
    citizenData.add(doctor);
    citizenData[0].data.values.forEach((v) => v.setDoctorsInfo(
        doctor.nome + " " + doctor.cognome, doctor.email, doctor.telefono));
    return citizenData;
  }

  Map<String, TimestampCitizen> _citizenFromFirebase(QuerySnapshot snapshot) {
    Map<String, TimestampCitizen> data = Map();
    TimestampCitizen patient;
    snapshot.docs.forEach((element) {
      patient = TimestampCitizen(
        adi: getFieldQuery(element, "ADI"),
        adp: getFieldQuery(element, "ADP"),
        bmi: getFieldQuery(element, "BMI"),
        cap: getFieldQuery(element, "CAP"),
        cf: getFieldQuery(element, "CF"),
        crs: getFieldQuery(element, "CRS"),
        allergieCutaneeRespiratorieSistemiche:
            getFieldQuery(element, "allergieCutaneeRespiratorieSistemiche"),
        allergieVelenoImenotteri:
            getFieldQuery(element, "allergieVelenoImenotteri"),
        altezza: getFieldQuery(element, "altezza"),
        anamnesiFamigliari: getFieldQuery(element, "anamnesiFamigliari"),
        areaUtenza: getFieldQuery(element, "areaUtenza"),
        attivitaLavorativa: getFieldQuery(element, "attivitaLavorativa"),
        ausili: getFieldQuery(element, "ausili"),
        capacitaMotoriaAssistito:
            getFieldQuery(element, "capacitaMotoriaAssistito"),
        codiceATS: getFieldQuery(element, "codiceATS"),
        codiceEsenzione: getFieldQuery(element, "codiceEsenzione"),
        cognome: getFieldQuery(element, "cognome"),
        comuneDomicilio: getFieldQuery(element, "comuneDomicilio"),
        comuneNascita: getFieldQuery(element, "comuneNascita"),
        comuneRilascio: getFieldQuery(element, "comuneRilascio"),
        contatto1: getFieldQuery(element, "contatto1"),
        contatto2: getFieldQuery(element, "contatto2"),
        contattoCareGiver: getFieldQuery(element, "contattoCareGiver"),
        dataNascita: getFieldQuery(element, "dataNascita"),
        dataRilascio: getFieldQuery(element, "dataRilascio"),
        dataScadenza: getFieldQuery(element, "dataScadenza"),
        donazioneOrgani: getFieldQuery(element, "donazioneOrgani"),
        email: getFieldQuery(element, "email"),
        fattoreRH: getFieldQuery(element, "fattoreRH"),
        fattoriRischio: getFieldQuery(element, "fattoriRischio"),
        gravidanzeParti: getFieldQuery(element, "gravidanzeParti"),
        gruppoSanguigno: getFieldQuery(element, "gruppoSanguigno"),
        indirizzoDomicilio: getFieldQuery(element, "indirizzoDomicilio"),
        nome: getFieldQuery(element, "nome"),
        numeroCartaIdentita: getFieldQuery(element, "numeroCartaIdentità"),
        organiMancanti: getFieldQuery(element, "organiMancanti"),
        patologieCronicheRilevanti:
            getFieldListQuery(element, "patologieCronicheRilevanti"),
        patologieInAtto: getFieldListQuery(element, "patologieInAtto"),
        pec: getFieldQuery(element, "pec"),
        peso: getFieldQuery(element, "peso"),
        pressioneArteriosa: getFieldQuery(element, "pressioneArteriosa"),
        protesi: getFieldQuery(element, "protesi"),
        provinciaDomicilio: getFieldQuery(element, "provinciaDomicilio"),
        provinciaNascita: getFieldQuery(element, "provinciaNascita"),
        reazioniAvverseFarmaciAlimenti:
            getFieldQuery(element, "reazioniAvverseFarmaciAlimenti"),
        retiPatologieAssistito:
            getFieldQuery(element, "retiPatologieAssistito"),
        rilevantiMalformazioni:
            getFieldQuery(element, "rilevantiMalformazioni"),
        servizioAssociazione: getFieldQuery(element, "servizioAssociazione"),
        sesso: getFieldQuery(element, "sesso"),
        telefono: getFieldQuery(element, "telefono"),
        telefono1: getFieldQuery(element, "telefono1"),
        telefono2: getFieldQuery(element, "telefono2"),
        telefonoCareGiver: getFieldQuery(element, "telefonoCareGiver"),
        terapieFarmacologiche: getFieldQuery(element, "terapieFarmacologiche"),
        terapieFarmacologicheCroniche:
            getFieldQuery(element, "terapieFarmacologicheCroniche"),
        trapianti: getFieldQuery(element, "trapianti"),
        vaccinazioni: getFieldQuery(element, "vaccinazioni"),
        viveSolo: getFieldQuery(element, "viveSolo"),
      );
      data.addAll({fromMillisecondsToDate(element.id): patient});
    });
    return data;
  }

  Map<String, TimestampCovid> _covidFromFirebase(QuerySnapshot snapshot) {
    Map<String, TimestampCovid> data = Map();
    TimestampCovid covid;
    snapshot.docs.forEach((element) {
      covid = TimestampCovid(
          data: getFieldQuery(element, "data"),
          esito: getFieldQuery(element, "esito"),
          link: getFieldQuery(element, "link"),
          nomeVaccino: getFieldQuery(element, "nomeVaccino"),
          tipologia: getFieldQuery(element, "tipologia"));
      data.addAll({fromStringToDate(covid.data): covid});
    });
    return data;
  }

  Future<List<Citizen>> getCitizensList(String tin) {
    Map<String, TimestampCitizen> citizensMap = Map();
    Map<String, TimestampCovid> covidMap = Map();
    return citizens.where("CFVolontario", isEqualTo: tin).get().then((value) =>
        value.docs
            .map((e) => Citizen(
                e.id,
                getFieldQuery(e, "CFVolontario"),
                getFieldQuery(e, "CFMedico"),
                getFieldQuery(e, "nome"),
                getFieldQuery(e, "cognome"),
                getFieldQuery(e, "photoURL"),
                citizensMap,
                covidMap))
            .toList());
  }

  populateCitizensData(List<Citizen> citizensList) {
    citizensList.forEach((element) {
      citizens.doc(element.cf).collection("data").get().then((value) {
        element.data = _citizenFromFirebase(value);
      });
      citizens
          .doc(element.cf)
          .collection("covid19")
          .orderBy("data")
          .get()
          .then((value) {
        element.covid = _covidFromFirebase(value);
      });
    });
  }

  String getField(DocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return "-";
    }
    return document[field] == "" ? "-" : document[field];
  }

  String getFieldQuery(QueryDocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return "-";
    }
    return document[field] == "" ? "-" : document[field];
  }

  List<String> getFieldListQuery(QueryDocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return ["-"];
    }
    return List.from(document[field]).isEmpty
        ? ["-"]
        : List.from(document[field]);
  }
}
