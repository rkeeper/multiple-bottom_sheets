import 'package:flutter/material.dart';

import 'hosted_card.dart';

class CardLayer extends StatefulWidget {
  final Widget child;
  final Decoration decoration;
  final double minExtent;
  final double maxExtent;
  final double initialHeight;

  const CardLayer({
    Key? key,
    required this.child,
    required this.decoration,
    required this.minExtent,
    required this.maxExtent,
    required this.initialHeight,
  }) : super(key: key);

  @override
  State<CardLayer> createState() => CardLayerState();
}

class CardLayerState extends State<CardLayer> {
  bool hidden = false;
  bool animate = false;
  late double offset = 0;
  late double height;
  late DraggableScrollableController controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  setFractionalOffset(double fractionalOffset) async {
    setState(() => offset = fractionalOffset);
  }

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(0, offset),
      child: _draggable,
    );
  }

  Widget get _draggable => DraggableScrollableSheet(
    maxChildSize: widget.maxExtent,
    minChildSize: widget.minExtent,
    expand: true,
    snap: true,
    controller: controller,
    snapSizes: [widget.minExtent, widget.maxExtent],
    initialChildSize: widget.initialHeight,
    builder: (_, controller) => HostedCard(
      decoration: widget.decoration,
      controller: controller,
      child: widget.child,
    ),
  );
}