import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mekaar/konstan/KonstanUrl.dart';
import 'package:mekaar/model/request/LoginRequest.dart';
import 'package:mekaar/model/response/LoginResponse.dart';
import 'package:mekaar/utilitas/Injector.dart';

class AutentikasiRepositori {
  final Dio dio = locator<Dio>();

  Future<LoginResponse> login(String namaPengguna, String kataSandi) async {
    try {
      LoginRequest request = new LoginRequest();
      request.namapengguna = namaPengguna;
      request.katasandi = kataSandi;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(KonstanUrl.login, data: request.toJson());

      var map = Map<String, dynamic>.from(
          jsonDecode(response.data) as Map<String, dynamic>);
      var fetchedResponse = LoginResponse.fromJson(map);
      return fetchedResponse;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
