import 'package:json_annotation/json_annotation.dart';

part 'UbahDataSurveyRequest.g.dart';

@JsonSerializable()
class UbahDataSurveyRequest {
  @JsonKey(name: "id_catatan")
  int idcatatan;
  @JsonKey(name: "id_pengguna")
  int idpengguna;
  @JsonKey(name: "tanggal_kunjungan")
  String tanggalkunjungan;
  @JsonKey(name: "foto_scan_pencairan")
  String fotoscanpencairan;
  @JsonKey(name: "foto_survey")
  String fotosurvey;
  @JsonKey(name: "catatan_kunjungan")
  String catatankunjungan;
  @JsonKey(name: "file_foto_survey")
  String filefotosurvey;
  @JsonKey(name: "file_foto_scan_pencairan")
  String filefotoscanpencairan;

  UbahDataSurveyRequest({
    this.idcatatan,
    this.idpengguna,
    this.tanggalkunjungan,
    this.fotoscanpencairan,
    this.fotosurvey,
    this.catatankunjungan,
    this.filefotosurvey,
    this.filefotoscanpencairan,
  });

  Map<String, dynamic> toJson() => _$UbahDataSurveyRequestToJson(this);

  static UbahDataSurveyRequest fromJson(Map<String, dynamic> json) =>
      _$UbahDataSurveyRequestFromJson(json);
}
