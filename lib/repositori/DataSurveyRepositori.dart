import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mekaar/konstan/KonstanUrl.dart';
import 'package:mekaar/model/request/UbahDataSurveyRequest.dart';
import 'package:mekaar/model/response/AmbilDataSurveyResponse.dart';
import 'package:mekaar/model/response/AmbilDataKelompokResponse.dart';
import 'package:mekaar/model/response/UbahDataSurveyResponse.dart';
import 'package:mekaar/utilitas/Injector.dart';
import 'package:mekaar/utilitas/SharedPreference.dart';

class DataSurveyRepositori {
  final Dio dio = locator<Dio>();
  PreferencesUtil util = PreferencesUtil();

  Future<List<AmbilDataSurveyResponse>> ambilDataSurvey() async {
    try {
      Response response = await dio.get(KonstanUrl.get);

      List<AmbilDataSurveyResponse> fetchedResponse =
          (jsonDecode(response.data) as List)
              .map((data) => AmbilDataSurveyResponse.fromJson(data))
              .toList();
      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<List<AmbilDataSurveyResponse>> ambilDataSurveyOlehAO() async {
    try {
      Response response = await dio
          .get(KonstanUrl.getbyAO + util.getString(PreferencesUtil.idpengguna));
      List<AmbilDataSurveyResponse> fetchedResponse =
          (jsonDecode(response.data) as List)
              .map((data) => AmbilDataSurveyResponse.fromJson(data))
              .toList();
      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<List<AmbilDataSurveyResponse>> ambilDataSurveyDenganID(
      String id) async {
    try {
      Response response = await dio.get(KonstanUrl.getbyId + id);
      List<AmbilDataSurveyResponse> fetchedResponse =
          (jsonDecode(response.data) as List)
              .map((data) => AmbilDataSurveyResponse.fromJson(data))
              .toList();
      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<List<AmbilDataKelompokResponse>> ambilDataKelompok() async {
    try {
      Response response = await dio.get(KonstanUrl.getKelompok);
      List<AmbilDataKelompokResponse> fetchedResponse =
          (jsonDecode(response.data) as List)
              .map((data) => AmbilDataKelompokResponse.fromJson(data))
              .toList();
      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<UbahDataSurveyResponse> ubahDataSurvey({
    idcatatan,
    idpengguna,
    tanggalkunjungan,
    catatankunjungan,
    fotoscanpencairan,
    fotosurvey,
    filefotoscanpencairan,
    filefotosurvey,
  }) async {
    try {
      UbahDataSurveyRequest request = UbahDataSurveyRequest();
      request.idcatatan = idcatatan;
      request.idpengguna = idpengguna;
      request.tanggalkunjungan = tanggalkunjungan;
      request.catatankunjungan = catatankunjungan;
      request.fotoscanpencairan = fotoscanpencairan;
      request.fotosurvey = fotosurvey;
      request.filefotoscanpencairan = filefotoscanpencairan;
      request.filefotosurvey = filefotosurvey;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(KonstanUrl.edit, data: request.toJson());
      var map = Map<String, dynamic>.from(jsonDecode(response.data));
      var fetchedResponse = UbahDataSurveyResponse.fromJson(map);

      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
