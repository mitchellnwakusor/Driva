import 'package:driva/maps/passenger_destination.dart';
import 'package:driva/models/firebase_auth.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialRoute extends StatefulWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {

  @override
  Widget build(BuildContext context) {

    final firebaseAuthenticationInstance = Provider.of<FirebaseAuthentication>(context).authInstance;

    return StreamBuilder(
      stream: firebaseAuthenticationInstance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          // TODO: Write splash screen page.
          return const Text('Splash Screen');
        } //splashScreen or loading screen
        else if(snapshot.hasData){
          print(snapshot.data?.tenantId);
          return const Placeholder();
        }//homeScreen
        else{
          return const AuthPageHandler();
        }//authenticationPage Handler
    }
   );
  }
}
