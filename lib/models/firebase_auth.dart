import 'package:driva/models/user_info.dart';
import 'package:driva/widgets/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers.dart';

class FirebaseAuthentication with ChangeNotifier {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();

  Future<void> requestOTP(BuildContext context,String routeName) async{
    try {
      await authInstance.verifyPhoneNumber(
          phoneNumber: '+234${Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber}',
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential){},
          verificationFailed: (FirebaseAuthException error){
            Navigator.pop(context); //pop loading screen
            showDialog(context: context, builder: (BuildContext context) {
              return dialog.customDialog(dialog.errorWidget(error.message), 'Oops...Unable to verify number!', context);
            });
          },
          codeSent: (String? code, int? resendToken){
            Navigator.pop(context); //pop loading screen
            Provider.of<SignupAndLoginProvider>(context,listen: false).verificationCode = code;
            Navigator.pushNamed(context, routeName);
          },
          codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout){}
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }
  }
  Future<void> resendOTP(BuildContext context) async{
    try {
      await authInstance.verifyPhoneNumber(
          phoneNumber: '+234${Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber!}',
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential){},
          verificationFailed: (FirebaseAuthException error){
            Navigator.pop(context);
            showDialog(context: context, builder: (BuildContext context) {
              return dialog.customDialog(dialog.errorWidget(error.message), 'Oops...Unable to proceed!', context);
            });
          },
          codeSent: (String? code, int? resendToken){
            Navigator.pop(context);
            Provider.of<SignupAndLoginProvider>(context,listen: false).verificationCode = code;
          },
          codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout){}
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }
  }
  Future<void> sendOnetimeLogin(BuildContext context) async{
    try {
      await authInstance.sendSignInLinkToEmail(email: Provider.of<UserProvider>(context,listen: false).email!, actionCodeSettings: ActionCodeSettings(handleCodeInApp: true,url: 'https://driva.page.link/forgotnumber'));
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget('Login instructions have been sent to your email'), 'Request Succesful!!', context);
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Unable to send request!', context);
      });
    }

  }
  Future<void> signInwithLink(BuildContext context,String link) async {
    if(authInstance.isSignInWithEmailLink(link)){
      authInstance.signInWithEmailLink(email: Provider.of<UserProvider>(context,listen: false).email!, emailLink: link);
    }
  }
  Future<void> signInWithOTP(BuildContext context,{required String verificationID, required String smsCode}) async{
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: smsCode);
     await authInstance.signInWithCredential(credential).then((value) => Navigator.pop(context));
      if(authInstance.currentUser != null) {
        Provider.of<UserProvider>(context).appUser = authInstance.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }

  }
  Future<void> createFirebaseUser(BuildContext context,String verificationID, String smsCode) async {

    FireStoreDatabase database = FireStoreDatabase();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: smsCode);
    try {
      await authInstance.signInWithCredential(credential);

      Navigator.pop(context);
      if(authInstance.currentUser!=null){
        Provider.of<UserProvider>(context,listen: false).appUser =  authInstance.currentUser!;
        try {
          Provider.of<UserProvider>(context, listen: false).appUser!.updateEmail(Provider.of<UserProvider>(context, listen: false).email!);
          Provider.of<UserProvider>(context,listen: false).appUser!.reload();
            try{
              print('updated display');
              Provider.of<UserProvider>(context,listen: false).appUser!.updateDisplayName(Provider.of<UserProvider>(context,listen: false).email);
              Provider.of<UserProvider>(context,listen: false).appUser!.reload();
              await database.createDatabaseUser(context);
              Navigator.pushReplacementNamed(context, '/addPaymentCard');
            }
            on FirebaseAuthException catch (e) {
              if(Provider.of<UserProvider>(context,listen: false).appUser!= null) {
                Provider.of<UserProvider>(context,listen: false).appUser!.delete();
              }
              showDialog(context: context, builder: (BuildContext context) {
                return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
              });
            }
        }
         on FirebaseAuthException catch (e){
          Provider.of<UserProvider>(context,listen: false).appUser!.delete();
          Navigator.pop(context);
          showDialog(context: context, builder: (BuildContext context) {
            return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
          });
        }

      }
    }
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if(Provider.of<UserProvider>(context,listen: false).appUser!= null) {
        Provider.of<UserProvider>(context,listen: false).appUser!.delete();
      }
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }
  }
  Future<void> loginUser(BuildContext context,String verificationID, String smsCode) async {
    FireStoreDatabase database = FireStoreDatabase();
    //requestOTP
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: smsCode);
    try {
      await authInstance.signInWithCredential(credential);
      Navigator.pop(context);
      Provider.of<UserProvider>(context,listen: false).appUser = authInstance.currentUser!;
      //Todo: fetch user info after sign in
      await database.fetchUserInfo(context,null);
      if(Provider.of<UserProvider>(context,listen: false).appUser!.email == null )
     {
       Provider.of<UserProvider>(context,listen: false).appUser!.delete();
       showDialog(context: context, builder: (BuildContext context) {
         return dialog.customDialog(dialog.errorWidget('Please create an account first'), 'Oops...an error occurred!', context);
       });
     }
      //TODO: check user type and handle condition in else if
      else {
        Provider.of<UserProvider>(context, listen: false).appUser!.reload();
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if(Provider.of<UserProvider>(context,listen: false).appUser!= null) {
        Provider.of<UserProvider>(context,listen: false).appUser!.delete();
      }
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }
  }
}

class FireStoreDatabase with ChangeNotifier{
   FirebaseFirestore fireStore = FirebaseFirestore.instance;
   //Realtime DB
   FirebaseDatabase database = FirebaseDatabase.instance;

   //get user info
   bool checkInfoFetched(UserInformation userInformation){
     if(userInformation.personalInfo != null){
       print('Info returned true');
       return true;

    }
     else {
       print('false');
      return false;
     }
   }
   Future<void>fetchUserInfo(BuildContext context, String? routeName) async{
     User? user = Provider.of<UserProvider>(context,listen: false).appUser;
     UserInformation userInformation;
     print(user?.uid);
     Map? userInfoMap;
    try {
      database.ref('/pUser/${user!.uid}').onValue.listen((event) {
       // database.ref('/pUser/fP0CE5J4ZOTjBsQwcu0aQAuu1iW2').onValue.listen((event) {
        userInfoMap = Map<String,dynamic>.from(event.snapshot.value as Map);
        print(userInfoMap);
        Map? personalInfoMap = userInfoMap!['Personal Info'];
        Map? paymentInfoMap = userInfoMap!['Payment Info'];

        // create userInfo object from map
        PersonalInfo personalInfo = PersonalInfo(emailAddress: personalInfoMap!['email address'],firstName: personalInfoMap!['first name'],lastName: personalInfoMap!['last name'],mobileNumber: personalInfoMap!['mobile number']);
        PaymentInfo paymentInfo = PaymentInfo(cardCvv: paymentInfoMap!['card cvv'],cardEnabled: paymentInfoMap!['card enabled'],cardExpDate: paymentInfoMap!['card expDate'],cardholderName: paymentInfoMap!['cardholder name'],cardNumber: paymentInfoMap!['card number'],);

         userInformation = UserInformation(personalInfo: personalInfo,paymentInfo: paymentInfo);
        Provider.of<UserInfoProvider>(context,listen: false).updateUserInfoObject(userInformation);

        print(Provider.of<UserInfoProvider>(context,listen: false).userInformation?.personalInfo?.firstName);

        if(routeName!=null){
          Navigator.pushReplacementNamed(context, routeName);
        }
       });
    } on FirebaseException catch (e) {
      showDialog(context: context, builder: (BuildContext context) {
        return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
      });
    }

   }

   Future<void> createDatabaseUser(BuildContext context) async {
     User? user = Provider.of<UserProvider>(context,listen: false).appUser;
     String? firstName = Provider.of<UserProvider>(context,listen: false).firstName;
     String? lastName = Provider.of<UserProvider>(context,listen: false).lastName;
     String? email = Provider.of<UserProvider>(context,listen: false).email;
     String? mobileNumber = Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber;
     try{
       await database.ref('/pUser/${user!.uid}').set(
         {
           'Personal Info': {
               'first name': firstName!.trim().toLowerCase(),
               'last name': lastName!.trim().toLowerCase(),
               'email address': email!.trim().toLowerCase(),
               'mobile number': mobileNumber!.trim().toLowerCase(),
                'user type': 'passenger'
           }
         }
       );
       print('user created');
     }
     on FirebaseException catch(e){
       user!.delete();
       showDialog(context: context, builder: (BuildContext context) {
         return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
       });
     }
   }
   Future<void> updateDatabaseUserPaymentData(BuildContext context) async {
     User? user = Provider.of<UserProvider>(context,listen: false).appUser;
     String? cardHolderName = Provider.of<UserProvider>(context,listen: false).cardName;
     String? cardNumber = Provider.of<UserProvider>(context,listen: false).cardNumber;
     String? expDate = Provider.of<UserProvider>(context,listen: false).cardDate;
     String? cardCVV = Provider.of<UserProvider>(context,listen: false).cardCVV;
     try{
       await database.ref('/pUser/${user?.uid}').update({
         'Payment Info': {
           'cardholder name': cardHolderName!.trim(),
           'card number': cardNumber!.trim(),
           'card expDate': expDate!.trim(),
           'card cvv': cardCVV!.trim(),
           'card enabled': true,
         }
       });
       Navigator.pop(context);

       await fetchUserInfo(context, '/homeScreen');

       // Navigator.pushReplacementNamed(context, '/homeScreen');
       print('i am a bitch i skipped await');
       // Navigator.pop(context);
       // Navigator.pop(context);
     }
     on FirebaseException catch(e){
       showDialog(context: context, builder: (BuildContext context) {
         return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
       });
     }

   }

   DialogsAlertsWebViews dialog = DialogsAlertsWebViews();

   //FireStore DB
   Future<void> createFireStoreUser(BuildContext context) async {
     User? user = Provider.of<UserProvider>(context,listen: false).appUser;
     String? firstName = Provider.of<UserProvider>(context,listen: false).firstName;
     String? lastName = Provider.of<UserProvider>(context,listen: false).lastName;
     String? email = Provider.of<UserProvider>(context,listen: false).email;
     String? mobileNumber = Provider.of<SignupAndLoginProvider>(context,listen: false).mobileNumber;
     try{
       await fireStore.collection('users').doc(user!.uid).set({
         'first name': firstName!.trim(),
         'last name': lastName!.trim(),
         'email address': email!.trim(),
         'mobile number': mobileNumber!.trim(),
         'card enabled': false,
       });
       print('user created');
     }
     on FirebaseException catch(e){
       user!.delete();
       showDialog(context: context, builder: (BuildContext context) {
         return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
       });
     }
   }
   Future<void> updateFireStoreUserData(BuildContext context) async {
     User? user = Provider.of<UserProvider>(context,listen: false).appUser;
     String? cardHolderName = Provider.of<UserProvider>(context,listen: false).cardName;
     String? cardNumber = Provider.of<UserProvider>(context,listen: false).cardNumber;
     String? expDate = Provider.of<UserProvider>(context,listen: false).cardDate;
     String? cardCVV = Provider.of<UserProvider>(context,listen: false).cardCVV;
     try{
       await fireStore.collection('users').doc(user!.uid).set({
         'cardholder name': cardHolderName!.trim(),
         'card number': cardNumber!.trim(),
         'card expDate': expDate!.trim(),
         'card cvv': cardCVV!.trim(),
         'card enabled': true,
       },SetOptions(merge: true));
       Navigator.pop(context);
       Navigator.pop(context);
       // Navigator.pop(context);
     }
     on FirebaseException catch(e){
       showDialog(context: context, builder: (BuildContext context) {
         return dialog.customDialog(dialog.errorWidget(e.message), 'Oops...an error occurred!', context);
       });
     }

   }

   Future<void> getDisplayName(User? user) async {
     String? displayName;
     database.ref('/dUser/${user?.uid}/Personal Info/first name').onValue.listen((event) {
        displayName = event.snapshot.value.toString();
     }).onDone(() {
       print(displayName);
     });
   }
}