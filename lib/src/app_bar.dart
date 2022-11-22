import 'dart:math';

import 'package:flutter/material.dart';



class CollapsableAppBar{
  final double maxHeight;
  final double minHeight;
  final Widget expanded;
  final Widget collapsed;

  const CollapsableAppBar(
      {Key? key,
        required this.expanded,
        required this.collapsed,
        this.maxHeight = 220,
        this.minHeight = 80});

}


class SizedAppBar extends StatefulWidget {
   final CollapsableAppBar appBar;

   const SizedAppBar(
       {Key? key,
        required this.appBar
       }) : super(key: key);

  @override
  State<SizedAppBar> createState() => SizedAppBarState();
}

class SizedAppBarState extends State<SizedAppBar> {
  late double _currentHeight;
  double _headerHeight = 0;

  setHeights(double height, double headerHeight) {
    setState(() {
      _currentHeight = height;
      _headerHeight = headerHeight;
    });
  }

  @override
  void initState() {
    _currentHeight = widget.appBar.maxHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxDelta = widget.appBar.maxHeight - widget.appBar.minHeight - topPadding - (_headerHeight - topPadding);
    final delta = _currentHeight - widget.appBar.minHeight - topPadding - (_headerHeight - topPadding);
    final double opacity = min(max(delta / maxDelta, 0), 1);

    return Stack(
      children: [
        Opacity(
            opacity: opacity,
            child: widget.appBar.expanded
        ),
        Opacity(
          opacity: 1 - opacity,
          child: SafeArea(
              child: SizedBox(
                height: widget.appBar.minHeight,
                  child: widget.appBar.collapsed
              )
          ),
        )
      ],
    );
  }
}
