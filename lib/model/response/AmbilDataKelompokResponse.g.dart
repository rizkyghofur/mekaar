// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AmbilDataKelompokResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbilDataKelompokResponse _$AmbilDataKelompokResponseFromJson(
    Map<String, dynamic> json) {
  return AmbilDataKelompokResponse(
    idnasabah: json['id_nasabah_siklus'] as String,
    namanasabah: json['nama_nasabah_siklus'] as String,
    kelompok: json['nama_kelompok'] as String,
    siklus: json['siklus'] as String,
  );
}

Map<String, dynamic> _$AmbilDataKelompokResponseToJson(
        AmbilDataKelompokResponse instance) =>
    <String, dynamic>{
      'id_nasabah_siklus': instance.idnasabah,
      'nama_nasabah_siklus': instance.namanasabah,
      'nama_kelompok': instance.kelompok,
      'siklus': instance.siklus,
    };
