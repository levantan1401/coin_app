import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/app_config.dart';


class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get();
    _base_url = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      // https://api.coingecko.com/api/v3/coins/bitcoin
      // _base_url = https://api.coingecko.com/api/v3/ 
      // _path = /coins/bitcoin
      String _url = "$_base_url$_path";
      Response _response = await dio.get(_url);
      return _response;

    } catch (e) {
      print("Looix: HTTP SERVICE in http_service file");
      print(e);
    }

  }
}