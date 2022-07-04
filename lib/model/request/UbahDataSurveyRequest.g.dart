// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UbahDataSurveyRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UbahDataSurveyRequest _$UbahDataSurveyRequestFromJson(
    Map<String, dynamic> json) {
  return UbahDataSurveyRequest(
    idcatatan: json['id_catatan'] as int,
    idpengguna: json['id_pengguna'] as int,
    tanggalkunjungan: json['tanggal_kunjungan'] as String,
    fotoscanpencairan: json['foto_scan_pencairan'] as String,
    fotosurvey: json['foto_survey'] as String,
    catatankunjungan: json['catatan_kunjungan'] as String,
    filefotosurvey: json['file_foto_survey'] as String,
    filefotoscanpencairan: json['file_foto_scan_pencairan'] as String,
  );
}

Map<String, dynamic> _$UbahDataSurveyRequestToJson(
        UbahDataSurveyRequest instance) =>
    <String, dynamic>{
      'id_catatan': instance.idcatatan,
      'id_pengguna': instance.idpengguna,
      'tanggal_kunjungan': instance.tanggalkunjungan,
      'foto_scan_pencairan': instance.fotoscanpencairan,
      'foto_survey': instance.fotosurvey,
      'catatan_kunjungan': instance.catatankunjungan,
      'file_foto_survey': instance.filefotosurvey,
      'file_foto_scan_pencairan': instance.filefotoscanpencairan,
    };
