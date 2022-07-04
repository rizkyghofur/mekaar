import 'package:json_annotation/json_annotation.dart';

part 'AmbilDataSurveyResponse.g.dart';

@JsonSerializable()
class AmbilDataSurveyResponse {
  @JsonKey(name: "id_catatan")
  String idcatatan;
  @JsonKey(name: "nama_petugas")
  String namapetugas;
  @JsonKey(name: "tanggal_kunjungan")
  String tanggalkunjungan;
  @JsonKey(name: "berkas_scan_pencairan")
  String fotoscanpencairan;
  @JsonKey(name: "foto_survey")
  String fotosurvey;
  String siklus;
  @JsonKey(name: "id_nasabah_siklus")
  String idnasabah;
  @JsonKey(name: "nama_nasabah_siklus")
  String namanasabah;
  @JsonKey(name: "nama_kelompok")
  String kelompok;
  @JsonKey(name: "catatan_survey")
  String catatankunjungan;

  AmbilDataSurveyResponse(
      {this.idcatatan,
      this.namapetugas,
      this.tanggalkunjungan,
      this.fotoscanpencairan,
      this.fotosurvey,
      this.siklus,
      this.idnasabah,
      this.namanasabah,
      this.kelompok,
      this.catatankunjungan});

  Map<String, dynamic> toJson() => _$AmbilDataSurveyResponseToJson(this);

  static AmbilDataSurveyResponse fromJson(Map<String, dynamic> json) =>
      _$AmbilDataSurveyResponseFromJson(json);
}
