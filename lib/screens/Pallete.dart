import 'package:flutter/material.dart';

class Pallete {
  static const MaterialColor mycolor = const MaterialColor(
    //colors: [Color(0xffff3a5a), Color(0xfffe494d)]))
    0xff3A9BDC,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff3A9BDC), //10%
      100: const Color(0xff3A9BDC), //20%
      200: const Color(0xff3A9BDC), //30%
      300: const Color(0xff3A9BDC), //40%
      400: const Color(0xff3A9BDC), //50%
      500: const Color(0xff3A9BDC), //60%
      600: const Color(0xff3A9BDC), //70%
      700: const Color(0xff3A9BDC), //80%
      800: const Color(0xff3A9BDC), //90%
      900: const Color(0xff3A9BDC), //100%
    },
  );

  // you

  static const MaterialColor green = MaterialColor(
    0xffff3a5a,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );
}
