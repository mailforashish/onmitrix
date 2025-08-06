import 'package:flutter/foundation.dart';
import 'package:onmitrix/models/investment.dart';
import 'package:onmitrix/services/api/api_service.dart';

class InvestmentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Investment> _investments = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Investment> get investments => _investments;

  Future<void> fetchInvestments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().getInvestments();
      _investments = response;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addInvestment(Investment investment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService().addInvestment(investment);
      _investments.add(investment);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateInvestment(Investment investment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService().updateInvestment(investment);
      final index = _investments.indexWhere((e) => e.id == investment.id);
      if (index != -1) {
        _investments[index] = investment;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInvestment(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService().deleteInvestment(id);
      _investments.removeWhere((e) => e.id == id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}