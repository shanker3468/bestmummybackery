import 'package:flutter/material.dart';

class ProfileRow extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;

  ProfileRow(
      {this.title, this.content, this.icon, this.iconColor = Colors.indigo});

  @override
  _ProfileRowState createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.1, 1.0, curve: Curves.easeIn)));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rowWidth = MediaQuery.of(context).size.width * 0.8;
    return FadeTransition(
      opacity: _animation,
      child: Container(
          margin: EdgeInsets.only(bottom: 25),
          width: rowWidth,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0.0, 1.0)),
                    ],
                    shape: BoxShape.circle),
                child: IconButton(
                    icon: new Icon(
                      this.widget.icon,
                    ),
                    iconSize: 25.0,
                    color: this.widget.iconColor,
                    onPressed: () {}),
              ),
              SizedBox(
                width: 30.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.widget.title,
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.blueAccent.shade700),
                  ),
                  Text(
                    this.widget.content,
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.blueAccent),
                    textAlign: TextAlign.left,
                  )
                ],
              )
            ],
          )),
    );
  }
}
