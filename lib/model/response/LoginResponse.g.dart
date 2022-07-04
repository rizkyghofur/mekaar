// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    success: json['success'] as int,
    message: json['message'] as String,
    idpengguna: json['id_pengguna'] as String,
    namapetugas: json['nama_petugas'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'id_pengguna': instance.idpengguna,
      'nama_petugas': instance.namapetugas,
      'role': instance.role,
    };
