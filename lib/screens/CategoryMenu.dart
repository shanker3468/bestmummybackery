import 'package:flutter/material.dart';

class PopularMenu extends StatelessWidget {
  double width = 55.0;
  double height = 55.0;
  double customFontSize = 13;
  String defaultFontFamily = 'Roboto-Light.ttf';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.account_balance,
                      color: Color(0xFFAB436B),
                    ),
                  ),
                ),
                Text(
                  "Cake",
                  style: TextStyle(
                      color: Color(0xFF969696),
                      fontFamily: 'Roboto-Light.ttf',
                      fontSize: customFontSize),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.account_balance,
                      color: Color(0xFFC1A17C),
                    ),
                  ),
                ),
                Text(
                  "Bun",
                  style: TextStyle(
                      color: Color(0xFF969696),
                      fontFamily: defaultFontFamily,
                      fontSize: customFontSize),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.public_off_sharp,
                      color: Color(0xFF5EB699),
                    ),
                  ),
                ),
                Text(
                  "Puffs",
                  style: TextStyle(
                      color: Color(0xFF969696),
                      fontFamily: defaultFontFamily,
                      fontSize: customFontSize),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.donut_large,
                      color: Color(0xFF4D9DA7),
                    ),
                  ),
                ),
                Text(
                  "Donut",
                  style: TextStyle(
                      color: Color(0xFF969696),
                      fontFamily: defaultFontFamily,
                      fontSize: customFontSize),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
