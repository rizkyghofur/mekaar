import 'package:json_annotation/json_annotation.dart';

part 'AmbilDataKelompokResponse.g.dart';

@JsonSerializable()
class AmbilDataKelompokResponse {
  @JsonKey(name: "id_nasabah_siklus")
  String idnasabah;
  @JsonKey(name: "nama_nasabah_siklus")
  String namanasabah;
  @JsonKey(name: "nama_kelompok")
  String kelompok;
  String siklus;

  AmbilDataKelompokResponse({
    this.idnasabah,
    this.namanasabah,
    this.kelompok,
    this.siklus,
  });

  Map<String, dynamic> toJson() => _$AmbilDataKelompokResponseToJson(this);

  static AmbilDataKelompokResponse fromJson(Map<String, dynamic> json) =>
      _$AmbilDataKelompokResponseFromJson(json);
}
