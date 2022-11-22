import 'package:flutter/material.dart';

class HostedCard extends StatelessWidget {
  final Widget? child;
  final ScrollController? controller;
  final Decoration? decoration;

  const HostedCard({Key? key, this.child, this.controller, this.decoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: decoration,
      child: SingleChildScrollView(
        controller: controller,
        child: child,
      ),
    );

  }
}
