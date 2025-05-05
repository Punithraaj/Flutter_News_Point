import 'package:flutter/material.dart';

class CountryProvider with ChangeNotifier {
  String _countryCode = 'in';

  String get countryCode => _countryCode;

  void toggleCountry() {
    _countryCode = _countryCode == 'in' ? 'us' : 'in';
    notifyListeners();
  }

  void setCountry(String code) {
    _countryCode = code;
    notifyListeners();
  }
}
