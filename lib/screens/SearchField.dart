import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key key}) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  static TextEditingController Edt_ItemSearch = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: Edt_ItemSearch,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: Padding(
              padding: const EdgeInsets.all(10), child: Icon(Icons.search)),
        ),
      ),
    );
  }
}
