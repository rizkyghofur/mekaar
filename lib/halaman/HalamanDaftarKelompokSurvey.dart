import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mekaar/bloc/AutentikasiBloc.dart';
import 'package:mekaar/bloc/DataSurveyBloc.dart';
import 'package:mekaar/model/response/AmbilDataKelompokResponse.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';
import 'package:mekaar/widget/Drawer.dart';

class HalamanDaftarKelompokSurvey extends StatefulWidget {
  HalamanDaftarKelompokSurvey({Key key}) : super(key: key);

  @override
  State<HalamanDaftarKelompokSurvey> createState() =>
      _HalamanDaftarKelompokSurveyState();
}

class _HalamanDaftarKelompokSurveyState
    extends State<HalamanDaftarKelompokSurvey> {
  PreferencesUtil util = PreferencesUtil();
  DataSurveyBloc dataSurveyBloc = DataSurveyBloc();
  AutentikasiBloc autentikasiBloc = AutentikasiBloc();
  TextEditingController pencarianController = TextEditingController();
  DataTableKelompokSurvey _data = DataTableKelompokSurvey();
  Future<List<AmbilDataKelompokResponse>> future;
  String pencarian = "";

  void ambilDataDiFuture() {
    setState(() {
      future = dataSurveyBloc.getDataKelompok();
    });
  }

  filterlistData(List<AmbilDataKelompokResponse> snapshot) {
    if (snapshot.isNotEmpty) {
      return snapshot
          .where((element) =>
              element.kelompok.containsIgnoreCase(pencarian) ||
              element.idnasabah.containsIgnoreCase(pencarian) ||
              element.namanasabah.containsIgnoreCase(pencarian))
          .toList();
    }
    return snapshot ?? [];
  }

  @override
  void initState() {
    super.initState();
    ambilDataDiFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kelompok Nasabah'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  ambilDataDiFuture();
                });
              },
            ),
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.lightBlue,
        ),
        child: drawer(context, util, autentikasiBloc),
      ),
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
              child: FutureBuilder<List<AmbilDataKelompokResponse>>(
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
                      _data = DataTableKelompokSurvey(
                        data: hasilCari,
                        refreshData: () => ambilDataDiFuture(),
                        role: util.getString(PreferencesUtil.role),
                        context: context,
                      );
                      return SingleChildScrollView(
                        child: PaginatedDataTable(
                          source: _data,
                          columns: [
                            DataColumn(
                              label: const Text('No'),
                            ),
                            DataColumn(
                              label: const Text('ID Nasabah'),
                            ),
                            DataColumn(
                              label: const Text('Nama Nasabah'),
                            ),
                            DataColumn(
                              label: Text('Kelompok'),
                            ),
                            DataColumn(
                              label: Text('Siklus'),
                            ),
                          ],
                          rowsPerPage: kIsWeb ? 5 : 10,
                          showCheckboxColumn: false,
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
                      //             AmbilDataKelompokResponse response =
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

class DataTableKelompokSurvey extends DataTableSource {
  final List<AmbilDataKelompokResponse> _data;
  final BuildContext context;
  final Function refreshData;
  final String role;
  final bool adaKoneksiInternet;
  DataTableKelompokSurvey({
    List<AmbilDataKelompokResponse> data,
    this.context,
    this.refreshData,
    this.role,
    this.adaKoneksiInternet,
  }) : _data = data;

  @override
  DataRow getRow(int index) {
    final AmbilDataKelompokResponse data = _data[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(data.idnasabah ?? '')),
        DataCell(Text(data.namanasabah ?? '')),
        DataCell(Text(data.kelompok ?? '')),
        DataCell(Text(data.siklus ?? '')),
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
