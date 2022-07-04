import 'package:flutter/material.dart';
import 'package:mekaar/bloc/AutentikasiBloc.dart';
import 'package:mekaar/halaman/HalamanDaftarCatatanSurvey.dart';
import 'package:mekaar/halaman/HalamanDaftarKelompokSurvey.dart';
import 'package:mekaar/halaman/HalamanLogin.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';

Widget drawer(BuildContext context, PreferencesUtil util,
    AutentikasiBloc autentikasiBloc) {
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        util.getString(PreferencesUtil.nama),
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        util.getString(PreferencesUtil.role) == "AO"
                            ? 'Account Officer'
                            : 'Finance Administration Officer',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          HalamanDaftarCatatanSurvey(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.contacts,
                  color: Colors.white,
                ),
                title: Text(
                  "Data Nasabah",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          HalamanDaftarKelompokSurvey(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.view_list,
                  color: Colors.white,
                ),
                title: Text(
                  "Data Kelompok Nasabah",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Logout dari aplikasi"),
                  content: new Text("Anda yakin ingin logout?"),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    new FlatButton(
                      child: new Text("Ya"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        autentikasiBloc.logout().then((sudahLogout) {
                          if (sudahLogout) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HalamanLogin(),
                              ),
                            );
                          }
                        });
                      },
                    ),
                    // ignore: deprecated_member_use
                    new FlatButton(
                      child: new Text("Tidak"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          leading: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          title: Text(
            "Log out",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
