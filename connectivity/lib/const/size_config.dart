import 'package:flutter/material.dart';

SizeConfig sizeConfig = SizeConfig();

class SizeConfig {
  static final SizeConfig _singleObject = SizeConfig._internal();
  factory SizeConfig() {
    return _singleObject;
  }
  double designHeight = 800;
  double designWidth = 360;
  SizeConfig._internal();
  double findHeight(double value) {
    //800 is android big phone screen height
    return (value * 100) / designHeight;
  }

  double _findWidth(double value) {
    //360 is android big phone screen width
    return (value * 100) / designWidth;
  }

  double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  double heightSize(BuildContext context, double value) {
    value /= 100;
    // print(MediaQuery.of(context).size.height);
    return MediaQuery.of(context).size.height * findHeight(value);
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    // print(MediaQuery.of(context).size.width);
    return MediaQuery.of(context).size.width * _findWidth(value);
  }

  double sp(BuildContext context, double value) {
    return value * (MediaQuery.of(context).size.width / 4.3) / 100;
  }

  double scrWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double scrHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}