import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String cryptoCurrency = cryptoList.first,
      countryCurrency = currenciesList.first,
      currencyValue = '?';

  List<Widget> allCrypto() {
    // List worth = [];
    // for (String values in cryptoList) {updateValues(values, countryCurrency);
    // }
    return List.generate(
        cryptoList.length,
        (index) => ReusableCard(
            cryptoCurrency: cryptoList[index],
            currencyValue: currencyValue,
            countryCurrency: countryCurrency));
  }

  @override
  void initState() {
    super.initState();
    updateValues(cryptoCurrency, countryCurrency);
  }

  void updateValues(cryptoCurrency, countryCurrency) async {
    if (countryCurrency == 'NRP') {
      countryCurrency = 'INR';
      NetworkHelper networkHelper =
          NetworkHelper(cryptoCurrency, countryCurrency);
      var values = await networkHelper.getData();
      countryCurrency = 'NRP';
      setState(() {
        currencyValue = (values["rate"] * 1.6).toStringAsFixed(2);
      });
      return;
    }
    NetworkHelper networkHelper =
        NetworkHelper(cryptoCurrency, countryCurrency);
    var values = await networkHelper.getData();
    setState(() {
      currencyValue = values["rate"].toStringAsFixed(2);
    });
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (countryCurrency) {
        currencyValue = '?';
        updateValues(cryptoCurrency, countryCurrency);
      },
      children: List.generate(
        currenciesList.length,
        (index) => Text(currenciesList[index]),
      ),
    );
  }

  DropdownButton<String> andriodDropdownButton() {
    return DropdownButton<String>(
      value: countryCurrency,
      items: List.generate(
        currenciesList.length,
        (index) => DropdownMenuItem(
          child: Text(currenciesList[index].toString()),
          value: currenciesList[index].toString(),
        ),
      ),
      onChanged: (value) {
        currencyValue = '?';
        setState(() {
          countryCurrency = value;
          updateValues(cryptoCurrency, countryCurrency);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: allCrypto(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : andriodDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key key,
    @required this.cryptoCurrency,
    @required this.currencyValue,
    @required this.countryCurrency,
  }) : super(key: key);

  final String cryptoCurrency;
  final String currencyValue;
  final String countryCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $currencyValue $countryCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
