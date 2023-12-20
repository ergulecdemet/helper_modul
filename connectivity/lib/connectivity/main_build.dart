import 'package:connectivity/connectivity/no_network_widget.dart';
import 'package:flutter/material.dart';

class MainBuild {
  MainBuild._();
  static Widget build(BuildContext context, Widget? child) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: child ?? const SizedBox(),
          ),
          const NoNetworkWidget()
        ],
      ),
    );
  }
}