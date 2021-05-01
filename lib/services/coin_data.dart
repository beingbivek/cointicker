import 'package:bitcoin_ticker/services/networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'NRP',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  bool nrpSelected = false;
  double price;
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      if (selectedCurrency == 'NRP') {
        nrpSelected = true;
        selectedCurrency = 'INR';
      }
      NetworkHelper networkHelper = NetworkHelper(crypto, selectedCurrency);
      var values = await networkHelper.getData();
      if (nrpSelected) {
        price = values["rate"] * 1.6;
        selectedCurrency = 'NRP';
      } else {
        price = values["rate"];
      }
      nrpSelected = false;
      cryptoPrices[crypto] = price.toStringAsFixed(0);
    }
    return cryptoPrices;
  }
}
