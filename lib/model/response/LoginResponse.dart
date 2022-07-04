import 'package:json_annotation/json_annotation.dart';

part 'LoginResponse.g.dart';

@JsonSerializable()
class LoginResponse {
  int success;
  String message;
  @JsonKey(name: "id_pengguna")
  String idpengguna;
  @JsonKey(name: "nama_petugas")
  String namapetugas;
  String role;

  LoginResponse(
      {this.success,
      this.message,
      this.idpengguna,
      this.namapetugas,
      this.role});

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  static LoginResponse fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
