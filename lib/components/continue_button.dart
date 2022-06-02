import 'package:courieronedelivery/Locale/locales.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color borderColor;
  final Color color;
  final Color disabledColor;
  final TextStyle style;
  final BorderRadius radius;
  final double padding;

  CustomButton({
    this.text,
    this.onPressed,
    this.borderColor,
    this.color,
    this.style,
    this.radius,
    this.padding,
    this.disabledColor
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: padding ?? 18),
      onPressed: onPressed,
      disabledColor: disabledColor??theme.disabledColor,
      color: color ?? theme.buttonColor,
      shape: OutlineInputBorder(
        borderRadius: radius ?? BorderRadius.zero,
        borderSide: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      child: Text(
        text ?? AppLocalizations.of(context).continueText,
        style: style ?? Theme.of(context).textTheme.button,
      ),
    );
  }
}
