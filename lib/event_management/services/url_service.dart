import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile_frontend/event_registration/screens/registration_form_generator.dart';

class UrlService {  
  _generateExternalUrl(){
     final String externalUrl = "https://myapp.com/register/event-italian-festa";
     return externalUrl;
  }

  void copyAndNavigate(BuildContext context) {
  Clipboard.setData(ClipboardData(text: _generateExternalUrl()));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("External URL copied to clipboard")),
  );
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegistrationFormGenerator()),
  );
  }

}