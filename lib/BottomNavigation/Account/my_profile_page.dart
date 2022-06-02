import 'dart:io';

import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_state.dart';
import 'package:courieronedelivery/Theme/colors.dart';
import 'package:courieronedelivery/components/continue_button.dart';
import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/components/entry_field.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/UtilityFunctions/pick_and_get_imageurl.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/utils/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bottom_navigation.dart';

class MyProfilePage extends StatelessWidget {
  final DeliveryProfile _deliveryProfile;

  MyProfilePage(this._deliveryProfile);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileBloc>(
        create: (context) => UpdateProfileBloc(),
        child: MyProfileBody(this._deliveryProfile));
  }
}

class MyProfileBody extends StatefulWidget {
  final DeliveryProfile _profile;

  MyProfileBody(this._profile);

  @override
  _MyProfileBodyState createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  UpdateProfileBloc _updateProfileBloc;
  TextEditingController nameController;
  String imageUrl;
  ProgressDialog _pr;
  bool isLoaderShowing = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget._profile.user.name);
    _updateProfileBloc = BlocProvider.of<UpdateProfileBloc>(context);
    imageUrl = widget._profile.user.image_url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocListener<UpdateProfileBloc, UpdateUserMeState>(
              listener: (context, state) {
                if (state is LoadingUpdateUserMeState)
                  showLoader();
                else
                  dismissLoader();

                if (state is SuccessUpdateUserMeState) {
                  Toaster.showToastBottom(
                      AppLocalizations.of(context).getTranslationOf("updated"));
                  if (Navigator.canPop(context))
                    Navigator.pop(context);
                  else
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigationPage(),
                      ),
                    );
                  //Phoenix.rebirth(context);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  CustomAppBar(title: locale.myProfile),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(35.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            EntryField(
                              label: locale.nameText,
                              controller: nameController,
                              // initialValue: widget.name,
                              // readOnly: true,
                            ),
                            EntryField(
                              label: locale.emailText,
                              initialValue: widget._profile.user.email,
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.phoneText,
                              initialValue: widget._profile.user.mobileNumber,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              width: mediaQuery.size.width,
              top: 78,
              child: Center(
                child: Hero(
                  tag: 'profile_pic',
                  child: InkWell(
                    onTap: () async {
                      File filePicked = await Picker()
                          .pickImageFile(context, PickerSource.ASK);
                      if (filePicked != null) {
                        await showProgress();
                        String url =
                            await uploadFile('CourierOne/delivery', filePicked);
                        await dismissProgress();
                        if (url != null) {
                          setState(() => imageUrl = url);
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        height: 90,
                        width: 90,
                        fit: BoxFit.fill,
                        imageUrl: imageUrl != null ? imageUrl : "",
                        errorWidget: (context, img, d) =>
                            Image.asset('images/empty_dp.png'),
                        placeholder: (context, string) =>
                            Image.asset('images/empty_dp.png'),
                      ),
                    ),

                    //  CircleAvatar(
                    //   radius: 55,
                    //   backgroundImage: imageUrl == null || imageUrl.isEmpty
                    //       ? AssetImage('images/empty_dp.png')
                    //       : NetworkImage(imageUrl),
                    // ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomButton(
                text: AppLocalizations.of(context)
                    .getTranslationOf("update_profile"),
                radius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                ),
                onPressed: () {
                  _updateProfileBloc.add(
                      PutUpdateProfileEvent(nameController.text, imageUrl));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  showProgress() async {
    if (_pr == null) {
      _pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      _pr.style(
        message: AppLocalizations.of(context).getTranslationOf("uploading"),
      );
    }
    await _pr.show();
  }

  Future<bool> dismissProgress() {
    return _pr.hide();
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
