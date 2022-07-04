import 'package:mekaar/model/response/AmbilDataSurveyResponse.dart';
import 'package:mekaar/model/response/AmbilDataKelompokResponse.dart';
import 'package:mekaar/model/response/UbahDataSurveyResponse.dart';
import 'package:mekaar/repositori/DataSurveyRepositori.dart';

class DataSurveyBloc {
  DataSurveyRepositori dataSurveyRepositori = DataSurveyRepositori();

  Future<List<AmbilDataSurveyResponse>> getData() async {
    try {
      return await dataSurveyRepositori.ambilDataSurvey();
    } catch (e) {
      return null;
    }
  }

  Future<List<AmbilDataSurveyResponse>> getDatabyAO() async {
    try {
      return await dataSurveyRepositori.ambilDataSurveyOlehAO();
    } catch (e) {
      return null;
    }
  }

  Future<List<AmbilDataSurveyResponse>> getDatabyID(String id) async {
    try {
      return await dataSurveyRepositori.ambilDataSurveyDenganID(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<AmbilDataKelompokResponse>> getDataKelompok() async {
    try {
      return await dataSurveyRepositori.ambilDataKelompok();
    } catch (e) {
      return null;
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
      return await dataSurveyRepositori.ubahDataSurvey(
          idcatatan: idcatatan,
          idpengguna: idpengguna,
          tanggalkunjungan: tanggalkunjungan,
          catatankunjungan: catatankunjungan,
          fotosurvey: fotosurvey,
          fotoscanpencairan: fotoscanpencairan,
          filefotosurvey: filefotosurvey,
          filefotoscanpencairan: filefotoscanpencairan);
    } catch (e) {
      return null;
    }
  }
}
