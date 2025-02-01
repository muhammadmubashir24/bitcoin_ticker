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
const apikey = '';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL =
          '$coinapiURL/$crypto/$selectedCurrency?apikey=$apikey';

      try {
        http.Response response = await http.get(Uri.parse(requestURL));
        if (response.statusCode == 200) {
          var decodeData = jsonDecode(response.body);
          // print('Full JSON Response: ${jsonEncode(decodeData)}');
          // var prettyJson = const JsonEncoder.withIndent('  ').convert(decodeData);
          // print('Formatted JSON Response:\n$prettyJson');
          double lastRate = decodeData['rate'];
          cryptoPrices[crypto] = lastRate.toStringAsFixed(0);
        } else {
          print('Error: ${response.statusCode}');
          throw 'Problem with the get request';
        }
      } catch (e) {
        print('Fetching data for $crypto: $requestURL');
        print('Failed to fetch data: $e');
        cryptoPrices[crypto] = '?';
        throw 'Unable to fetch coin data.';
      }
    }
    return cryptoPrices;
  }
}
