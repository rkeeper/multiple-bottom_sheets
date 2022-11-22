import 'dart:math';

import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'card_layer.dart';

class HostedCardChild {
  final Widget child;
  final Decoration decoration;
  final double headerHeight;

  HostedCardChild({this.headerHeight = 40, required this.child, required this.decoration});
}

final headerKey = GlobalKey<SizedAppBarState>();

class CardsHost extends StatefulWidget {
  final CollapsableAppBar appBar;
  final List<HostedCardChild> children;

  const CardsHost({
    Key? key,
    this.children = const [],
    required this.appBar,
  }) : super(key: key);

  @override
  State<CardsHost> createState() => _CardsHostState();
}

class _CardsHostState extends State<CardsHost> with SingleTickerProviderStateMixin {
  late double _maxExtent;
  late List<double> _minExtent;
  late List<double> _initialExtent;
  late List<GlobalKey<CardLayerState>> _cardKeys;
  late double _barCurrentHeight = widget.appBar.minHeight;
  late double _height;

  @override
  initState() {
    _cardKeys = List.generate(widget.children.length, (_) => GlobalKey<CardLayerState>());
    super.initState();
  }

  init(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _maxExtent = (_height - widget.appBar.minHeight) / _height;
    _minExtent = _getDefaultHeights(_height);
    _initialExtent = _getDefaultHeights(_height);
  }

  updateHeights(int i, double targetSnap) {
    _initialExtent[i] = targetSnap;
    final minBarHeight = _height * (1 - _initialExtent.reduce(max));
    if (minBarHeight < _barCurrentHeight || _barCurrentHeight < minBarHeight + widget.children[i].headerHeight) {
      _barCurrentHeight = minBarHeight + widget.children[i].headerHeight;
    }
    headerKey.currentState?.setHeights(_barCurrentHeight, widget.children[i].headerHeight);

    for (int k = i + 1; k < _initialExtent.length; k++) {
      _cardKeys[k]
          .currentState
          ?.setFractionalOffset((_initialExtent[i] - _minExtent[i]) / (_maxExtent - _minExtent[i]));
    }
  }

  List<double> _getDefaultHeights(double height) {
    return List.generate(
      widget.children.length,
      (i) => (height - widget.appBar.maxHeight - widget.children[i].headerHeight * (i - 1)) / height,
    );
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Stack(
      children: [
        SizedAppBar(
          key: headerKey,
          appBar: widget.appBar,
        ),
        ...widget.children.asMap().entries.map(
              (e) => NotificationListener<DraggableScrollableNotification>(
                onNotification: (n) {
                  updateHeights(e.key, n.extent);
                  return true;
                },
                child: GestureDetector(
                  onTap: () {
                    if (_initialExtent[e.key] < _maxExtent) {
                      animateExpand(e.key);
                    }else{
                      animateCollapse(e.key);
                    }
                  },
                  child: CardLayer(
                    key: _cardKeys[e.key],
                    maxExtent: _maxExtent,
                    minExtent: _minExtent[e.key],
                    initialHeight: _initialExtent[e.key],
                    decoration: widget.children[e.key].decoration,
                    child: widget.children[e.key].child,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Future animateExpand(int index) async {
    _cardKeys[index].currentState?.controller.animateTo(
          _maxExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCirc,
        );
  }

  Future animateCollapse(int index) async {
    _cardKeys[index].currentState?.controller.animateTo(
          _minExtent[index],
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCirc,
        );
  }
}
