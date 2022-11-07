import 'package:driva/models/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import '../widgets/utilities.dart';
import '../widgets/widgets.dart';

class SignupScreenOTPVerification extends StatefulWidget {
  const SignupScreenOTPVerification({Key? key}) : super(key: key);

  @override
  State<SignupScreenOTPVerification> createState() => _SignupScreenOTPVerificationState();
}

class _SignupScreenOTPVerificationState extends State<SignupScreenOTPVerification> {
  CustomColorTheme customColorTheme = CustomColorTheme();
  CustomTextStyles customTextStyles = CustomTextStyles();
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    String mobileNo = Provider.of<SignupAndLoginProvider>(context).mobileNumber!;
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
            Text('Enter OTP',style: customTextStyles.headingDark),
            const SizedBox(height: 8),
            Text('Driva will send you a one-time password via SMS to verify your number +234 ${mobileNo.substring(0,3)} ${mobileNo.substring(3,6)} ${mobileNo.substring(6,10)}',style: customTextStyles.subheadingDark),
            const SizedBox(height: 16),
            const OTPInputWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog.loadScreen(context);
          Provider.of<SignupAndLoginProvider>(context,listen: false).smsCode = Provider.of<SignupAndLoginProvider>(context, listen: false).firstCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).secondCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).thirdCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).fourthCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).fifthCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).sixthCodeDigit!;
          firebaseAuthentication.createFirebaseUser(context, Provider.of<SignupAndLoginProvider>(context,listen: false).verificationCode!, Provider.of<SignupAndLoginProvider>(context, listen: false).smsCode!);
          },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
