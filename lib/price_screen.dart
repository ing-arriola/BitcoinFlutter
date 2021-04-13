import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

const url =
    'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=F7C9184A-4978-4527-9044-E10F917BDA9C';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double temp;
  var value;
  String labelDropdown = 'USD';
  @override
  void initState() {
    super.initState();
    getDataCoin();
  }

  getDataCoin() async {
    CoinData monedita = CoinData(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$labelDropdown?apikey=F7C9184A-4978-4527-9044-E10F917BDA9C');
    var info = await monedita.getCoinData();

    print(info['rate']);
    temp = info['rate'];
    setState(() {
      if (temp is double) {
        value = info['rate'].toInt();
      } else {
        value = info['rate'];
      }
    });
  }

  DropdownButton<String> androidDropDown() {
    return DropdownButton<String>(
      value: labelDropdown,
      items: getDropDownItems(),
      onChanged: (value) {
        setState(() {
          labelDropdown = value;
        });
        getDataCoin();
      },
    );
  }

  List<DropdownMenuItem> getDropDownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String coin in currenciesList) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(coin),
          value: coin,
        ),
      );
    }
    return dropdownItems;
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (value) {
        print(value);
      },
      children: getPickerValues(),
    );
  }

  List<Text> getPickerValues() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }
    return items;
  }

  Widget getSelector() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropDown();
    }
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
          Padding(
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
                  '1 BTC = $value USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getSelector(),
          ),
        ],
      ),
    );
  }
}
