import 'dart:async';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:mekaar/bloc/AutentikasiBloc.dart';
import 'package:mekaar/bloc/DataSurveyBloc.dart';
import 'package:mekaar/halaman/HalamanDetailCatatanSurvey.dart';
import 'package:mekaar/halaman/HalamanLogin.dart';
import 'package:mekaar/halaman/HalamanUbahDataCatatanSurvey.dart';
import 'package:mekaar/model/response/AmbilDataSurveyResponse.dart';
import 'package:mekaar/utilitas/CekKoneksiInternet.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';
import 'package:mekaar/widget/Drawer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum Pilihan { Ubah, Hapus }

class HalamanDaftarCatatanSurvey extends StatefulWidget {
  HalamanDaftarCatatanSurvey({Key key}) : super(key: key);

  @override
  State<HalamanDaftarCatatanSurvey> createState() =>
      _HalamanDaftarCatatanSurveyState();
}

class _HalamanDaftarCatatanSurveyState
    extends State<HalamanDaftarCatatanSurvey> {
  PreferencesUtil util = PreferencesUtil();
  AutentikasiBloc autentikasiBloc = AutentikasiBloc();
  DataSurveyBloc dataSurveyBloc = DataSurveyBloc();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController pencarianController = TextEditingController();
  String pencarian = "";
  Future<List<AmbilDataSurveyResponse>> future;
  DataTableCatatanSurvey _data = DataTableCatatanSurvey();
  bool adaKoneksiInternet = true;

  Future<void> refreshData() async {
    ambilDataSurveyDiFuture();
  }

  void ambilDataSurveyDiFuture() {
    setState(() {
      future = util.getString(PreferencesUtil.role) == 'AO'
          ? dataSurveyBloc.getDatabyAO()
          : dataSurveyBloc.getData();
    });
  }

  filterlistData(List<AmbilDataSurveyResponse> snapshot) {
    if (snapshot.isNotEmpty) {
      return snapshot
          .where((element) =>
              element.kelompok.containsIgnoreCase(pencarian) ||
              element.catatankunjungan.containsIgnoreCase(pencarian) ||
              element.namanasabah.containsIgnoreCase(pencarian))
          .toList();
    }
    return snapshot ?? [];
  }

  Future opsiMenu(String idcatatan, Function refreshData) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ubah'),
              onPressed: () {
                Navigator.pop(context, Pilihan.Ubah);
              },
            ),
          ],
        );
      },
    )) {
      case Pilihan.Ubah:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanUbahDataCatatanSurvey(
              idCatatan: idcatatan,
            ),
          ),
        );
        break;
      case Pilihan.Hapus:
        break;
    }
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      adaKoneksiInternet = hasConnection;
    });
  }

  @override
  void initState() {
    ambilDataSurveyDiFuture();
    if (!kIsWeb) {
      CekKoneksiInternet connectionStatus = CekKoneksiInternet.getInstance();
      if (!connectionStatus.initialized()) {
        connectionStatus.initialize();
        connectionStatus.connectionChange.listen(connectionChanged);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kIsWeb
              ? 'Selamat Datang, ${util.getString(PreferencesUtil.nama)} - ${util.getString(PreferencesUtil.role)} \nDaftar Nasabah Siklus'
              : 'Daftar Nasabah Siklus',
          textAlign: TextAlign.center,
        ),
        centerTitle: kIsWeb ? true : false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  ambilDataSurveyDiFuture();
                });
              },
            ),
          ),
          kIsWeb
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
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
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: util.getString(PreferencesUtil.role) == 'AO'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanUbahDataCatatanSurvey(),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
              ),
            )
          : null,
      drawer: !kIsWeb && util.getString(PreferencesUtil.role) == "AO"
          ? Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.lightBlue,
              ),
              child: drawer(context, util, autentikasiBloc),
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    pencarian = query;
                  });
                },
                controller: pencarianController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: "Cari",
                  hintText: "Cari",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder<List<AmbilDataSurveyResponse>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Terjadi kesalahan'),
                      );
                    } else if (snapshot.hasData) {
                      final hasilCari = filterlistData(snapshot.data);
                      _data = DataTableCatatanSurvey(
                        data: hasilCari,
                        refreshData: () => ambilDataSurveyDiFuture(),
                        role: util.getString(PreferencesUtil.role),
                        context: context,
                        adaKoneksiInternet: adaKoneksiInternet,
                      );
                      return kIsWeb
                          ? SingleChildScrollView(
                              child: PaginatedDataTable(
                                source: _data,
                                columns: [
                                  DataColumn(
                                    label: const Text('No'),
                                  ),
                                  util.getString(PreferencesUtil.role) == "FAO"
                                      ? DataColumn(
                                          label: Text('Nama Petugas'),
                                        )
                                      : DataColumn(label: Container()),
                                  util.getString(PreferencesUtil.role) == "AO"
                                      ? DataColumn(
                                          label: const Text('ID Nasabah'),
                                        )
                                      : DataColumn(label: Container()),
                                  DataColumn(
                                    label: const Text('Nama Nasabah'),
                                  ),
                                  DataColumn(
                                    label: Text('Kelompok'),
                                  ),
                                  DataColumn(
                                    label: Text('Siklus'),
                                  ),
                                  DataColumn(
                                    label: Text('Berkas Scan Pencairan'),
                                  ),
                                  DataColumn(
                                    label: Text('Foto Survey'),
                                  ),
                                  DataColumn(
                                    label: Text('Catatan Kunjungan'),
                                  ),
                                  DataColumn(
                                    label: Text('Tanggal Kunjungan'),
                                  ),
                                  util.getString(PreferencesUtil.role) == "FAO"
                                      ? DataColumn(label: Container())
                                      : DataColumn(
                                          label: Text('Aksi'),
                                        ),
                                ],
                                rowsPerPage: kIsWeb ? 8 : 10,
                                showCheckboxColumn: false,
                              ),
                            )
                          : RefreshIndicator(
                              key: _refreshIndicatorKey,
                              onRefresh: refreshData,
                              child: ListView.separated(
                                itemCount: hasilCari.length,
                                addAutomaticKeepAlives: true,
                                itemBuilder: (context, index) {
                                  AmbilDataSurveyResponse response =
                                      snapshot.data[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.all(8),
                                        title: Text(response.kelompok),
                                        subtitle: Text(response.namanasabah),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HalamanDetailCatatanSurvey(
                                              idCatatan: response.idcatatan,
                                            ),
                                          ),
                                        ),
                                        onLongPress: () => util.getString(
                                                    PreferencesUtil.role) ==
                                                'AO'
                                            ? opsiMenu(response.idcatatan,
                                                ambilDataSurveyDiFuture)
                                            : null,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                            );
                      // return kIsWeb
                      //     ? SingleChildScrollView(
                      //         child: PaginatedDataTable(
                      //           source: _data,
                      //           columns: [
                      //             DataColumn(
                      //               label: const Text('No'),
                      //             ),
                      //             DataColumn(
                      //               label: const Text('Nama Nasabah'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Kelompok'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Siklus'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Berkas Scan Pencairan'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Foto Survey'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Catatan Kunjungan'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Tanggal Kunjungan'),
                      //             ),
                      //             DataColumn(
                      //               label: Text('Tanggal Pencairan'),
                      //             ),
                      //             util.getString(PreferencesUtil.role) == "FAO"
                      //                 ? DataColumn(label: Container())
                      //                 : DataColumn(
                      //                     label: Text('Aksi'),
                      //                   ),
                      //           ],
                      //           rowsPerPage: 5,
                      //           showCheckboxColumn: false,
                      //         ),
                      //       )
                      //     : RefreshIndicator(
                      //         key: _refreshIndicatorKey,
                      //         onRefresh: refreshData,
                      //         child: ListView.separated(
                      //           itemCount: hasilCari.length,
                      //           addAutomaticKeepAlives: true,
                      //           itemBuilder: (context, index) {
                      //             AmbilDataSurveyResponse response =
                      //                 snapshot.data[index];
                      //             return Column(
                      //               children: [
                      //                 ListTile(
                      //                   contentPadding: EdgeInsets.all(8),
                      //                   title: Text(response.kelompok),
                      //                   subtitle: Text(response.namanasabah),
                      //                   onTap: () => Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (BuildContext context) =>
                      //                           HalamanDetailCatatanSurvey(
                      //                         idCatatan: response.idcatatan,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   onLongPress: () => util.getString(
                      //                               PreferencesUtil.role) ==
                      //                           'AO'
                      //                       ? opsiMenu(response.idcatatan,
                      //                           ambilDataDiFuture)
                      //                       : null,
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //           separatorBuilder:
                      //               (BuildContext context, int index) {
                      //             return Divider();
                      //           },
                      //         ),
                      //       );
                    } else {
                      return Center(
                        child: Text('Tidak ada data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Terjadi kesalahan'),
                    );
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

class DataTableCatatanSurvey extends DataTableSource {
  final List<AmbilDataSurveyResponse> _data;
  final BuildContext context;
  final Function refreshData;
  final String role;
  final bool adaKoneksiInternet;
  DataTableCatatanSurvey({
    List<AmbilDataSurveyResponse> data,
    this.context,
    this.refreshData,
    this.role,
    this.adaKoneksiInternet,
  }) : _data = data;

  @override
  DataRow getRow(int index) {
    final AmbilDataSurveyResponse data = _data[index];
    return DataRow(
      onSelectChanged: (_) => kIsWeb
          ? Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: HalamanDetailCatatanSurvey(
                  idCatatan: data.idcatatan,
                ),
              ),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanDetailCatatanSurvey(
                  idCatatan: data.idcatatan,
                ),
              ),
            ),
      cells: [
        DataCell(Text('${index + 1}')),
        role == 'FAO'
            ? DataCell(Text(data.namapetugas ?? ''))
            : DataCell(Container()),
        role == 'FAO'
            ? DataCell(Container())
            : DataCell(Text(data.idnasabah ?? '')),
        DataCell(Text(data.namanasabah ?? '')),
        DataCell(Text(data.kelompok ?? '')),
        DataCell(Text(data.siklus ?? '')),
        DataCell(Text(data.fotoscanpencairan == '' ? 'Tidak ada' : 'Ada')),
        DataCell(Text(data.fotosurvey == '' ? 'Tidak ada' : 'Ada')),
        DataCell(Text(data.catatankunjungan ?? '')),
        DataCell(Text(Waktu(DateTime.parse(data.tanggalkunjungan ?? ''))
            .format('EEEE, d MMMM y'))),
        role == 'FAO'
            ? DataCell(Container())
            : DataCell(
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: () {
                    if (adaKoneksiInternet) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanUbahDataCatatanSurvey(
                            idCatatan: data.idcatatan,
                          ),
                        ),
                      );
                    } else {
                      var snackBar = SnackBar(
                          content: Text(
                              'Tidak ada koneksi internet, cek koneksi internet Anda.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      this.toLowerCase().contains(secondString.toLowerCase());
}
