import 'package:driva/models/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import '../widgets/utilities.dart';

class AddPaymentCardWidget extends StatefulWidget {
  const AddPaymentCardWidget({Key? key}) : super(key: key);

  @override
  State<AddPaymentCardWidget> createState() => _AddPaymentCardWidgetState();
}

class _AddPaymentCardWidgetState extends State<AddPaymentCardWidget> {
  CustomColorTheme customColorTheme = CustomColorTheme();
  CustomTextStyles customTextStyle = CustomTextStyles();
  FireStoreDatabase fireStoreDatabase = FireStoreDatabase();
  DialogsAlertsWebViews dialog = DialogsAlertsWebViews();

  String cardIcon = 'lib/assets/card.png';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController expDate = TextEditingController();
  TextEditingController cvv = TextEditingController();

  String date = '';
  //01/02
  late String cardDate;

  @override
  void dispose(){

    super.dispose();

    cardNumber.dispose();
    cardName.dispose();
    expDate.dispose();
    cvv.dispose();
  }

  Validators validator = Validators();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColorTheme.textPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [TextButton(onPressed: (){
          Navigator.pop(context);
          fireStoreDatabase.skippedPaymentInfo(context);
        }, child: Text('skip',style: customTextStyle.textGreyedOut,))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  // key: formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 240,
                              child: TextFormField(
                                controller: cardNumber,
                                readOnly: true,
                                onChanged: (String value){
                                  setState((){
                                    cardIcon = 'lib/assets/card.png';
                                  });
                                  if(value.length>1 && value[0] == '5' && value.length <=16){
                                    setState((){
                                      cardIcon = 'lib/assets/mc.png';
                                    });
                                  }
                                  else if(value.length>1 && value[0] == '4' && value.length <=16){
                                    setState((){
                                      cardIcon = 'lib/assets/visa.png';
                                    });
                                  }
                                  else if(value.length>1 && value[0] == '5' && value.length >16){
                                    setState((){
                                      cardIcon = 'lib/assets/verve.png';
                                    });
                                  }
                                },
                                // validator: validator.cardNumberRequired,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 24.0,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  label: Text('Card number'),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(19),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
                              child: Image.asset(cardIcon),
                            ),
                          )
                        ],
                      ),
                      // const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 120.0,
                              child: TextFormField(
                                onChanged: (String value){
                                  if(value.length==2 && !value.contains('/')){
                                    date = expDate.text;
                                    TextSelection selection = expDate.selection;
                                    String replacement = '/';
                                    String newDate = date + replacement;
                                    // date.replaceRange(selection.start, selection.end, replacement);
                                    final length = replacement.length;
                                    expDate.value = TextEditingValue(
                                        text: newDate,
                                        selection: TextSelection.collapsed(offset: selection.baseOffset + length)
                                    );
                                    // expDate.selection = selection.copyWith(
                                    //   baseOffset: selection.start + length,
                                    //   extentOffset: selection.start + length,
                                    // );
                                    if(value=='/'){
                                      value='';
                                    }
                                  }

                                },
                                controller: expDate,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                // validator: validator.requiredInputValidator,
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration: const InputDecoration(
                                  label: Text('MONTH/YEAR'),
                                  contentPadding: EdgeInsets.all(8.0),
                                  hintText: 'XX/XX',
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 /]')),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 60.0,
                              child: TextFormField(
                                controller: cvv,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                // validator: validator.requiredInputValidator,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration:
                                const InputDecoration(
                                  label: Text('CVV'),
                                  contentPadding: EdgeInsets.all(8.0),
                                  hintText: 'XXX',
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 16.0,),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: cardName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: validator.requiredInputValidator,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        readOnly: true,
                        decoration: const InputDecoration(
                          label: Text('NAME ON CARD'),
                          contentPadding: EdgeInsets.all(8.0),
                          hintText: 'CARD OWNER',
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
                          // FilteringTextInputFormatter.allow(RegExp(r'[ ]'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                color: Colors.white12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                elevation: 0,
                borderOnForeground: true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Text('Add a payment card',style:customTextStyle.headingDark ,),
                              const SizedBox(height: 16.0,),
                              TextFormField(
                                controller: cardNumber,
                                onChanged: (String value){
                                  Provider.of<UserProvider>(context,listen: false).cardNumber = value;
                                  setState((){
                                    cardIcon = 'lib/assets/card.png';
                                  });
                                  if(value.length>1 && value[0] == '5' && value.length <=16){
                                    setState((){
                                      cardIcon = 'lib/assets/mc.png';
                                    });
                                  }
                                  else if(value.length>1 && value[0] == '4' && value.length <=16){
                                    setState((){
                                      cardIcon = 'lib/assets/visa.png';
                                    });
                                  }
                                  else if(value.length>1 && value[0] == '5' && value.length >16){
                                    setState((){
                                      cardIcon = 'lib/assets/verve.png';
                                    });
                                  }
                                },
                                validator: validator.cardNumberRequired,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                style: customTextStyle.subheadingDark,
                                decoration:  InputDecoration(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  label: const Text('Card number'),
                                  labelStyle: customTextStyle.subheadingDark,
                                  hintStyle: customTextStyle.subheadingDark,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  hintText: 'XXXX XXXX XXXX XXXX',

                                  suffix: const Text('Card number'),
                                  errorStyle: customTextStyle.errorMessageDark,
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                                  fillColor: Colors.white,
                                  filled: false,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(19),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                onChanged: (String value){
                                  Provider.of<UserProvider>(context,listen: false).cardDate = value;
                                  if(value.length==2 && !value.contains('/')){
                                    date = expDate.text;
                                    TextSelection selection = expDate.selection;
                                    String replacement = '/';
                                    String newDate = date + replacement;
                                    // date.replaceRange(selection.start, selection.end, replacement);
                                    final length = replacement.length;
                                    expDate.value = TextEditingValue(
                                        text: newDate,
                                        selection: TextSelection.collapsed(offset: selection.baseOffset + length)
                                    );
                                    // expDate.selection = selection.copyWith(
                                    //   baseOffset: selection.start + length,
                                    //   extentOffset: selection.start + length,
                                    // );
                                    if(value=='/'){
                                      value='';
                                    }
                                  }

                                },
                                controller: expDate,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: validator.requiredInputValidator,
                                keyboardType: TextInputType.datetime,
                                style: customTextStyle.subheadingDark,
                                decoration: InputDecoration(
                                  label: const Text('Expiration date'),
                                  labelStyle: customTextStyle.subheadingDark,
                                  hintStyle: customTextStyle.subheadingDark,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: const EdgeInsets.all(8.0),
                                  hintText: '01/23',
                                  suffix: const Text('Expiration date'),
                                  errorStyle: customTextStyle.errorMessageDark,
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                                  fillColor: Colors.white,
                                  filled: false,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 /]')),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: cvv,
                                onChanged: (String value){
                                  Provider.of<UserProvider>(context,listen: false).cardCVV = value;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: validator.requiredInputValidator,
                                keyboardType: TextInputType.number,
                                style: customTextStyle.subheadingDark,
                                decoration:
                                InputDecoration(
                                  label: const Text('CVV'),
                                  labelStyle: customTextStyle.subheadingDark,
                                  hintStyle: customTextStyle.subheadingDark,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: const EdgeInsets.all(8.0),
                                  hintText: '123',
                                  suffix: const Text('CVV'),
                                  errorStyle: customTextStyle.errorMessageDark,
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                                  fillColor: Colors.white,
                                  filled: false,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                              ),
                              const SizedBox(height: 8.0,),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                controller: cardName,
                                onChanged: (String value){
                                  Provider.of<UserProvider>(context,listen: false).cardName = value;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: validator.requiredInputValidator,
                                style: customTextStyle.subheadingDark,
                                decoration:  InputDecoration(
                                  labelStyle: customTextStyle.subheadingDark,
                                  hintStyle: customTextStyle.subheadingDark,
                                  label: const Text('Cardholder name'),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: const EdgeInsets.all(8.0),
                                  hintText: 'Amos Okpara',
                                  suffix: const Text('Name on card'),
                                  errorStyle: customTextStyle.errorMessageDark,
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: Colors.blueAccent)),
                                  fillColor: Colors.white,
                                  filled: false,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
                                  // FilteringTextInputFormatter.allow(RegExp(r'[ ]'))
                                ],
                              ),

                            ],
                          ),
                        ),
                        Align(alignment: Alignment.bottomRight,child: FloatingActionButton(onPressed: () async {
                          if(formKey.currentState!.validate()){
                            dialog.loadScreen(context);
                            await fireStoreDatabase.updateDatabaseUserPaymentData(context);
                            // await fireStoreDatabase.updateFireStoreUserData(context); //cloudStore
                          }
                              },child: const Icon(Icons.done),))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //  const SizedBox(height: 16,),
            // Align(alignment: Alignment.centerRight,child: FloatingActionButton(onPressed: (){},child: const Icon(Icons.done),))

          ],
        ),
      ),

    );
  }
}
