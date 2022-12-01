
import 'package:driva/widgets/utilities.dart';
import 'package:flutter/material.dart';


class InitialRoute extends StatefulWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {

  @override
  Widget build(BuildContext context) {
    return const AuthPageHandler();

  }
}
