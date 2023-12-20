import 'package:connectivity/const/size_config.dart';
import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeConfig.heightSize(context, height),
    );
  }
}

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace({
    super.key,
    required this.width,
  });
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizeConfig.widthSize(context, width),
    );
  }
}
