import 'package:flutter/material.dart';
import 'package:mekaar/halaman/HalamanDaftarCatatanSurvey.dart';
import 'package:mekaar/halaman/HalamanLogin.dart';
import 'package:mekaar/utilitas/Injector.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await baseDio();
  setPathUrlStrategy();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  PreferencesUtil util = PreferencesUtil();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNM Mekaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SanFrancisco',
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: util.isKeyExists(PreferencesUtil.idpengguna)
            ? HalamanDaftarCatatanSurvey()
            : HalamanLogin(),
      ),
    );
  }
}
