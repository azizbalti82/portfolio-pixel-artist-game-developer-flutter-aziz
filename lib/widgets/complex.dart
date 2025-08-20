import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider.dart';
import '../theme/theme_data.dart';
import '../tools/tools.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration charDelay;
  final Duration pauseDuration;
  final theme t;

  const TypingText({
    Key? key,
    required this.text,
    this.textStyle,
    this.charDelay = const Duration(milliseconds: 80),
    this.pauseDuration = const Duration(seconds: 2), required this.t,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}
class _TypingTextState extends State<TypingText> {
  String _visibleText = '';
  int _index = 0;
  bool _cursorVisible = true;
  Timer? _typingTimer;
  Timer? _cursorTimer;
  late theme t;
  final Provider provider = Get.find<Provider>();



  @override
  void initState() {
    super.initState();
    t = widget.t;
    _startCursorBlinking();
    _startTyping();
  }

  void _startCursorBlinking() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(widget.charDelay, (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_index];
          _index++;
        });
      } else {
        timer.cancel();
        Future.delayed(widget.pauseDuration, () {
          setState(() {
            _visibleText = '';
            _index = 0;
          });
          _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme(provider);

      return AutoSizeText(
      _visibleText + (_cursorVisible ? '|' : ' '),
        style: GoogleFonts.getFont(
            'Jersey 10',
            fontSize: isLandscape(context)?65:40, // max size
            fontWeight: FontWeight.bold,
            color: t.accentColor
        ),
        maxLines: 1,
        minFontSize: 14,
        textAlign: isLandscape(context)?TextAlign.start:TextAlign.center,
    );});
  }
}
