import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';

class TncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TncBody();
  }
}

class TncBody extends StatefulWidget {
  @override
  _TncBodyState createState() => _TncBodyState();
}

class _TncBodyState extends State<TncBody> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var terms = Helper().getSettingValue("terms");
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '\n' + locale.tnc,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
            SizedBox(height: 12,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Text(
                        '\n' + locale.tnc + '\n',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: theme.primaryColorDark),
                      ),
                      Text(
                        terms,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
