import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mekaar/bloc/AutentikasiBloc.dart';
import 'package:mekaar/halaman/HalamanDaftarCatatanSurvey.dart';
import 'package:mekaar/konstan/KonstanUrl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key key}) : super(key: key);

  @override
  _HalamanLoginState createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final AutentikasiBloc autentikasiBloc = AutentikasiBloc();
  TextEditingController namapenggunaController = TextEditingController();
  TextEditingController katasandiController = TextEditingController();
  String pesanerror = "";
  bool _isObscure = true;
  bool _isVisible = false;
  bool _isLoading = false;

  void bukaURLAPK() async {
    await canLaunch(KonstanUrl.endpointAPK)
        ? await launch(KonstanUrl.endpointAPK)
        : throw 'Tidak dapat membuka ${KonstanUrl.endpointAPK}';
  }

  void bukaURLWeb() async {
    await canLaunch(KonstanUrl.endpointWeb)
        ? await launch(KonstanUrl.endpointWeb)
        : throw 'Tidak dapat membuka ${KonstanUrl.endpointWeb}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "PNM Mekaar - Kalipuro, Banyuwangi",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 200,
            ),
            Image.asset(
              'assets/images/mekaar_color.png',
              height: 250,
              width: 250,
            ),
            SizedBox(
              height: 60,
              width: 10,
            ),
            Visibility(
              visible: _isVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  pesanerror,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              height: 140,
              width: 530,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  border: Border.all(color: Colors.black)),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                    controller: namapenggunaController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nama Pengguna",
                        contentPadding: EdgeInsets.all(20)),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onSaved: (namaPengguna) {
                      namapenggunaController.text = namaPengguna;
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                    controller: katasandiController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Kata Sandi",
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    obscureText: _isObscure,
                    onSaved: (kataSandi) {
                      katasandiController.text = kataSandi;
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: 530,
              padding: EdgeInsets.only(top: 20),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.green,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.yellowAccent),
                      )
                    : Text(
                        "MASUK",
                        style: TextStyle(color: Colors.white),
                      ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (namapenggunaController.text == "" &&
                            katasandiController.text == "") {
                          setState(() {
                            _isVisible = true;
                            pesanerror =
                                "Nama pengguna dan kata sandi tidak boleh kosong";
                          });
                        } else if (namapenggunaController.text == "" &&
                            katasandiController.text != "") {
                          setState(() {
                            _isVisible = true;
                            pesanerror = "Nama pengguna tidak boleh kosong";
                          });
                        } else if (namapenggunaController.text != "" &&
                            katasandiController.text == "") {
                          setState(() {
                            _isVisible = true;
                            pesanerror = "Kata sandi tidak boleh kosong";
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                            if (_isVisible) {
                              _isVisible = false;
                            }
                          });
                          await autentikasiBloc
                              .getLogin(namapenggunaController.text,
                                  katasandiController.text)
                              .then((response) {
                            if (response.success == 0) {
                              setState(() {
                                _isVisible = true;
                                pesanerror =
                                    "Nama pengguna dan atau kata sandi salah";
                              });
                            } else {
                              if (kIsWeb) {
                                if (response.role == "AO") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text("Peringatan"),
                                        content: new Text(
                                            "Maaf, Anda mencoba masuk sebagai Account Officer, silahkan melakukan instalasi aplikasi (.APK) di perangkat Android Anda."),
                                        actions: <Widget>[
                                          // ignore: deprecated_member_use
                                          new FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              bukaURLAPK();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HalamanDaftarCatatanSurvey(),
                                    ),
                                  );
                                }
                              } else {
                                if (response.role == "FAO") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text("Peringatan"),
                                        content: new Text(
                                            "Maaf, Anda mencoba masuk sebagai Finance Administration Officer, silahkan akses aplikasi melalui web browser."),
                                        actions: <Widget>[
                                          // ignore: deprecated_member_use
                                          new FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      child: HalamanDaftarCatatanSurvey(),
                                    ),
                                  );
                                }
                              }
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
