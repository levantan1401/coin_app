import 'dart:convert';

import 'package:coin_app/pages/details_page.dart';
import 'package:coin_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectionCoin = "bitcoin";
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectDropCoin(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _selectDropCoin() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple",
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _selectionCoin,
      items: _items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectionCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(88, 60, 197, 1.0),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      iconSize: 30,
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/$_selectionCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          Map _exhangeRates = _data["market_data"]["current_price"];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext _context) {
                          return DetailsPage(rates: _exhangeRates);
                        },
                      ),
                    );
                  },
                  child: _coinImageWidget(
                    _data["image"]["large"],
                  ),
                ),
                _currenPriceWidget(_usdPrice),
                _priceChangePrecenteage24h(_change24h),
                _descriptionCardWidget(_data["description"]["en"]),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currenPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _priceChangePrecenteage24h(num _precent) {
    return Text(
      "$_precent %",
      style: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _coinImageWidget(String _imgUrl) {
    return Container(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgUrl),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceWidth! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: SingleChildScrollView(
        child: Text(
          _description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }
}
