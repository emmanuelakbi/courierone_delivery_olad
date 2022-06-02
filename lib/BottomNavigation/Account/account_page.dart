import 'package:courieronedelivery/BottomNavigation/Account/contact_us_page.dart';
import 'package:courieronedelivery/BottomNavigation/Account/my_profile_page.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/Routes/routes.dart';
import 'package:courieronedelivery/Theme/colors.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../bloc/delivery_profile_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext pageContext) {
    var locale = AppLocalizations.of(pageContext);
    var mediaQuery = MediaQuery.of(pageContext);
    ThemeData theme = Theme.of(pageContext);
    return BlocBuilder<DeliveryProfileBloc, DeliveryProfileState>(
        buildWhen: (previousState, state) {
      return state is RefreshedProfileState;
    }, builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      locale.accountText,
                      style:
                          TextStyle(color: theme.backgroundColor, fontSize: 28),
                    ),
                    Spacer(),
                    MaterialButton(
                      minWidth: 100,
                      color: (state is RefreshedProfileState &&
                              state.deliveryProfile != null &&
                              state.deliveryProfile.isOnline == 1)
                          ? Color(0xffff3939)
                          : Theme.of(context).primaryColor,
                      onPressed: () {
                        if (state is RefreshedProfileState &&
                            state.deliveryProfile != null) {
                          BlocProvider.of<DeliveryProfileBloc>(context)
                            ..add(ProfileToggleOnlineEvent());
                        }
                      },
                      child: Text(
                        locale.getTranslationOf(
                            (state is RefreshedProfileState &&
                                    state.deliveryProfile != null)
                                ? (state.deliveryProfile.isOnline == 1)
                                    ? "go_offline"
                                    : "go_online"
                                : "loading"),
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.7,
                            letterSpacing: 0.06),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (state is RefreshedProfileState &&
                      state.deliveryProfile != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyProfilePage(state.deliveryProfile))).then(
                        (value) => BlocProvider.of<DeliveryProfileBloc>(context)
                          ..add(RefreshProfileEvent()));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 28.0, right: 28.0, bottom: 20, top: 8),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profile_pic',
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: CachedNetworkImage(
                            height: 70,
                            width: 70,
                            fit: BoxFit.fill,
                            imageUrl: (state is RefreshedProfileState &&
                                    state.deliveryProfile != null &&
                                    state.deliveryProfile.user != null &&
                                    state.deliveryProfile.user.image_url !=
                                        null &&
                                    state.deliveryProfile.user.image_url
                                        .isNotEmpty)
                                ? state.deliveryProfile.user.image_url
                                : "",
                            errorWidget: (context, img, d) =>
                                Image.asset('images/empty_dp.png'),
                            placeholder: (context, string) =>
                                Image.asset('images/empty_dp.png'),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.0),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: ((state is RefreshedProfileState &&
                                        state.deliveryProfile != null &&
                                        state.deliveryProfile.user != null &&
                                        state.deliveryProfile.user.name != null)
                                    ? state.deliveryProfile.user.name
                                    : locale.getTranslationOf("loading")) +
                                '\n',
                            style: theme.textTheme.headline5,
                          ),
                          TextSpan(text: locale.viewProfile)
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(35.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(35.0))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildListTile(
                            Icons.mail,
                            locale.contactUs,
                            locale.connectQuery,
                            theme,
                            onTap: () {
                              if (state is RefreshedProfileState &&
                                  state.deliveryProfile != null &&
                                  state.deliveryProfile.user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactUsPage(),
                                  ),
                                );
                              }
                            },
                          ),
                          buildListTile(
                            Icons.library_books,
                            locale.tnc,
                            locale.knowtnc,
                            theme,
                            onTap: () {
                              Navigator.pushNamed(context, PageRoutes.tncPage);
                            },
                          ),
                          buildListTile(
                            Icons.assignment,
                            locale.privacyPolicy,
                            locale.companyPrivacyPolicy,
                            theme,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageRoutes.privacyPolicyPage);
                            },
                          ),
                          buildListTile(Icons.call_split, locale.shareApp,
                              locale.shareFriends, theme, onTap: () {
                            Helper.openShareMediaIntent(context);
                          }),
                          buildListTile(
                            Icons.language,
                            locale.getTranslationOf("select_language"),
                            locale.getTranslationOf("change_language"),
                            theme,
                            onTap: () async {
                              String currLang =
                                  await Helper().getCurrentLanguage();
                              Navigator.pushNamed(
                                  context, PageRoutes.languagePage,
                                  arguments: currLang);
                            },
                          ),
                          buildListTile(
                            Icons.exit_to_app,
                            locale.logout,
                            locale.signoutAccount,
                            theme,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(locale.loggingout),
                                      content: Text(locale.sureText),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(locale.no),
                                          textColor: theme.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color:
                                                      theme.backgroundColor)),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                            child: Text(locale.yes),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        theme.backgroundColor)),
                                            textColor: theme.primaryColor,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              BlocProvider.of<
                                                      DeliveryProfileBloc>(
                                                  pageContext)
                                                ..add(LogoutEvent());
                                            })
                                      ],
                                    );
                                  });
                            },
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildListTile(
      IconData icon, String title, String subtitle, ThemeData theme,
      {Function onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.primaryColor,
        ),
        title: Text(
          title,
          style: theme.textTheme.headline5.copyWith(
              color: theme.primaryColorDark, height: 1.72, fontSize: 22),
        ),
        subtitle: Text(subtitle,
            style: theme.textTheme.subtitle1.copyWith(height: 1.3)),
        onTap: onTap,
      ),
    );
  }
}
