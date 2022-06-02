import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyBody();
  }
}

class PrivacyPolicyBody extends StatefulWidget {
  @override
  _PrivacyPolicyBodyState createState() => _PrivacyPolicyBodyState();
}

class _PrivacyPolicyBodyState extends State<PrivacyPolicyBody> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var privacyPolicy = Helper().getSettingValue("privacy_policy");
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '\n' + locale.privacyPolicy,
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
                  height: mediaQuery.size.height * 0.77,
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
                        '\n' + locale.companyPrivacyPolicy + '\n',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: theme.primaryColorDark),
                      ),
                      Text(
                        privacyPolicy,
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
