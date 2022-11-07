import 'package:driva/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/utilities.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CustomTextStyles customTextStyle = CustomTextStyles();
    CustomColorTheme customColorTheme = CustomColorTheme();

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
            Text('Subheading',style: customTextStyle.subheadingDark),
            const SizedBox(height: 8),
            Text('Heading',style: customTextStyle.headingDark),
            const SizedBox(height: 16),
            Expanded(flex: 2,child: Image.asset('lib/assets/splash.png',fit: BoxFit.cover,alignment: Alignment.topCenter,)),
            const SizedBox(height: 24),
            const Expanded(flex: 2,child: LoginForm()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}


