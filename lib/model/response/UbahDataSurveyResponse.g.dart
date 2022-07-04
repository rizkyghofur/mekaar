// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UbahDataSurveyResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UbahDataSurveyResponse _$UbahDataSurveyResponseFromJson(
    Map<String, dynamic> json) {
  return UbahDataSurveyResponse(
    success: json['status_kode'] as int,
    message: json['status_pesan'] as String,
  );
}

Map<String, dynamic> _$UbahDataSurveyResponseToJson(
        UbahDataSurveyResponse instance) =>
    <String, dynamic>{
      'status_kode': instance.success,
      'status_pesan': instance.message,
    };
