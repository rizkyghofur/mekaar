import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:mekaar/konstan/KonstanUrl.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';
import 'package:webviewx/webviewx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mekaar/bloc/DataSurveyBloc.dart';
import 'package:mekaar/halaman/HalamanUbahDataCatatanSurvey.dart';
import 'package:mekaar/model/response/AmbilDataSurveyResponse.dart';

class HalamanDetailCatatanSurvey extends StatefulWidget {
  final String idCatatan;
  HalamanDetailCatatanSurvey({Key key, this.idCatatan}) : super(key: key);

  @override
  State<HalamanDetailCatatanSurvey> createState() =>
      _HalamanDetailCatatanSurveyState();
}

class _HalamanDetailCatatanSurveyState
    extends State<HalamanDetailCatatanSurvey> {
  DataSurveyBloc dataSurveyBloc = DataSurveyBloc();
  PreferencesUtil util = PreferencesUtil();
  WebViewXController webviewController;

  Future<void> refreshData() async {
    await dataSurveyBloc.getDatabyID(widget.idCatatan);
  }

  void lihatDialogPDF(String fotoscanpencairan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dokumen Pencairan"),
          content: Container(
            width: 500,
            height: 750,
            child: PDF(
              swipeHorizontal: true,
            ).cachedFromUrl(
              KonstanUrl.endpointPdf + Uri.encodeFull(fotoscanpencairan),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Catatan Survey'),
        centerTitle: kIsWeb ? true : false,
        actions: [
          Row(
            children: [
              Visibility(
                visible:
                    util.getString(PreferencesUtil.role) == 'AO' ? true : false,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanUbahDataCatatanSurvey(
                          idCatatan: widget.idCatatan,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 5),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    dataSurveyBloc.getDatabyID(widget.idCatatan);
                  });
                },
              ),
              SizedBox(width: 5)
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<AmbilDataSurveyResponse>>(
        future: dataSurveyBloc.getDatabyID(widget.idCatatan),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              AmbilDataSurveyResponse response = snapshot.data[0];
              return SingleChildScrollView(
                child: Container(
                  height: kIsWeb
                      ? MediaQuery.of(context).size.height + 720
                      : MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Nasabah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        response.namanasabah,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      Text(
                        'Kelompok',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        response.kelompok,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Visibility(
                        visible: util.getString(PreferencesUtil.role) == 'FAO'
                            ? true
                            : false,
                        child: SizedBox(height: 7.5),
                      ),
                      Visibility(
                        visible: util.getString(PreferencesUtil.role) == 'FAO'
                            ? true
                            : false,
                        child: Text(
                          'Nama Petugas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: util.getString(PreferencesUtil.role) == 'FAO'
                            ? true
                            : false,
                        child: Text(
                          response.namapetugas,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.5),
                      Text(
                        'Tanggal Kunjungan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        response.tanggalkunjungan,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      Text(
                        'Catatan Kunjungan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        response.catatankunjungan,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      Text(
                        'Foto Kunjungan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      response.fotosurvey == ""
                          ? Center(
                              child: Text('Tidak ada foto'),
                            )
                          : Center(
                              child: Image.network(
                                KonstanUrl.endpointImage + response.fotosurvey,
                                width: kIsWeb ? 750 : 450,
                                height: kIsWeb ? 650 : 350,
                              ),
                            ),
                      SizedBox(height: 7.5),
                      Text(
                        'Berkas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      response.fotoscanpencairan == ""
                          ? Center(child: Text('Tidak ada berkas'))
                          : kIsWeb
                              ? Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: WebViewX(
                                      initialContent:
                                          '<iframe src="${KonstanUrl.endpointPdfIframe}${response.fotoscanpencairan}&embedded=true" frameborder="0" height="720px" width="100%"></iframe>',
                                      initialSourceType: SourceType.HTML,
                                      onWebViewCreated: (controller) =>
                                          webviewController = controller,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () => lihatDialogPDF(
                                      response.fotoscanpencairan),
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                          'Klik di sini untuk melihat dokumen.'),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Tidak ada data ditampilkan'),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
