import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/components/continue_button.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:flutter/material.dart';

class PickerTime {
  final String timeText;
  final int timeValue;

  PickerTime(this.timeText, this.timeValue);
}

class TimePickerSheet extends StatefulWidget {
  final String type; //pickup or delivery.

  TimePickerSheet(this.type);

  @override
  _TimePickerSheetState createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  List<PickerTime> pickerTimes;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    pickerTimes = [];
    AppLocalizations locale = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);
    int breaker = 15;
    String minTrans = locale.getTranslationOf("mins");
    for (int i = 1; i <= 4; i++) {
      int value = i * breaker;
      pickerTimes
          .add(PickerTime("${value.toStringAsFixed(0)} $minTrans", value));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            locale.getTranslationOf("time_picker_title_" + widget.type),
            style: theme.textTheme.headline6
                .copyWith(color: theme.primaryColorDark),
          ),
        ),
        // Spacer(),
        Flexible(
          child: ListView.builder(
            itemCount: pickerTimes.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var headline6 = theme.textTheme.headline6;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Text(pickerTimes[index].timeText + '\n',
                    textAlign: TextAlign.center,
                    style: headline6.copyWith(
                        fontSize:
                            index == selectedIndex ? 24 : headline6.fontSize,
                        color: index == selectedIndex
                            ? theme.primaryColor
                            : headline6.color)),
              );
            },
          ),
        ),
        CustomButton(
          text: AppLocalizations.of(context).done,
          radius: BorderRadius.only(topRight: Radius.circular(35.0)),
          onPressed: () {
            if (selectedIndex == -1) {
              Toaster.showToastBottom(locale
                  .getTranslationOf("err_field_time_picker_" + widget.type));
            } else {
              Navigator.pop(context, pickerTimes[selectedIndex]);
            }
          },
        ),
      ],
    );
  }
}
