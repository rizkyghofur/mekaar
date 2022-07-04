class KonstanUrl {
  static var endpoint = "http://mekaar.rizkyghofur.my.id/api/";
  static var endpointPdf = "http://mekaar.rizkyghofur.my.id/pdf/";
  static var endpointImage = "http://mekaar.rizkyghofur.my.id/images/";
  static var endpointPdfIframe =
      "https://docs.google.com/viewerng/viewer?url=$endpointPdf";
  static var endpointAPK = "http://mekaar.rizkyghofur.my.id/apk/mekaar.apk";
  static var endpointWeb = "http://mekaar.rizkyghofur.my.id/";

  static var login = endpoint + "login.php";
  static var get = endpoint + "get.php";
  static var getbyId = endpoint + "getbyId.php?id_catatan=";
  static var getbyAO = endpoint + "getbyAO.php?id_pengguna=";
  static var getKelompok = endpoint + "getkelompok.php";
  static var edit = endpoint + "edit.php";
}
