import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/Theme/colors.dart';
import 'package:courieronedelivery/components/continue_button.dart';
import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/components/entry_field.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SupportBloc/support_bloc.dart';
import 'SupportBloc/support_event.dart';
import 'SupportBloc/support_state.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupportBloc>(
        create: (context) => SupportBloc(), child: ContactUsBody());
  }
}

class ContactUsBody extends StatefulWidget {
  @override
  _ContactUsBodyState createState() => _ContactUsBodyState();
}

class _ContactUsBodyState extends State<ContactUsBody> {
  TextEditingController _messageController = TextEditingController();
  SupportBloc _supportBloc;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _supportBloc = BlocProvider.of<SupportBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);

    return BlocListener<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state is LoadingSupportState) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is SuccessSupportState) {
          Toaster.showToastBottom(AppLocalizations.of(context)
              .getTranslationOf('support_has_been_submitted'));
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  CustomAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '\n' + locale.contactUs,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.79,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                        ),
                      ),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '\n' + locale.feedbackText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: theme.primaryColorDark),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          // EntryField(
                          //   readOnly: true,
                          //   initialValue: widget.name,
                          //   label: locale.fullName,
                          //   hint: locale.enterFullName,
                          //   textCapitalization: TextCapitalization.words,
                          // ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          // EntryField(
                          //   readOnly: true,
                          //   initialValue: widget.phone,
                          //   label: locale.phoneText,
                          //   hint: locale.phoneHint,
                          //   keyboardType: TextInputType.number,
                          // ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          EntryField(
                            controller: _messageController,
                            maxLines: 5,
                            label: locale.getTranslationOf("yourmsg"),
                            hint: locale.getTranslationOf("msgHint"),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CustomButton(
                text: locale.getTranslationOf("sendMsg"),
                radius: BorderRadius.only(topLeft: Radius.circular(35.0)),
                onPressed: () {
                  try {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                  } catch (e) {
                    print(e);
                  }
                  if (_messageController.text.trim().length < 10 ||
                      _messageController.text.trim().length > 140) {
                    Toaster.showToastBottom(AppLocalizations.of(context)
                        .getTranslationOf("invalid_length_message"));
                  } else {
                    _supportBloc
                        .add(SupportEvent(_messageController.text.trim()));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMainColor),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }
}
