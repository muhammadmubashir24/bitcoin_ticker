import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> andriodDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedCurrency = value;
            getData();
            test();
          });
        }
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedindex) {
        print(selectedindex);
        setState(() {
          selectedCurrency = currenciesList[selectedindex];
          getData();
          test();
        });
      },
      children: pickerItems,
    );
  }

  // String bitcoinValue = '?';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    setState(() {});
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        coinValues = data;
        isWaiting = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
      });
    }
  }

  void test() async {
    CoinData coinData = CoinData();
    // try {
    //   String rate = await coinData.getCoinData('$selectedCurrency');
    //   print('BTC to $selectedCurrency Rate: $rate');
    // } catch (e) {
    //   print(e);
    // }
    try {
      Map<String, String> rates = await coinData.getCoinData(selectedCurrency);
      print('Exchange Rates for $selectedCurrency: $rates');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            value: isWaiting ? '?' : (coinValues['BTC'] ?? '?'),
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'BTC',
          ),
          CryptoCard(
            value: isWaiting ? '?' : (coinValues['ETH'] ?? '?'),
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'ETH',
          ),
          CryptoCard(
            value: isWaiting ? '?' : (coinValues['LTC'] ?? '?'),
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'LTC',
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : andriodDropdownItems(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.value,
    required this.cryptoCurrency,
    required this.selectedCurrency,
  });

  final String value;
  final String cryptoCurrency;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency', // Dynamically display the selected currency
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
