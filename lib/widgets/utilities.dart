import 'package:driva/providers.dart';
import 'package:flutter/material.dart';
import 'package:driva/screens/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/signup_screen.dart';

class AuthPageHandler extends StatefulWidget {
  const AuthPageHandler({Key? key}) : super(key: key);
  @override
  State<AuthPageHandler> createState() => _AuthPageHandlerState();
}

class _AuthPageHandlerState extends State<AuthPageHandler> {


  @override
  Widget build(BuildContext context) {
    bool isLoggedInScreen = Provider.of<AuthStateHandlerProvider>(context).isLoggedInScreen;
    return isLoggedInScreen ? const LoginScreen() : const SignupScreen();
  }
}

class CustomColorTheme{
  final Color? textPrimaryColor = Colors.blue[900];
  final Color textDarkMode = Colors.white;
  final Color textLightMode = Colors.black;
  final Color textUnfocusedColor = Colors.grey;
}

class CustomTextStyles {
  //primary color
  TextStyle title =  TextStyle(
      color: CustomColorTheme().textPrimaryColor,
      fontSize: 12
  );
  TextStyle bottomNavbarTextClickable = TextStyle(
      color: CustomColorTheme().textPrimaryColor,
      decoration: TextDecoration.underline,
      fontSize: 12
  );
  TextStyle textPrimary =  TextStyle(
      color: CustomColorTheme().textPrimaryColor,
      fontSize: 12
  );

  //unfocused color - grey
  TextStyle textGreyedOut =  TextStyle(
      color: CustomColorTheme().textUnfocusedColor,
      fontSize: 14
  );
  TextStyle bottomNavbarText = TextStyle(
      color: CustomColorTheme().textUnfocusedColor,
      fontSize: 12
  );
  TextStyle textClickableUnfocused = TextStyle(
      color: CustomColorTheme().textUnfocusedColor,
      decoration: TextDecoration.underline,
      fontSize: 12
  );

  //Light
  TextStyle subheadingLight =  TextStyle(
      color: CustomColorTheme().textLightMode,
      fontSize: 24
  );
  TextStyle headingLight =  TextStyle(
      color: CustomColorTheme().textLightMode,
      fontSize: 32
  );
  TextStyle textClickableLight = TextStyle(
      color: CustomColorTheme().textPrimaryColor,
      decoration: TextDecoration.underline,
      fontSize: 16
  );
  TextStyle textLight =  TextStyle(
      color: CustomColorTheme().textLightMode,
      fontSize: 12
  );

  //Dark
  TextStyle headingDark =  TextStyle(
      color: CustomColorTheme().textDarkMode,
      fontSize: 32,
      fontWeight: FontWeight.bold
  );
  TextStyle subheadingDark =  TextStyle(
      color: CustomColorTheme().textDarkMode,
      fontSize: 16
  );
  TextStyle textClickableDark = TextStyle(
      color: CustomColorTheme().textDarkMode,
      decoration: TextDecoration.underline,
      fontSize: 16
  );
  TextStyle textDark =  TextStyle(
      color: CustomColorTheme().textDarkMode,
      fontSize: 12
  );
  TextStyle bottomNavbarTextClickableDark = TextStyle(
      color: CustomColorTheme().textDarkMode,
      decoration: TextDecoration.underline,
      fontSize: 12
  );
  TextStyle errorMessageDark = TextStyle(
      color: CustomColorTheme().textDarkMode,
      fontSize: 12
  );





}



class DialogsAlertsWebViews {

  AlertDialog customDialog(Widget widget, String title, BuildContext context) {
    AlertDialog customDialog = AlertDialog(title: Text(title),content: Container(child: widget),actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('close'))],);
    return customDialog;
  }

  Widget errorWidget(String? value){
    Widget errorWidget = SingleChildScrollView(
      child:Text(value!),
  );
    return errorWidget;
}

  void loadScreen(BuildContext loading){
    showDialog(context: loading, builder: (BuildContext loading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  final termsAndConditionsWebView = const WebView(initialUrl: 'https://google.com'); //t&c web address
  final privacyPolicyWebView = const WebView(initialUrl: 'https://google.com'); //privacy policy web address
}

class Validators {

  FormFieldValidator<String?> mobileNumberInputValidator = (String? value){
    if(value==null || value.isEmpty){
      return 'Mobile number is required';
    }
    if(value.length<10){
      return 'Mobile number is less than 11 digits';
    }
    if(value.length>10){
      return 'Mobile number is greater than 11 digits';
    }
    return null;
  };
  FormFieldValidator<String?> requiredInputValidator = (String? value){
    if(value==null || value.isEmpty){
      return 'This field is required';
    }
    return null;
  };
  FormFieldValidator<String?> otpRequiredInputValidator = (String? value){
    if(value==null || value.isEmpty){
     return '';
    }
    return null;
  };
  FormFieldValidator<String?> cardNumberRequired = (String? value){
    if(value==null || value.isEmpty){
      return 'This field is required.';
    }
    if (value.length < 16) {
      return 'Card number is less than 16 digits';
    }
    return null;
  };

  FormFieldValidator<String?> validEmailAddress = (String? value){
    String pattern = r'\w+@\w+\.\w+';
    if(value==null || value.isEmpty){
      return 'This field is required';
    }
    if (!RegExp(pattern).hasMatch(value)) {
        return 'Invalid E-mail address format.';
      }
    return null;
  };
  TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;
}
