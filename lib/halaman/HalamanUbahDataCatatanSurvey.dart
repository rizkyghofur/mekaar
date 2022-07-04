import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekaar/bloc/DataSurveyBloc.dart';
import 'package:mekaar/halaman/HalamanDaftarCatatanSurvey.dart';
import 'package:mekaar/konstan/KonstanUrl.dart';
import 'package:mekaar/model/response/AmbilDataSurveyResponse.dart';

enum Pilihan { Galeri, Kamera }

class HalamanUbahDataCatatanSurvey extends StatefulWidget {
  final String idCatatan;
  HalamanUbahDataCatatanSurvey({Key key, this.idCatatan}) : super(key: key);

  @override
  State<HalamanUbahDataCatatanSurvey> createState() =>
      _HalamanUbahDataCatatanSurveyState();
}

class _HalamanUbahDataCatatanSurveyState
    extends State<HalamanUbahDataCatatanSurvey>
    with AutomaticKeepAliveClientMixin {
  DataSurveyBloc dataSurveyBloc = DataSurveyBloc();
  Map<String, String> dataNasabahTerpilih = Map();
  String namagambar, namaberkaspencairan;
  String filenamagambar, filenamaberkaspencairan;
  String idNasabah, namaNasabah, kelompok, tanggal;
  File fotosurvey;
  List<AmbilDataSurveyResponse> data;
  TextEditingController idNasabahController = TextEditingController();
  TextEditingController namaNasabahController = TextEditingController();
  TextEditingController kelompokNasabahController = TextEditingController();
  TextEditingController tanggalKunjunganController = TextEditingController();
  TextEditingController catatanKunjunganController = TextEditingController();

  Future opsiMenu() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Pilih Foto Survey'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Galeri'),
              onPressed: () {
                Navigator.pop(context, Pilihan.Galeri);
              },
            ),
            SizedBox(
              height: 10,
            ),
            SimpleDialogOption(
              child: Text('Kamera'),
              onPressed: () {
                Navigator.pop(context, Pilihan.Kamera);
              },
            ),
          ],
        );
      },
    )) {
      case Pilihan.Galeri:
        ambilGambarDariGaleri();
        break;
      case Pilihan.Kamera:
        ambilGambarDariKamera();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    widget.idCatatan == null
        ? dataSurveyBloc.getDatabyAO().then((response) {
            setState(() {
              data = response;
            });
          }).onError((error, stackTrace) {
            setState(() {
              data = [];
            });
          })
        : dataSurveyBloc.getDatabyID(widget.idCatatan).then((response) {
            setState(() {
              data = response;
              idNasabahController.text = response.first.idnasabah;
              namaNasabahController.text = response.first.namanasabah;
              kelompokNasabahController.text = response.first.kelompok;
              tanggalKunjunganController.text =
                  Waktu(DateTime.parse(response.first.tanggalkunjungan ?? ''))
                      .format('EEEE, d MMMM y');
              catatanKunjunganController.text = response.first.catatankunjungan;
            });
          }).onError((error, stackTrace) {
            setState(() {
              data = [];
            });
          });
  }

  _sedangMengunggah(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Sedang mengunggah...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Data Catatan Survey'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                _sedangMengunggah(context);
                final tanggalsekarang = new DateTime.now();
                String formatTanggalSekarang =
                    DateFormat('yyyy-MM-dd').format(tanggalsekarang);

                await dataSurveyBloc
                    .ubahDataSurvey(
                        idcatatan: int.parse(data.first.idcatatan),
                        idpengguna: int.parse(data.first.idcatatan),
                        tanggalkunjungan: formatTanggalSekarang,
                        catatankunjungan: catatanKunjunganController.text,
                        fotoscanpencairan: namaberkaspencairan,
                        fotosurvey: namagambar,
                        filefotoscanpencairan: filenamaberkaspencairan,
                        filefotosurvey: filenamagambar)
                    .then((response) {
                  Navigator.of(context).pop();
                  if (response.success == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(response.message),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(response.message),
                    ));
                    setState(() {
                      namagambar = null;
                      namaberkaspencairan = null;
                      filenamaberkaspencairan = null;
                      filenamagambar = null;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HalamanDaftarCatatanSurvey()));
                  }
                });
              },
            ),
          )
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data == []
              ? Center(
                  child: Text('Tidak ada data ditampilkan'),
                )
              : Container(
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DropdownSearch<AmbilDataSurveyResponse>(
                          mode: Mode.MENU,
                          enabled: widget.idCatatan == null ? true : false,
                          selectedItem:
                              widget.idCatatan == null ? null : data.first,
                          items: data,
                          itemAsString: (response) {
                            return response.namanasabah;
                          },
                          showSearchBox: true,
                          label: widget.idCatatan == null ? "Data Nasabah" : "",
                          hint: "Pilih nama nasabah",
                          onChanged: (response) {
                            idNasabahController.text = response.idnasabah;
                            namaNasabahController.text = response.namanasabah;
                            kelompokNasabahController.text = response.kelompok;
                            tanggalKunjunganController.text = Waktu(
                                    DateTime.parse(
                                        response.tanggalkunjungan ?? ''))
                                .format('EEEE, d MMMM y');
                            catatanKunjunganController.text =
                                response.catatankunjungan;
                          },
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Data Nasabah',
                            filled: true,
                            fillColor: widget.idCatatan == null
                                ? Colors.white
                                : Colors.black12,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 20, right: 10, top: 5, bottom: 5),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: idNasabahController,
                          decoration: InputDecoration(
                            labelText: 'ID Nasabah',
                            filled: true,
                            fillColor: Colors.black12,
                            enabled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "ID Nasabah",
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: namaNasabahController,
                          decoration: InputDecoration(
                            labelText: 'Nama Nasabah',
                            filled: true,
                            fillColor: Colors.black12,
                            enabled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "Nama Nasabah",
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: kelompokNasabahController,
                          decoration: InputDecoration(
                            labelText: 'Kelompok Nasabah',
                            filled: true,
                            fillColor: Colors.black12,
                            enabled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "Kelompok Nasabah",
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: tanggalKunjunganController,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Kunjungan',
                            filled: true,
                            fillColor: Colors.black12,
                            enabled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "Tanggal Kunjungan",
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: catatanKunjunganController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Catatan Kunjungan',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "Catatan Kunjungan",
                            contentPadding: EdgeInsets.all(20),
                          ),
                          onSaved: (catatan) =>
                              catatanKunjunganController.text = catatan,
                        ),
                        Container(
                          height: 85,
                          width: 530,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            color: Colors.green,
                            child: Text(
                              "Pilih Foto Survey",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {
                              opsiMenu();
                            },
                          ),
                        ),
                        fotosurvey == null
                            ? data.first.fotosurvey == null ||
                                    data.first.fotosurvey == ""
                                ? Image.asset(
                                    'assets/images/placeholder.png',
                                    width: 350,
                                    height: 350,
                                  )
                                : Image.network(
                                    KonstanUrl.endpointImage +
                                        data.first.fotosurvey,
                                    width: 450,
                                    height: 350,
                                  )
                            : Image.file(
                                fotosurvey,
                                width: 450,
                                height: 350,
                              ),
                        Container(
                          height: 85,
                          width: 530,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            color: Colors.green,
                            child: Text(
                              "Pilih Berkas Pencairan",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {
                              ambilFileBerkasPencairan();
                            },
                          ),
                        ),
                        Visibility(
                          visible: namaberkaspencairan == null &&
                                      data.first.fotoscanpencairan == null ||
                                  data.first.fotoscanpencairan == ""
                              ? false
                              : true,
                          child: Text(
                            data.first.fotoscanpencairan == null ||
                                    data.first.fotoscanpencairan == ""
                                ? 'Berkas pencairan terpilih:\n $namaberkaspencairan'
                                : 'Berkas pencairan yang diunggah sebelumnya:\n ${data.first.fotoscanpencairan}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
    );
  }

  Future ambilGambarDariGaleri() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        fotosurvey = File(pickedFile.path);
        filenamagambar = base64Encode(pickedFile.readAsBytesSync());
        _cropImage();
      } else {
        print('Tidak ada gambar terpilih.');
      }
    });
  }

  Future ambilGambarDariKamera() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        fotosurvey = File(pickedFile.path);
        filenamagambar = base64Encode(pickedFile.readAsBytesSync());
        _cropImage();
      } else {
        print('Tidak ada gambar terpilih.');
      }
    });
  }

  Future ambilFileBerkasPencairan() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null) {
      setState(() {
        namaberkaspencairan = result.files.single.name;
        filenamaberkaspencairan = base64Encode(result.files.single.bytes);
      });
    } else {
      print('Tidak ada gambar terpilih.');
    }
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper().cropImage(
        sourcePath: fotosurvey.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Potong Gambar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Potong Gambar',
        ));
    if (croppedFile != null) {
      setState(() {
        fotosurvey = croppedFile;
        namagambar = fotosurvey.path.split('/').last;
        filenamagambar = base64Encode(croppedFile.readAsBytesSync());
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
