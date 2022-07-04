import 'package:json_annotation/json_annotation.dart';

part 'UbahDataSurveyResponse.g.dart';

@JsonSerializable()
class UbahDataSurveyResponse {
  @JsonKey(name: "status_kode")
  int success;
  @JsonKey(name: "status_pesan")
  String message;

  UbahDataSurveyResponse({
    this.success,
    this.message,
  });

  Map<String, dynamic> toJson() => _$UbahDataSurveyResponseToJson(this);

  static UbahDataSurveyResponse fromJson(Map<String, dynamic> json) =>
      _$UbahDataSurveyResponseFromJson(json);
}
