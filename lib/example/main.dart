import 'package:flutter/material.dart';
import 'package:multiple_bottom_sheets/multiple_bottom_sheets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.grey),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CardsHost(
        appBar: CollapsableAppBar(
          expanded: Image(
              image: const AssetImage('assets/pic.jpg'),
              fit: BoxFit.fitWidth,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          collapsed: Center(child: Text('collapsed', style: TextStyle(color: Colors.white, fontSize: 16),)),
          ),
        children: [
          HostedCardChild(
            decoration: cardDecor,
            headerHeight: 40,
            child: Column(
              children: const [
                CardHeader("First", color: Colors.red),
                CardBody(),
              ],
            ),
          ),
          HostedCardChild(
            decoration: cardDecor,
            child: Column(
              children: const [
                CardHeader("Second", color: Colors.green),
                CardBody(),
              ],
            ),
          ),
          HostedCardChild(
            decoration: cardDecor,
            child: Column(
              children: const [
                CardHeader("Third", color: Colors.blue),
                CardBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Decoration cardDecor = BoxDecoration(
  color: Colors.white,
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);

class CardHeader extends StatelessWidget {
  final String text;
  final Color color;

  const CardHeader(this.text, {Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
      child: Text(
        text,
        style: ts.copyWith(color: color),
      ),
    );
  }
}

class CardBody extends StatelessWidget {
  const CardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 20; i++) const ScrollChild(),
      ],
    );
  }
}

class ScrollChild extends StatelessWidget {
  const ScrollChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      decoration: const ShapeDecoration(
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: const SizedBox(height: 40, width: double.infinity),
    );
  }
}
