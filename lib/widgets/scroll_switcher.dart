import 'package:flutter/material.dart';

class ScrollSwitcher extends StatefulWidget {
  final Widget child;

  const ScrollSwitcher({Key? key, required this.child}) : super(key: key);

  @override
  State<ScrollSwitcher> createState() => _ScrollSwitcherState();
}

class _ScrollSwitcherState extends State<ScrollSwitcher> {
  bool _horizontal = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 3 && !_horizontal) {
              setState(() {
                _horizontal = true;
              });
            } else if (details.delta.dy < -3 && _horizontal) {
              setState(() {
                _horizontal = false;
              });
            }
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              // Remover o efeito que aparece quando tenta-se ir além do limeite da rolagem.
              overscroll: false,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              crossFadeState: _horizontal
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: widget.child,
              ),
              secondChild: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
