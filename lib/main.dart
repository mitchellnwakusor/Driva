import 'package:driva/models/firebase_auth.dart';
import 'package:driva/initial_route.dart';
import 'package:driva/providers.dart';
import 'package:driva/screens/add_payment_screen.dart';
import 'package:driva/screens/change_number_screen.dart';
import 'package:driva/screens/login_otp_screen.dart';
import 'package:driva/screens/signup_otp_screen.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'maps/infoHandler/app_info.dart';
import 'maps/passenger_destination.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Driva());
}

class Driva extends StatefulWidget {
  const Driva({Key? key}) : super(key: key);

  @override
  State<Driva> createState() => _DrivaState();
}

class _DrivaState extends State<Driva> with WidgetsBindingObserver {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.resumed ){
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      if( data?.link != null){
        firebaseAuthentication.signInwithLink(context, data!.link.toString());
      }
      FirebaseDynamicLinks.instance.onLink.listen((event){firebaseAuthentication.signInwithLink(context, event.link.toString());}).onError((error) async{
        showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(error.message), 'Oops...an error occurred!', context);
      });});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => FirebaseAuthentication()),
        ChangeNotifierProvider(create: (create) => AuthStateHandlerProvider()),
        ChangeNotifierProvider(create: (create) => SignupAndLoginProvider()),
        ChangeNotifierProvider(create: (create) => UserProvider()),
        ChangeNotifierProvider(create: (create) => AppInfo()),

      ],
      child: MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => const PassengerDestination(),
          '/': (context) => const InitialRoute(),
          '/loginVerification': (context) => const LoginScreenOTPVerification(),
          '/signupVerification': (context) => const SignupScreenOTPVerification(),
          '/addPaymentCard': (context) => const AddPaymentCardWidget(),
          '/changeNumber': (context) => const ChangeMobileNumber(),
          '/homeScreen': (context) => const PassengerDestination(),
        },
      ),
    );
  }
}

