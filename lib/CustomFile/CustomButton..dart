import 'package:flutter/material.dart';

class CusBtn extends StatefulWidget {
  @override
  _CusBtnState createState() => _CusBtnState();
}

class _CusBtnState extends State<CusBtn> {
  //final flatButtonStyle = ButtonStyle();
  double progress = 100;
  @override
  Widget build(BuildContext context) {
    var _code;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {},
              child: Text('Looks like a RaisedButton'),
            ),
            OutlinedButton(
              style: outlineButtonStyle,
              onPressed: () {},
              child: Text('Looks like an OutlineButton'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red,textStyle: TextStyle(color: Colors.white)),
              onPressed: () {},
              child: Text('FlatButton with custom overlay colors'),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused)) return Colors.red;
                  if (states.contains(MaterialState.hovered))
                    return Colors.green;
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {},
              child: Text('TextButton with custom overlay colors'),
            ),
            MaterialButton(
              onPressed: () {},
              color: Colors.pink,
              disabledColor: Colors.grey,
              child: Container(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {},
              color: Colors.yellowAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                'Hai',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            // MaterialButton(
            //   disabledColor: Colors.grey.shade300,
            //   height: 50,
            //   onPressed: _code.length < 6
            //       ? null
            //       : () {
            //           // verify();
            //         },
            //   minWidth: double.infinity,
            //   color: Colors.black,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5)),
            //   child: true
            //       ? Container(
            //           width: 20,
            //           height: 20,
            //           child: CircularProgressIndicator(
            //             backgroundColor: Colors.white,
            //             strokeWidth: 3,
            //             // color: Colors.black,
            //           ),
            //         )
            //       : true
            //           ? Icon(
            //               Icons.check_circle,
            //               color: Colors.white,
            //               size: 30,
            //             )
            //           : Text(
            //               "Verify",
            //               style: TextStyle(color: Colors.white),
            //             ),
            // ),
            buildHeader('Determinable'),
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                  ),
                  Center(child: buildProgress()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProgress() {
    if (progress == 1) {
      return Icon(
        Icons.done,
        color: Colors.green,
        size: 56,
      );
    } else {
      return Text(
        '${(progress * 100).toStringAsFixed(1)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      );
    }
  }
}

Widget buildHeader(String text) => Container(
      padding: EdgeInsets.only(bottom: 32),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
).copyWith(
  side: MaterialStateProperty.resolveWith<BorderSide>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed))
        return BorderSide(
          color: Colors.green,
          width: 1,
        );
      return null; // Defer to the widget's default.
    },
  ),
);
