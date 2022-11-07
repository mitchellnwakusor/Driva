import 'package:driva/models/firebase_auth.dart';
import 'package:driva/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/utilities.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomColorTheme customColorTheme = CustomColorTheme();
    CustomTextStyles customTextStyle = CustomTextStyles();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication(); 
    DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
    return Scaffold(
      backgroundColor: customColorTheme.textPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create an account',style: customTextStyle.headingDark,),
            const SizedBox(height: 24,),
            Expanded(child: SignupForm(formKey: formKey,)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              dialog.loadScreen(context);
              await firebaseAuthentication.requestOTP(context,'/signupVerification');
              //resend otp
            }
          },
          child: const Icon(Icons.arrow_forward)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}

