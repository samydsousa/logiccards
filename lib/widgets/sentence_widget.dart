import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../models/sentence.dart';

class SentenceWidget extends StatefulWidget {
  const SentenceWidget(
    this.sentence, {
    super.key,
  });

  final Sentence sentence;

  @override
  State<SentenceWidget> createState() => _SentenceWidgetState();
}

class _SentenceWidgetState extends State<SentenceWidget> {
  final _controller = ScrollController();
  var reverseScroll = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SentenceWidget oldWidget) {
    if (_controller.hasClients) {
      if (_controller.position.maxScrollExtent > 0 != reverseScroll) {
        if (mounted) {
          reverseScroll = !reverseScroll;
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: reverseScroll,
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Math.tex(
            widget.sentence.toString(),
            textStyle: const TextStyle(fontSize: 28.0),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
