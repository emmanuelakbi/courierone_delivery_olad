// import 'package:courieronedelivery/BottomNavigation/Account/AccountBloc/account_bloc.dart';
// import 'package:courieronedelivery/BottomNavigation/Account/AccountBloc/account_state.dart';
// import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_bloc.dart';
// import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_event.dart';
// import 'package:courieronedelivery/BottomNavigation/bottom_navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
//
// import 'get_current_position.dart';
//
// class SendProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AccountBloc>(
//       create: (context) => AccountBloc(),
//       child: SendProfileBody(),
//     );
//   }
// }
//
// class SendProfileBody extends StatefulWidget {
//   @override
//   _SendProfileBodyState createState() => _SendProfileBodyState();
// }
//
// class _SendProfileBodyState extends State<SendProfileBody> {
//   Position _currentPosition;
//
//   getCurrentLocation() async {
//     Position position = await determinePosition();
//     print(position);
//     setState(() {
//       _currentPosition = position;
//     });
//     print(_currentPosition);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
//       if (state is SuccessState) {
//         return MultiBlocProvider(
//           providers: [
//             BlocProvider<UpdateProfileBloc>(
//                 create: (context) => UpdateProfileBloc(state.userInformation.id)
//                   ..add(PutUpdateProfileEvent(_currentPosition.longitude,
//                       _currentPosition.latitude, true))),
//           ],
//           child: BottomNavigation(),
//         );
//       } else if (state is FailureState) {
//         return Scaffold(
//           body: Center(
//             child: Text('Network Error!'),
//           ),
//         );
//       } else {
//         return Scaffold(body: Center(child: CircularProgressIndicator()));
//       }
//     });
//   }
// }
