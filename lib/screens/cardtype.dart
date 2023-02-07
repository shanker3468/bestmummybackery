import 'package:bestmummybackery/screens/AppConstants.dart';
import 'package:bestmummybackery/screens/Hexcolor.dart';
import 'package:flutter/material.dart';

class CardType extends StatelessWidget {
  CardType({
    Key key,
  }) : super(key: key);

  final List<CardTypeModel> _items = [
    CardTypeModel(
      title: 'Sweet Buffs',
      color: Hexcolor('#F8A44C').withOpacity(0.15),
      url: 'assets/images/pulses.png',
    ),
    CardTypeModel(
      title: 'Cake',
      color: kPrimaryColor.withOpacity(0.15),
      url: 'assets/images/rice.png',
    ),
    CardTypeModel(
      title: 'Donunt',
      color: kPrimaryColor.withOpacity(0.15),
      url: 'assets/images/pulses.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: _items[i].color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Image.asset(_items[i].url),
              SizedBox(width: 10),
              Text(_items[i].title),
            ],
          ),
        ),
        separatorBuilder: (_, __) => SizedBox(width: 10),
      ),
    );
  }
}

class CardTypeModel {
  final String title;
  final Color color;
  final String url;

  CardTypeModel({this.title, this.color, this.url});
}
