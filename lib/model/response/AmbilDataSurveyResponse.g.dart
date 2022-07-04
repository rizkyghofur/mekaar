// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AmbilDataSurveyResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbilDataSurveyResponse _$AmbilDataSurveyResponseFromJson(
    Map<String, dynamic> json) {
  return AmbilDataSurveyResponse(
    idcatatan: json['id_catatan'] as String,
    namapetugas: json['nama_petugas'] as String,
    tanggalkunjungan: json['tanggal_kunjungan'] as String,
    fotoscanpencairan: json['berkas_scan_pencairan'] as String,
    fotosurvey: json['foto_survey'] as String,
    siklus: json['siklus'] as String,
    idnasabah: json['id_nasabah_siklus'] as String,
    namanasabah: json['nama_nasabah_siklus'] as String,
    kelompok: json['nama_kelompok'] as String,
    catatankunjungan: json['catatan_survey'] as String,
  );
}

Map<String, dynamic> _$AmbilDataSurveyResponseToJson(
        AmbilDataSurveyResponse instance) =>
    <String, dynamic>{
      'id_catatan': instance.idcatatan,
      'nama_petugas': instance.namapetugas,
      'tanggal_kunjungan': instance.tanggalkunjungan,
      'berkas_scan_pencairan': instance.fotoscanpencairan,
      'foto_survey': instance.fotosurvey,
      'siklus': instance.siklus,
      'id_nasabah_siklus': instance.idnasabah,
      'nama_nasabah_siklus': instance.namanasabah,
      'nama_kelompok': instance.kelompok,
      'catatan_survey': instance.catatankunjungan,
    };
