import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../provider.dart';
import '../theme/theme_data.dart';
import '../tools/tools.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final String? icon;
  final bool isFullRow;
  final double? iconSize;
  final theme t;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.isFullRow = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconSize, required this.t,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  final Provider provider = Get.find<Provider>();
  late theme t;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme(provider);
    Color bgColor = widget.backgroundColor ?? t.accentColor;
    Color fgColor = widget.textColor ?? t.bgColor ;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: widget.isFullRow ? double.infinity : null,
        height: 55,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: _isHovered ? t.bgColor : bgColor,
            foregroundColor: _isHovered ? bgColor : fgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _isHovered ? BorderSide(color: bgColor, width: 1) : BorderSide.none,
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                SvgPicture.asset(
                  "assets/icons/${widget.icon}.svg",
                  width: widget.iconSize ?? 22,
                  color: _isHovered ? bgColor : fgColor,
                ),
              if (widget.isLoading) const SizedBox(width: 8),
              if (widget.isLoading)
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _isHovered ? bgColor : fgColor,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  color: _isHovered ? bgColor : fgColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  });}
}


class CustomButtonOutline extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final String? icon;
  final double? size;
  final bool isFullRow;
  final double height;
  final double borderSize;
  final theme t;

  const CustomButtonOutline({
    Key? key,
    this.text = "",
    this.icon,
    this.isFullRow = true,
    this.size,
    required this.onPressed,
    required this.isLoading,
    this.backgroundColor,
    this.textColor,
    this.height = 55,
    this.borderSize = 1, required this.t,
  }) : super(key: key);

  @override
  State<CustomButtonOutline> createState() => _CustomButtonOutlineState();
}

class _CustomButtonOutlineState extends State<CustomButtonOutline> {
  bool _isHovered = false;
  late theme t;
  final Provider provider = Get.find<Provider>();

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme(provider);
      bool isDarkMode = t.brightness == Brightness.dark;
      Color borderColor = widget.backgroundColor?.withOpacity(0.7) ??
          t.accentColor.withOpacity(0.7);
      Color background = _isHovered
          ? widget.backgroundColor ?? t.accentColor
          : (widget.backgroundColor ?? t.bgColor);
      Color textColor = _isHovered ? t.bgColor : (widget.backgroundColor ??
          t.accentColor);

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: widget.isFullRow ? double.infinity : null,
          height: widget.height,
          child: FilledButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: background,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: _isHovered ? BorderSide.none : BorderSide(
                    width: widget.borderSize, color: borderColor),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  SvgPicture.asset(
                    "assets/icons/${widget.icon}.svg",
                    width: 22.0,
                    color: textColor,
                  ),
                if (widget.isLoading) const SizedBox(width: 8),
                if (widget.isLoading)
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  ),
                if(widget.text.isNotEmpty)
                  const SizedBox(width: 12),
                if(widget.text.isNotEmpty)
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.size ?? 16,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}