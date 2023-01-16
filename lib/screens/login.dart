import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:thesis/services/auth_service.dart';

class Login extends StatelessWidget {
  final setLogged;
  final openQRCodeScanner;
  final openEmergencyNumbers;
  Login(this.setLogged, this.openQRCodeScanner, this.openEmergencyNumbers);

  Duration get loginTime => Duration(milliseconds: 1000);

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      bool result = await AuthService().login(data.name, data.password);
      if (!result) {
        return "Errore nell'inserimento delle credenziali.";
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) async {
      bool result = await AuthService().resetPassword(name);
      if (!result) {
        return "Errore nell'inserimento dell'email.";
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: FlutterLogin(
          logo: "assets/images/logo.png",
          logoTag: "assets/images/logo.png",
          title: "DIGITAL HEALTHCARE",
          titleTag: "DIGITAL HEALTHCARE",
          onLogin: _authUser,
          onSignup: _authUser,
          hideSignUpButton: true,
          emailValidator: (String email) {
            bool validEmail = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email);
            if (email.isEmpty) {
              return "L'email è vuota!";
            }
            return validEmail ? null : 'Email non valida!';
          },
          passwordValidator: (String password) {
            if (password.isEmpty) {
              return "La password è vuota!";
            } else if (password.length < 4) {
              return "La password deve contenere almeno 4 caratteri!";
            }
            return null;
          },
          onSubmitAnimationCompleted: () {
            setLogged();
          },
          onRecoverPassword: _recoverPassword,
          theme: LoginTheme(
              beforeHeroFontSize: 22,
              afterHeroFontSize: 22,
              titleStyle: TextStyle(
                fontFamily: 'Quicksand',
                letterSpacing: 2,
              )),
          messages: LoginMessages(
              goBackButton: "INDIETRO",
              forgotPasswordButton: "Password dimenticata?",
              recoverPasswordIntro: "Resetta la tua password qui.",
              recoverPasswordDescription:
                  "Ti invieeremo un link per il reset della password a questo indirizzo e-mail.",
              recoverPasswordButton: "RESET",
              flushbarTitleError: "Errore!",
              flushbarTitleSuccess: "Successo!",
              recoverPasswordSuccess:
                  "Un email è stata inviata all'indirizzo specificato."),
          loginProviders: kIsWeb
              ? []
              : [
                  LoginProvider(
                    icon: Icons.qr_code_scanner,
                    callback: () async {
                      await Future.delayed(loginTime);
                      openQRCodeScanner();
                      return null;
                    },
                  ),
                  LoginProvider(
                    icon: Icons.contact_phone_outlined,
                    callback: () async {
                      await Future.delayed(loginTime);
                      openEmergencyNumbers();
                      return null;
                    },
                  ),
                ],
        ),
      ),
    ]);
  }
}
