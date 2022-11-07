import 'package:driva/models/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final CustomTextStyles customTextStyle = CustomTextStyles();
  final DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController mobileNo = TextEditingController();
  final Validators customValidator = Validators();
  final FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  @override
  void dispose(){
    mobileNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Form(
      key: formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: mobileNo,
            onChanged:(String? value){
              Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber = value;
            } ,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: customValidator.mobileNumberInputValidator,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration:  InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              label: const Text('Mobile Number',),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefix: const Text('+234'),
              prefixIcon: const Icon(Icons.phone),
              hintText: '8052145514', errorStyle: customTextStyle.errorMessageDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              fillColor: Colors.white,
              filled: true
            ),
          ),
          const SizedBox(height: 8,),
          ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[700])),onPressed: (){
            if(formKey.currentState!.validate()){
              dialog.loadScreen(context);
              firebaseAuthentication.requestOTP(context,'/loginVerification');
              //login verification
            }
          }, child: const Text('LOGIN')),
          const SizedBox(height: 16),
          RichText(text: TextSpan(text: "Don't have an account? ",style: customTextStyle.textGreyedOut,children: [TextSpan(text: 'Create an account', style: customTextStyle.textClickableDark,recognizer: TapGestureRecognizer()..onTap = (){
            Provider.of<AuthStateHandlerProvider>(context,listen: false).isLoggedInScreen = false;
          })]))
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({required this.formKey,Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final CustomTextStyles customTextStyle = CustomTextStyles();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final Validators customValidator = Validators();

  @override
  void dispose(){
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    mobileNoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: firstNameController,
              onChanged:(String? value){
                Provider.of<UserProvider>(context,listen: false).firstName = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.requiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))],
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Text('First name',),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Amos',
                  errorStyle: customTextStyle.errorMessageDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  fillColor: Colors.white,
                  filled: true,


              ),
            ),
            const SizedBox(height: 32,),
            TextFormField(
              controller: lastNameController,
              onChanged:(String? value){
                Provider.of<UserProvider>(context,listen: false).lastName = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.requiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))],
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Text('Last name',),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                  hintText: 'Okpara',
                  errorStyle: customTextStyle.errorMessageDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  fillColor: Colors.white,
                  filled: true
              ),
            ),
            const SizedBox(height: 32,),
            TextFormField(
              controller: emailAddressController,
              onChanged:(String? value){
                Provider.of<UserProvider>(context,listen: false).email = value?.toLowerCase();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.validEmailAddress,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Text('Email address',),
                  prefixIcon: const Icon(Icons.email),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: 'amosokpara@mail.com',
                  errorStyle: customTextStyle.errorMessageDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  fillColor: Colors.white,
                  filled: true
              ),
            ),
            const SizedBox(height: 32,),
            TextFormField(
              controller: mobileNoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.mobileNumberInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onChanged: (String? value){
                Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber = value;
              },
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Text('Mobile Number',),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefix: const Text('+234'),
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '8052145514',
                  errorStyle: customTextStyle.errorMessageDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  fillColor: Colors.white,
                  filled: true
              ),
            ),
            const SizedBox(height: 32,),
            RichText(text: TextSpan(text: "Already have an account? ",style: customTextStyle.textGreyedOut,children: [TextSpan(text: 'Log in', style: customTextStyle.textClickableDark,recognizer: TapGestureRecognizer()..onTap = (){
              Provider.of<AuthStateHandlerProvider>(context,listen: false).isLoggedInScreen = true;
            })]))
          ],
    ));
  }
}

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CustomTextStyles customTextStyle = CustomTextStyles();
    DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,0,16,8),
      child: RichText(text:  TextSpan(
          text: 'By proceeding, you agree to our ',
          style: customTextStyle.bottomNavbarText,
          children: [
            TextSpan(text: 'Terms & Conditions ',style: customTextStyle.bottomNavbarTextClickableDark, recognizer: TapGestureRecognizer()..onTap =  (){
              showDialog(context: context, builder: (context){return dialog.customDialog(dialog.termsAndConditionsWebView, 'Terms & Conditions', context);});
            }),
            TextSpan(text: 'and ',style: customTextStyle.bottomNavbarText),
            TextSpan(text: 'Privacy Policy ',style: customTextStyle.bottomNavbarTextClickableDark, recognizer: TapGestureRecognizer()..onTap =   (){
              showDialog(context: context, builder: (context){return dialog.customDialog(dialog.privacyPolicyWebView, 'Privacy Policy', context);});
            }),
          ]
      ),textScaleFactor: 1),
    );
  }
}


class OTPInputWidget extends StatefulWidget {
  const OTPInputWidget({Key? key}) : super(key: key);

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {

  TextEditingController firstCode = TextEditingController();
  TextEditingController secondCode = TextEditingController();
  TextEditingController thirdCode = TextEditingController();
  TextEditingController fourthCode = TextEditingController();
  TextEditingController fifthCode = TextEditingController();
  TextEditingController sixthCode = TextEditingController();

  FocusNode firstCodeFocus = FocusNode();
  FocusNode secondCodeFocus = FocusNode();
  FocusNode thirdCodeFocus = FocusNode();
  FocusNode fourthCodeFocus = FocusNode();
  FocusNode fifthCodeFocus = FocusNode();
  FocusNode sixthCodeFocus = FocusNode();

  @override
  void dispose(){
    super.dispose();
    firstCode.dispose();
    secondCode.dispose();
    thirdCode.dispose();
    fourthCode.dispose();
    fifthCode.dispose();
    sixthCode.dispose();

    firstCodeFocus.dispose();
    secondCodeFocus.dispose();
    thirdCodeFocus.dispose();
    fourthCodeFocus.dispose();
    fifthCodeFocus.dispose();
    sixthCodeFocus.dispose();

  }

  void clearOTP(TextEditingController controller){
   controller.clear();
  }

  Validators customValidator = Validators();
  CustomTextStyles customTextStyle = CustomTextStyles();
  String? errorMessage;
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();
  @override
  Widget build(BuildContext context) {

    return Form(child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(child: TextFormField(
              controller: firstCode,
              focusNode: firstCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                firstCode.clear();
                if(firstCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              textInputAction: TextInputAction.next,
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  clearOTP(secondCode);
                  secondCodeFocus.requestFocus();
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).firstCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: secondCode,
              focusNode: secondCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                secondCode.clear();
                if(secondCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  clearOTP(thirdCode);
                  thirdCodeFocus.requestFocus();
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).secondCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: thirdCode,
              focusNode: thirdCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                thirdCode.clear();
                if(thirdCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  clearOTP(fourthCode);
                  fourthCodeFocus.requestFocus();
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).thirdCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: fourthCode,
              focusNode: fourthCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                fourthCode.clear();
                if(fourthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  clearOTP(fifthCode);
                  fifthCodeFocus.requestFocus();
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).fourthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: fifthCode,
              focusNode: fifthCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                fifthCode.clear();
                if(fifthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  clearOTP(sixthCode);
                  sixthCodeFocus.requestFocus();
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).fifthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),)),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: sixthCode,
              focusNode: sixthCodeFocus,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                sixthCode.clear();
                if(sixthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).sixthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
          ],
        ),
        const SizedBox(height: 8,),
        if(errorMessage!=null)
          Text(errorMessage!,style: customTextStyle.textDark,),
        const SizedBox(height: 16,),
        RichText(text: TextSpan(text: "Didn't receive code? ",style: customTextStyle.textGreyedOut,children: [TextSpan(text: 'resend OTP.', style: customTextStyle.textClickableDark,recognizer: TapGestureRecognizer()..onTap = (){
          dialog.loadScreen(context);
          firebaseAuthentication.resendOTP(context);
        })]))

      ],
    )
    );
  }
}


class LoginOTPInputWidget extends StatefulWidget {
  const LoginOTPInputWidget({Key? key}) : super(key: key);

  @override
  State<LoginOTPInputWidget> createState() => _LoginOTPInputWidgetState();
}

class _LoginOTPInputWidgetState extends State<LoginOTPInputWidget> {
  TextEditingController firstCode = TextEditingController();
  TextEditingController secondCode = TextEditingController();
  TextEditingController thirdCode = TextEditingController();
  TextEditingController fourthCode = TextEditingController();
  TextEditingController fifthCode = TextEditingController();
  TextEditingController sixthCode = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    firstCode.dispose();
    secondCode.dispose();
    thirdCode.dispose();
    fourthCode.dispose();
    fifthCode.dispose();
    sixthCode.dispose();

  }

  Validators customValidator = Validators();
  CustomTextStyles customTextStyle = CustomTextStyles();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {

    return Form(child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(child: TextFormField(
              controller: firstCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                firstCode.clear();
                if(firstCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              textInputAction: TextInputAction.next,
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).firstCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: secondCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                secondCode.clear();
                if(secondCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).secondCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: thirdCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                thirdCode.clear();
                if(thirdCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).thirdCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: fourthCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                fourthCode.clear();
                if(fourthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).fourthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: fifthCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: customValidator.otpRequiredInputValidator,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                fifthCode.clear();
                if(fifthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).fifthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),)),
            const SizedBox(width: 8,),
            Flexible(child: TextFormField(
              controller: sixthCode,
              style: customTextStyle.headingDark,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              validator: customValidator.otpRequiredInputValidator,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
              keyboardType: TextInputType.number,
              onTap: (){
                sixthCode.clear();
                if(sixthCode.text.isEmpty){
                  setState(() {
                    errorMessage = 'This field is required';
                  });
                }
              },
              onChanged: (String? value){
                if(value!.isNotEmpty){
                  errorMessage = null;
                  setState(() {});
                }
                if(value.isEmpty){
                  errorMessage = 'This field is required';
                  setState(() {});
                }
                Provider.of<SignupAndLoginProvider>(context,listen: false).sixthCodeDigit = value;
              },
              textAlign: TextAlign.center,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  label: const Center(child: Text('-'),),
                  labelStyle: customTextStyle.textGreyedOut,
                  errorStyle: customTextStyle.errorMessageDark,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blue)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                  fillColor: Colors.white,
                  filled: false
              ),
            )),
          ],
        ),
        const SizedBox(height: 8,),
        if(errorMessage!=null)
          Text(errorMessage!,style: customTextStyle.textDark,),
        const SizedBox(height: 16,),
        RichText(text: TextSpan(
            text: "Didn't receive code? ",
            style: customTextStyle.textGreyedOut,
            children: [
              TextSpan(text: 'resend OTP.', style: customTextStyle.textClickableDark,recognizer: TapGestureRecognizer()..onTap = (){}),
            ]
        ),
        ),

      ],
    )
    );
  }
}



