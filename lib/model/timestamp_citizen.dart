import 'package:thesis/constants.dart';

class TimestampCitizen {
  String adi;
  String adp;
  String bmi;
  String cap;
  String cf;
  String crs;
  String allergieCutaneeRespiratorieSistemiche;
  String allergieVelenoImenotteri;
  String altezza;
  String anamnesiFamigliari;
  String areaUtenza;
  String attivitaLavorativa;
  String ausili;
  String capacitaMotoriaAssistito;
  String codiceATS;
  String codiceEsenzione;
  String cognome;
  String comuneDomicilio;
  String comuneNascita;
  String comuneRilascio;
  String contatto1;
  String contatto2;
  String contattoCareGiver;
  String dataNascita;
  String dataRilascio;
  String dataScadenza;
  String donazioneOrgani;
  String email;
  String emailMedico;
  String fattoreRH;
  String fattoriRischio;
  String gravidanzeParti;
  String gruppoSanguigno;
  String indirizzoDomicilio;
  String nome;
  String nomeMedico;
  String numeroCartaIdentita;
  String organiMancanti;
  List<String> patologieCronicheRilevanti;
  List<String> patologieInAtto;
  String pec;
  String peso;
  String pressioneArteriosa;
  String protesi;
  String provinciaDomicilio;
  String provinciaNascita;
  String reazioniAvverseFarmaciAlimenti;
  String retiPatologieAssistito;
  String rilevantiMalformazioni;
  String servizioAssociazione;
  String sesso;
  String telefono;
  String telefono1;
  String telefono2;
  String telefonoCareGiver;
  String telefonoMedico;
  String terapieFarmacologiche;
  String terapieFarmacologicheCroniche;
  String trapianti;
  String vaccinazioni;
  String viveSolo;

  TimestampCitizen(
      {this.adi,
      this.adp,
      this.bmi,
      this.cap,
      this.cf,
      this.crs,
      this.allergieCutaneeRespiratorieSistemiche,
      this.allergieVelenoImenotteri,
      this.altezza,
      this.anamnesiFamigliari,
      this.areaUtenza,
      this.attivitaLavorativa,
      this.ausili,
      this.capacitaMotoriaAssistito,
      this.codiceATS,
      this.codiceEsenzione,
      this.cognome,
      this.comuneDomicilio,
      this.comuneNascita,
      this.comuneRilascio,
      this.contatto1,
      this.contatto2,
      this.contattoCareGiver,
      this.dataNascita,
      this.dataRilascio,
      this.dataScadenza,
      this.donazioneOrgani,
      this.email,
      this.emailMedico,
      this.fattoreRH,
      this.fattoriRischio,
      this.gravidanzeParti,
      this.gruppoSanguigno,
      this.indirizzoDomicilio,
      this.nome,
      this.nomeMedico,
      this.numeroCartaIdentita,
      this.organiMancanti,
      this.patologieCronicheRilevanti,
      this.patologieInAtto,
      this.pec,
      this.peso,
      this.pressioneArteriosa,
      this.protesi,
      this.provinciaDomicilio,
      this.provinciaNascita,
      this.reazioniAvverseFarmaciAlimenti,
      this.retiPatologieAssistito,
      this.rilevantiMalformazioni,
      this.servizioAssociazione,
      this.sesso,
      this.telefono,
      this.telefono1,
      this.telefono2,
      this.telefonoCareGiver,
      this.telefonoMedico,
      this.terapieFarmacologiche,
      this.terapieFarmacologicheCroniche,
      this.trapianti,
      this.vaccinazioni,
      this.viveSolo});

  setDoctorsInfo(String nome, String email, String telefono) {
    nomeMedico = nome;
    emailMedico = email;
    telefonoMedico = telefono;
  }

  //dati anagrafici
  Map<String, String> toMapPSSSectionZero() {
    return {
      'Nome': nome + " " + cognome,
      'Data di nascita': dataNascita,
      'Codice fiscale': cf,
      'Numero carta d\'identità': numeroCartaIdentita,
      'Comune di rilascio': comuneRilascio,
      'Data di scadenza': dataScadenza,
      'Carta regionale dei servizi': crs,
      'Sesso': sesso,
      'Comune di nascita': comuneNascita,
      'Provincia di nascita': provinciaNascita,
      'Indirizzo di domicilio': indirizzoDomicilio,
      'Comune di domicilio': comuneDomicilio,
      'Provincia di domicilio': provinciaDomicilio,
      'CAP': cap,
      'Email': email,
      'Telefono': telefono,
      'Pec': pec,
      'Attività lavorativa': attivitaLavorativa,
    };
  }

  //dati personali
  Map<String, String> toMapPSSSectionOne() {
    return {
      'Altezza': altezza,
      'Peso': peso,
      'BMI': bmi,
      'Gruppo sanguigno': gruppoSanguigno + getFattoreRH(),
      'Pressione arteriosa': pressioneArteriosa,
      'Donazione organi': donazioneOrgani,
      'Gravidanze e parti': gravidanzeParti,
      'Vaccinazioni': vaccinazioni,
    };
  }

  //contatti
  Map<String, String> toMapPSSSectionTwo() {
    return {
      "Contatto di emergenza 1": contatto1 + " - " + telefono1,
      "Contatto di emergenza 2": contatto2 + " - " + telefono2,
      "Contatto caregiver": contattoCareGiver + " - " + telefonoCareGiver,
      'Vive solo': viveSolo,
    };
  }

  //allergie
  Map<String, String> toMapPSSSectionThree() {
    return {
      'Allergie cutanee, respiratorie e sistemiche':
          allergieCutaneeRespiratorieSistemiche,
      'Allergie a veleno di imenotteri': allergieVelenoImenotteri,
      'Reazioni avverse a farmaci e alimenti': reazioniAvverseFarmaciAlimenti,
    };
  }

  //patologie e terapie
  Map<String, String> toMapPSSSectionFour() {
    return {
      'Patologie croniche rilevanti':
          fromListToString(patologieCronicheRilevanti),
      'Patologie in atto': fromListToString(patologieInAtto),
      'Terapie farmacologiche croniche': terapieFarmacologicheCroniche,
      'Terapie farmacologiche': terapieFarmacologiche,
      "Anamnesi Famigliari": anamnesiFamigliari,
      'Fattori di rischio': fattoriRischio,
      'Capacità motoria': capacitaMotoriaAssistito,
      'Ausili': ausili,
      'Protesi': protesi,
      'Organi mancanti': organiMancanti,
      'Trapianti': trapianti,
      'Rilevanti malformazioni': rilevantiMalformazioni,
    };
  }

  //rete sanitaria
  Map<String, String> toMapPSSSectionFive() {
    return {
      'ADI': adi,
      'ADP': adp,
      'Area d\'utenza': areaUtenza,
      'Codice ATS': codiceATS,
      'Codici di esenzione': codiceEsenzione,
      'Reti di patologie': retiPatologieAssistito,
      'Servizio o associazione': servizioAssociazione,
    };
  }

  Map<String, String> toMapSheetSectionOne() {
    return {
      'Nome e Cognome': nome + " " + cognome,
      'Data di nascita': dataNascita,
      'Indirizzo': indirizzoDomicilio,
      'Città': comuneDomicilio,
      'C.I n°': numeroCartaIdentita,
      'Comune di rilascio': comuneRilascio,
      'Data di rilascio': dataRilascio,
      'Codice Fiscale': cf
    };
  }

  Map<String, String> toMapSheetSectionTwo() {
    return {
      'CRS n°': crs,
      'Codice di esenzione': codiceEsenzione,
      'Codice ATS assistito': codiceATS,
      'Medico Curante': nomeMedico,
      'Telefono': telefonoMedico,
      'Email': emailMedico
    };
  }

  Map<String, String> toMapSheetSectionThree() {
    return {
      'Nome e Cognome ICE 1': contatto1,
      'Telefono 1': telefono1,
      'Nome e Cognome ICE 2': contatto2,
      'Telefono 2': telefono2
    };
  }

  Map<String, String> toMapSheetSectionFour() {
    return {
      'Gruppo sanguigno': gruppoSanguigno,
      'Fattore Rh': fattoreRH,
      'Patologie': fromListToString(patologieCronicheRilevanti),
      'Allergie ed intolleranze gravi': allergieCutaneeRespiratorieSistemiche
    };
  }

  Map<String, String> toMapIta() {
    return {
      'Nome': nome + " " + cognome,
      'Data di nascita': dataNascita,
      'Gruppo sanguigno': gruppoSanguigno + getFattoreRH(),
      'Contatto ICE1': telefono1,
      'Contatto ICE2': telefono2,
      'Allergie': allergieCutaneeRespiratorieSistemiche,
      'Patologie in atto': fromListToString(patologieInAtto),
      'Patologie croniche': fromListToString(patologieCronicheRilevanti),
      'Terapie': terapieFarmacologicheCroniche
    };
  }

  String getLifeSavingInformation() {
    return datiSalvavita +
        aCapo +
        "Nome: " +
        nome +
        space +
        cognome +
        aCapo +
        "Data di nascita: " +
        dataNascita +
        aCapo +
        "Gruppo sanguigno: " +
        gruppoSanguigno +
        getFattoreRH() +
        aCapo +
        "Contatto ICE1: " +
        contatto1 +
        dash +
        telefono1 +
        aCapo +
        "Contatto ICE1: " +
        contatto2 +
        dash +
        telefono2 +
        aCapo +
        "Allergie: " +
        allergieCutaneeRespiratorieSistemiche +
        aCapo +
        "Patologie in atto: " +
        fromListToString(patologieInAtto) +
        aCapo +
        "Patologie croniche: " +
        fromListToString(patologieCronicheRilevanti) +
        aCapo +
        "Terapie: " +
        terapieFarmacologicheCroniche;
  }

  String getFattoreRH() {
    if (fattoreRH == "Positivo")
      return "+";
    else
      return "-";
  }
}
