import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double temp;
  List <dynamic> values = [0,0,0];
  String labelDropdown = 'USD';
  @override
  void initState() {
    super.initState();
    getDataCoin();
  }

  bool isWaiting = false;
  getDataCoin() async {
    isWaiting = true;
      for( var i=0; i<cryptoList.length; i++){
      CoinData monedita = CoinData(
          'https://rest.coinapi.io/v1/exchangerate/${cryptoList[i]}/$labelDropdown?apikey=F7C9184A-4978-4527-9044-E10F917BDA9C');
      var info = await monedita.getCoinData();
      temp = info['rate'];
      setState(() {
        if (temp is double) {
          values[i]=(info['rate'].toInt());
        } else {
          values[i]=(info['rate']);
        }
      });
    }
    isWaiting = false;
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

  List <Widget>  results(){
    List <Widget> outcome=[];
    for( var j=0; j<cryptoList.length; j++){
      outcome.add(
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
                  '1 ${cryptoList[j]} = ${isWaiting ? '?' : '${values[j]} $labelDropdown'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
      );
    }
    return outcome;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: results(),
          ),
          Container(
            height: 120.0,
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
