import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Authentication/BlocAuth/auth_bloc.dart';
import 'Authentication/BlocAuth/auth_event.dart';
import 'components/continue_button.dart';
import 'utils/helper.dart';

class LanguagePage extends StatefulWidget {
  final bool fromRoot;

  LanguagePage([this.fromRoot = false]);
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _defaultLanguage;

  getLanguage() async {
    String currLang = await Helper().getCurrentLanguage();
    setState(() {
      _defaultLanguage = currLang ?? AppConfig.languageDefault;
    });
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 4),
            CustomAppBar(
              showLeadingButton: !widget.fromRoot,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('\n' + locale.getTranslationOf("select_language"),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.bold, letterSpacing: 1.2))),
            SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
                child: Container(
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(35.0))),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Text(
                          '\n' +
                              locale.getTranslationOf("change_language_desc") +
                              '\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: theme.primaryColorDark)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: AppConfig.languagesSupported.length,
                        itemBuilder: (context, index) => RadioListTile(
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) =>
                              setState(() => _defaultLanguage = value),
                          groupValue: _defaultLanguage,
                          value: AppConfig.languagesSupported.keys
                              .elementAt(index),
                          title: Text(AppConfig
                              .languagesSupported[AppConfig
                                  .languagesSupported.keys
                                  .elementAt(index)]
                              .name),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              text: locale.getTranslationOf("continueText"),
              radius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
              ),
              onPressed: () {
                BlocProvider.of<LanguageCubit>(context)
                    .setCurrentLanguage(_defaultLanguage, true);
                if (widget.fromRoot) {
                  BlocProvider.of<AuthBloc>(context).add(AuthChanged());
                } else {
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
