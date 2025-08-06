import 'dart:math';
import 'package:flutter/material.dart';
import 'package:onmitrix/models/investment.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({Key? key}) : super(key: key);

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  final List<Investment> _investments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
      ),
      body: Center(
        child: Text('Investment Screen'),
      ),
    );
  }
}