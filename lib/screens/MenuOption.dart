import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final String title;
  final String iconData;
  final bool selected;

  MenuOption({this.title, this.iconData, this.selected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Color(0xFFDC2069) : Colors.grey[200],
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                /*   color: selected
                      ? Color(0xFFFF5A5F).withOpacity(0.2)
                    */
                color: Colors.white,
                spreadRadius: 4,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                iconData,
                width: 24,
                height: 24,
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey[500],
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
