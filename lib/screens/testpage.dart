import 'package:driva/models/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {
  FireStoreDatabase database = FireStoreDatabase();

  void getStuff(BuildContext context){
    database.fetchUserInfo(context,null);
  }

  @override
  void initState(){
    super.initState();
    getStuff(context);
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
