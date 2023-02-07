import 'package:flutter/material.dart';

class InputWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final bool obscureText;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color formFieldColor;
  final bool enable;
  final Color cursorColor;
  final Color styleColor;
  final bool boxShadow;
  final FormFieldSetter<String> onSaved;
  final TextEditingController controller;

  InputWithIcon(
      {this.controller,
        this.hintText,
        this.iconData,
        this.onChanged,
        this.onSaved,
        this.validator,
        this.formFieldColor = Colors.white,
        this.iconColor = Colors.blueGrey,
        this.iconBackgroundColor = Colors.white,
        this.enable = true,
        this.obscureText = false,
        this.cursorColor = Colors.white,
        this.styleColor = Colors.white,
        this.boxShadow = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(40.0),
                bottomRight: const Radius.circular(40.0),
                bottomLeft: const Radius.circular(40.0)),
            boxShadow: [

            ],
          ),
          child: TextFormField(
            style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: styleColor),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: this.iconData != null
                        ? iconBackgroundColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Icon(
                    this.iconData,
                    color: iconColor,
                    size: 18.0,
                  )),
              labelText: this.hintText,
              labelStyle: TextStyle(
                  color: styleColor.withOpacity(0.6),
                  height: 2.5,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: formFieldColor.withOpacity(0.3),
            ),
            enabled: enable,
            cursorColor: cursorColor,
            onChanged: this.onChanged,
            validator: this.validator,
            obscureText: this.obscureText,
            onSaved: this.onSaved,
            controller: this.controller,
          ),
        ));
  }
}
