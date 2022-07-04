import 'package:json_annotation/json_annotation.dart';

part 'LoginRequest.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "nama_pengguna")
  String namapengguna;
  @JsonKey(name: "kata_sandi")
  String katasandi;

  LoginRequest({this.namapengguna, this.katasandi});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  static LoginRequest fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
