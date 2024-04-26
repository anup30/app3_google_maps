import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // <---

class GeolocatorScreen extends StatefulWidget {
  const GeolocatorScreen({super.key});

  @override
  State<GeolocatorScreen> createState() => _GeolocatorScreenState();
}

class _GeolocatorScreenState extends State<GeolocatorScreen> {
  Position? position;
  @override
  void initState() {
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();
  }

  Future<void> _onScreenStart()async{
    // LocationPermission permission = await Geolocator.checkPermission();
    // print("permission = $permission"); // permission = LocationPermission.denied
    // LocationPermission requestStatus = await Geolocator.requestPermission();
    // if(requestStatus==LocationPermission.whileInUse || requestStatus==LocationPermission.always){
    //   Position position = await Geolocator.getCurrentPosition();
    //   print(position); // Latitude: 37.4219983, Longitude: -122.084
    // }
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print("isEnabled = $isEnabled");
    //print(await Geolocator.getLastKnownPosition());
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
      position = await Geolocator.getCurrentPosition();

      print(position); // Latitude: 37.4219983, Longitude: -122.084 // Dhaka/Coordinates:  23.8041° N, 90.4152° E -----------
    }else{
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if(requestStatus==LocationPermission.whileInUse || requestStatus==LocationPermission.always){
        _onScreenStart();
      }else{
        print("Permission Denied");
      }
    }
    setState(() {});
  }

  void _listenCurrentLocation(){
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
        //timeLimit: Duration(seconds: 3),
      )
    ).listen((p){
      print(p); // p.latitude, p.longitude ?
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('geolocator'),backgroundColor: Colors.blue,),
      body: Center(
        child: Text('current location ${position?.latitude} ${position?.longitude}'),
      ),
    );
  }
}

/*
  class 3, at 35:00, 54:30
 add geolocator: ^11.0.0 to pubspec dependencies
 // GPS service enabled ?
 // App permission enabled ?
 // geolocation - get location once
 // listen location - continuous

* */