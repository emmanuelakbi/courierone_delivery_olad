//
// import 'package:courieronedelivery/BottomNavigation/Account/VendorBloc/vendor_bloc.dart';
// import 'package:courieronedelivery/BottomNavigation/Account/VendorBloc/vendor_state.dart';
// import 'package:courieronedelivery/BottomNavigation/Account/my_profile_page.dart';
// import 'package:courieronedelivery/BottomNavigation/bottom_navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class FirstPage extends StatefulWidget {
//   @override
//   _FirstPageState createState() => _FirstPageState();
// }
//
// class _FirstPageState extends State<FirstPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VendorBloc, VendorState>(
//           builder: (context, state){
//             if(state is SuccessState){
//               return BottomNavigation();
//             } else{
//               return MyProfileBody();
//             }
//           },
//     );
//   }
// }
