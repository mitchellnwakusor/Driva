import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthStateHandlerProvider with ChangeNotifier{
  bool _isLoggedInScreen = true;

  set isLoggedInScreen(bool value){
    _isLoggedInScreen = value;
    notifyListeners();
  }

  bool get isLoggedInScreen => _isLoggedInScreen;

}

class SignupAndLoginProvider with ChangeNotifier{

  String? _otpErrorMessage;

  String? _mobileNumber;

  String? _firstCodeDigit;
  String? _secondCodeDigit;
  String? _thirdCodeDigit;
  String? _fourthCodeDigit;
  String? _fifthCodeDigit;
  String? _sixthCodeDigit;

  String? _verificationCode;
  String? _smsCode;

  set otpErrorMessage(String? value){
    _otpErrorMessage = value;
    notifyListeners();
  }
  set mobileNumber(String? value){
    _mobileNumber = value;
    notifyListeners();
  }
  set firstCodeDigit(String? value){
    _firstCodeDigit = value;
    notifyListeners();
  }
  set secondCodeDigit(String? value){
    _secondCodeDigit = value;
    notifyListeners();
  }
  set thirdCodeDigit(String? value){
    _thirdCodeDigit = value;
    notifyListeners();
  }
  set fourthCodeDigit(String? value){
    _fourthCodeDigit = value;
    notifyListeners();
  }
  set fifthCodeDigit(String? value) {
    _fifthCodeDigit = value;
    notifyListeners();
  }
  set sixthCodeDigit(String? value){
    _sixthCodeDigit = value;
    notifyListeners();
  }
  set verificationCode(String? value){
    _verificationCode = value;
    notifyListeners();
  }
  set smsCode(String? value){
    _smsCode = value;
    notifyListeners();
  }

  String? get otpErrorMessage => _otpErrorMessage;
  String? get mobileNumber => _mobileNumber;
  String? get firstCodeDigit => _firstCodeDigit;
  String? get secondCodeDigit => _secondCodeDigit;
  String? get thirdCodeDigit => _thirdCodeDigit;
  String? get fourthCodeDigit => _fourthCodeDigit;
  String? get fifthCodeDigit => _fifthCodeDigit;
  String? get sixthCodeDigit => _sixthCodeDigit;
  String? get verificationCode => _verificationCode;
  String? get smsCode => _smsCode;

}

class UserProvider with ChangeNotifier{
  User? _appUser;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _cardNumber;
  String? _cardDate;
  String? _cardCVV;
  String? _cardName;


  set appUser(User? user){
    _appUser = user;
    notifyListeners();
  }
  set firstName(String? fName){
    _firstName = fName;
    notifyListeners();
  }
  set lastName(String? lName){
    _lastName = lName;
    notifyListeners();
  }
  set email(String? email){
    _email = email;
    notifyListeners();
  }
 set cardNumber(String? cNumber){
    _cardNumber = cNumber;
    notifyListeners();
  }
 set cardDate(String? cDate){
    _cardDate = cDate;
    notifyListeners();
  }
 set cardCVV(String? cvv){
    _cardCVV = cvv;
    notifyListeners();
  }
 set cardName(String? cName){
    _cardName = cName;
    notifyListeners();
  }

  User? get appUser => _appUser;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get cardName => _cardName;
  String? get cardNumber => _cardNumber;
  String? get cardDate => _cardDate;
  String? get cardCVV => _cardCVV;
}
