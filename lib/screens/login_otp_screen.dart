import 'package:driva/models/firebase_auth.dart';
import 'package:driva/providers.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class LoginScreenOTPVerification extends StatefulWidget {
  const LoginScreenOTPVerification({Key? key}) : super(key: key);

  @override
  State<LoginScreenOTPVerification> createState() => _LoginScreenOTPVerificationState();
}

class _LoginScreenOTPVerificationState extends State<LoginScreenOTPVerification> {

  final CustomColorTheme customColorTheme = CustomColorTheme();
  final CustomTextStyles customTextStyles = CustomTextStyles();
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  @override
  Widget build(BuildContext context) {
    String? mobileNo = Provider.of<SignupAndLoginProvider>(context).mobileNumber!;
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
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0,0,0,0),
          child: RichText(
            text:  TextSpan(
                text: "Can't receive OTP? ",
                style: customTextStyles.textGreyedOut,
                children: [
                  TextSpan(
                      text: 'change number.',
                      style: customTextStyles.textClickableDark,
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.pushNamed(context, '/changeNumber');
                      }
                  ),
                ]
            )
          ),
        ),
        FloatingActionButton(
        onPressed: (){
          dialog.loadScreen(context);
          Provider.of<SignupAndLoginProvider>(context,listen: false).smsCode = Provider.of<SignupAndLoginProvider>(context, listen: false).firstCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).secondCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).thirdCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).fourthCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).fifthCodeDigit! + Provider.of<SignupAndLoginProvider>(context, listen: false).sixthCodeDigit!;
          firebaseAuthentication.loginUser(context, Provider.of<SignupAndLoginProvider>(context,listen: false).verificationCode!, Provider.of<SignupAndLoginProvider>(context, listen: false).smsCode!);
          // validate and send otp code
        },
        child: const Icon(Icons.arrow_forward),
        ),
      ],
    ),
    );
  }
}
