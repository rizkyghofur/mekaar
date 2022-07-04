import 'package:mekaar/model/response/LoginResponse.dart';
import 'package:mekaar/repositori/AutentikasiRepositori.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mekaar/utilitas/SharedPreference.dart';

class AutentikasiBloc {
  PreferencesUtil util = PreferencesUtil();
  AutentikasiRepositori authRepository = AutentikasiRepositori();

  Future<LoginResponse> getLogin(String namapengguna, String katasandi) async {
    try {
      return authRepository.login(namapengguna, katasandi).then((response) {
        if (kIsWeb) {
          if (response.success == 1 && response.role == "FAO") {
            util.putString(PreferencesUtil.idpengguna, response.idpengguna);
            util.putString(PreferencesUtil.nama, response.namapetugas);
            util.putString(PreferencesUtil.role, response.role);
          }
        } else {
          if (response.success == 1 && response.role == "AO") {
            util.putString(PreferencesUtil.idpengguna, response.idpengguna);
            util.putString(PreferencesUtil.nama, response.namapetugas);
            util.putString(PreferencesUtil.role, response.role);
          }
        }
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout() async {
    return await util.clearAll();
  }
}
