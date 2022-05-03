import 'package:flutter/material.dart';

class FaVerticalSpacing extends StatelessWidget {
  const FaVerticalSpacing({
    Key? key,
    this.mulitpleBy = 1,
  }) : super(key: key);

  final int mulitpleBy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 8.0 * mulitpleBy);
  }
}
