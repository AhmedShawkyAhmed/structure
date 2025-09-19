import 'package:flutter/material.dart';
import 'package:structure/architecture/mvc/counter/model/counter_model.dart';

class CounterController extends ChangeNotifier {
  final CounterModel _model = CounterModel();

  int get count => _model.count;

  void incrementCounter() {
    _model.increment();
    notifyListeners(); // Notify listeners (View) to rebuild
  }

  void decrementCounter() {
    _model.decrement();
    notifyListeners();
  }

  void resetCounter() {
    _model.reset();
    notifyListeners();
  }
}