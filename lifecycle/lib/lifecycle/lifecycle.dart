

import 'package:flutter/material.dart';

class LifeCycleObserverModel with ChangeNotifier, WidgetsBindingObserver {
  late AppLifecycleState _state;

  AppLifecycleState get state => _state;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _state = state;
    print(state);
    notifyListeners();
  }

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dis() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
