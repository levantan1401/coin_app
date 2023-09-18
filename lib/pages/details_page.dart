import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;

  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exhangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(child: ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (_context, _index){
          String _currency = _currencies[_index].toString().toUpperCase();
          String _exhangeRate = _exhangeRates[_index].toString();
          return ListTile(
            title: Text(
              "$_currency: $_exhangeRate",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          );
        }
      ),),
    );
  }
}
