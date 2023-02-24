import 'package:flutter/material.dart';
//import 'package:logiccards/types_cards.dart';
//import 'package:palette_generator/palette_generator.dart';

class CardsColors {
  static const vTrue = Color(0xff20a068);
  static const vFalse = Color(0xffa01828);
  static const conjunction = Color(0xff1858b0);
  static const inclusiveDisjunction = Color(0xfff85080);
  static const exclusiveDisjunction = Color(0xff201808);
  static const conditional = Color(0xff603080);
  static const biconditional = Color(0xffe06000);
  static const negation = Color(0xffe0a008);
/* 
  static void getColors() async {
    for (var type in TypesCards.values) {
      final color = await getColorFromImage(type.imagePath);
      print('${type.name}: ${color}');
    }
  }

  static Future<Color?> getColorFromImage(String imagePath) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(AssetImage(imagePath));
    return paletteGenerator.dominantColor?.color;
  } */
}
