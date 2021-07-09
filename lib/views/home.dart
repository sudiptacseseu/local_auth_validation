import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _isAuthorized = "Not Authorized Yet";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.orange.shade700),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Biometric Available : $_canCheckBiometric",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            customButton("Check Biometric", _checkBiometric),
            Text("List of Biometric : ${_availableBiometricTypes.toString()}",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            customButton("Check Biometric Types", _getListOfBiometricTypes),
            Text("Authorized : $_isAuthorized",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            customButton("Authorize Now", _authorizeNow),
          ],
        ),
      ),
    );
  }

  Widget customButton(String buttonText, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: Colors.orange.shade800)),
        onPressed: onPressed,
        child: Text(buttonText, style: TextStyle(color: Colors.white)),
        color: Colors.orange.shade700,
        colorBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    bool _isAuthorized = false;
    List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();

    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID
        // Do Something
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID
        // Do Something
      }
    }

    try {
      availableBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = availableBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;

    // Custom strings for error dialog
    const iosStrings = const IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'Go to settings',
        goToSettingsDescription:
            "Please set up your Touch ID/Face ID. Go to 'Settings > Security' to add your Touch ID/Face ID",
        lockOut: 'Please re enable your Touch ID / Face ID');

    const androidStrings = const AndroidAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'Go to settings',
      goToSettingsDescription:
          "Please set up your Touch ID/Face ID. Go to 'Settings > Security' to add your Touch ID/Face ID",
    );
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your sign in process",
        useErrorDialogs: true,
        stickyAuth: true,

        //Enable these lines to implement custom strings
        //iOSAuthStrings: iosStrings,
        //androidAuthStrings: androidStrings
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _isAuthorized = "Authorized";
      } else {
        _isAuthorized = "Not Authorized";
      }
    });
  }
}
