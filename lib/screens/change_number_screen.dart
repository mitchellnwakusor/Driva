import 'package:driva/models/firebase_auth.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';

class ChangeMobileNumber extends StatefulWidget {
  const ChangeMobileNumber({Key? key}) : super(key: key);

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> with WidgetsBindingObserver {

  CustomColorTheme customColorTheme = CustomColorTheme();
  CustomTextStyles customTextStyle = CustomTextStyles();
  TextEditingController emailAddressController = TextEditingController();
  Validators customValidator = Validators();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    emailAddressController.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async{
  // print('lifecycyle');
  //   if (state == AppLifecycleState.resumed ){
  //     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  //     if( data?.link != null){
  //       firebaseAuthentication.signInwithLink(context, data!.link.toString());
  //     }
  //     FirebaseDynamicLinks.instance.onLink.listen((event){firebaseAuthentication.signInwithLink(context, event!.link.toString());}).onError((error) async{
  //       showDialog(context: context, builder: (BuildContext context) {
  //         return dialog.customDialog(dialog.errorWidget(error.message), 'Oops...an error occurred!', context);
  //       });});
  //   }
  // }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: customColorTheme.textPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Enter your email',style: customTextStyle.headingDark,),
              const SizedBox(height: 16,),
              Text('A one time login link will be sent to the email address associated to your account.',style: customTextStyle.subheadingDark,),
              const SizedBox(height: 16,),
              TextFormField(
                controller: emailAddressController,
                onChanged:(String? value){
                  Provider.of<UserProvider>(context,listen: false).email = value;
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
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(0,48)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue[700])),
                  onPressed: () async{
                    if(formKey.currentState!.validate()){
                      dialog.loadScreen(context);
                     try {
                       var user = await firebaseAuthentication.authInstance.fetchSignInMethodsForEmail(emailAddressController.text);
                       if(user.isEmpty){
                         Navigator.pop(context);
                         showDialog(context: context, builder: (BuildContext context) {
                           return dialog.customDialog(dialog.errorWidget('Account does not exist '), 'Oops...an error occurred!', context);
                         });
                       }
                       else {
                         firebaseAuthentication.sendOnetimeLogin(context);
                       }
                     } on FirebaseException catch (e) {
                       showDialog(context: context, builder: (BuildContext context) {
                         return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
                       });
                     }
                    //login
                   }
                },
                  child:  const Text('send login instructions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
