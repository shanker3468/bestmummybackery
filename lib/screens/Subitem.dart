import 'package:flutter/material.dart';

class Subitem extends StatefulWidget {
  const Subitem({Key key}) : super(key: key);

  @override
  _SubitemState createState() => _SubitemState();
}

final List<SubItemModel> _items = [
  SubItemModel(
    title: 'Sweet Buffs',
    url: 'assets/images/pulses.png',
  ),
  SubItemModel(
    title: 'Cake',
    url: 'assets/images/rice.png',
  ),
  SubItemModel(
    title: 'Donunt',
    url: 'assets/images/pulses.png',
  ),
];

class _SubitemState extends State<Subitem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (_, i) => Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
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

class SubItemModel {
  final String title;
  final String url;

  SubItemModel({this.title, this.url});
}
