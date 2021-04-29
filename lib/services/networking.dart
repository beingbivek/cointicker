import 'dart:convert';
import 'package:http/http.dart' as http;

const apiAddress = "https://rest.coinapi.io/v1/exchangerate";
const apiKey = "F2B04F9A-D684-4331-B766-A263B8D6329F";

class NetworkHelper {
  NetworkHelper(this.crytoCurrency, this.countryCurrency);
  final String crytoCurrency, countryCurrency;

  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(
        '$apiAddress/$crytoCurrency/$countryCurrency?apikey=$apiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
