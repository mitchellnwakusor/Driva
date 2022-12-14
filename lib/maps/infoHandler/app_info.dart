import 'package:flutter/foundation.dart';
import 'package:driva/maps/models/direction.dart';

class AppInfo extends ChangeNotifier {

  Directions? userPickupLocation, userDropOffLocation;


  void upDatePickupLocationAddress( Directions userPickupAddress){
    userPickupLocation = userPickupAddress;
    notifyListeners();
  }


  void upDateDropOffLocationAddress( Directions userDropOffAddress){
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}