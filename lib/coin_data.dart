import 'dart:convert';
import 'package:http/http.dart' as http;

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
  'MXN',
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

const coinapiURL = 'https://rest.coinapi.io/v1/exchangerate';
const apikey = 'api key';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    String requestURL = '$coinapiURL/BTC/$selectedCurrency?apikey=$apikey';

    try {
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        double lastRate = decodeData['rate'];
        return lastRate.toStringAsFixed(0);
      } else {
        print('Error: ${response.statusCode}');
        throw 'Problem with the get request';
      }
    } catch (e) {
      print('Fetching data for $selectedCurrency: $requestURL');
      print('Failed to fetch data: $e');
      throw 'Unable to fetch coin data.';
    }
  }
}
