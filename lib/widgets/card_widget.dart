import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:logiccards/models/card.dart' as c;

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.type,
    required this.onTap,
    this.size = const Size(defaultWidth, defaultHeight),
    this.margin = defaultMargin,
    this.enable = true,
  });

  final c.TypesCards type;
  final VoidCallback? onTap;
  final Size size;
  final EdgeInsetsGeometry margin;
  final bool enable;

  static const double defaultWidth = 56.0;
  static const double defaultHeight = 1.5 * defaultWidth;
  static const EdgeInsetsGeometry defaultMargin = EdgeInsets.all(4.0);

  final double _borderWidth = 2.0;

  Size get effectiveSize => Size(
        size.width - _borderWidth,
        size.height - _borderWidth,
      );

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(4.0 + _borderWidth));
    return SizedBox(
      child: InkWell(
        onTap: enable ? onTap : null,
        child: Card(
          color: Colors.white,
          margin: margin,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: _borderWidth,
            ),
            borderRadius: borderRadius,
          ),
          elevation: 4.0,
          child: Opacity(
            opacity: enable ? 1.0 : .45,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: borderRadius,
                color: type.color,
              ),
              child: ClipRRect(
                child: Container(
                  constraints: BoxConstraints.tight(effectiveSize),
                  child: _buildElipse(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElipse() {
    final width = 0.75 * effectiveSize.width;
    final height = 0.75 * effectiveSize.height;
    final radius = Radius.elliptical(width / 2, height / 2);
    const angle = 75 * math.pi / 180;
    return Center(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          constraints: BoxConstraints.tightFor(
            width: width,
            height: height,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(radius),
            color: Colors.white,
          ),
          child: Transform.rotate(
            angle: -angle,
            child: Center(
              child: Image.asset(
                type.imagePath,
                height: width,
                width: width,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
