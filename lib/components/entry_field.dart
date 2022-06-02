import 'package:flutter/material.dart';

class EntryField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String image;
  final String initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  final String hint;
  final IconData suffixIcon;
  final Function onTap;
  final TextCapitalization textCapitalization;
  final Function onSuffixPressed;

  EntryField({
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.suffixIcon,
    this.maxLines,
    this.onTap,
    this.textCapitalization,
    this.onSuffixPressed,
  });

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.label ?? '',
            style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColorDark, fontSize: 22),
          ),
          TextFormField(
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.sentences,
            cursorColor: Theme.of(context).primaryColor,
            autofocus: false,
            onTap: widget.onTap ?? null,
            controller: widget.controller,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            minLines: 1,
            initialValue: widget.initialValue,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines ?? 1,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  widget.suffixIcon,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: widget.onSuffixPressed ?? null,
              ),
              hintText: widget.hint,
              hintStyle:
                  Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18),
              counter: Offstage(),
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
