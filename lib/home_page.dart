import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // <---

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? initialPosition; //= Latlng( 37.4219983, -122.084);
  Position? currentPosition;
  List<LatLng> latLngList = []; // for Polyline

  late GoogleMapController _mapController;
  int count =0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onScreenStart();
      _listenCurrentLocation();
    });
  }

  Future<void> _onScreenStart()async{ //---------------------------------------- once
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print("isEnabled = $isEnabled");
    //print(await Geolocator.getLastKnownPosition());
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
      initialPosition = await Geolocator.getCurrentPosition();
      latLngList.add(LatLng(initialPosition!.latitude, initialPosition!.longitude)); // --------------------------
      currentPosition = initialPosition;
      print("initialPosition = $initialPosition"); // @patenga: Latitude: 22.2429317, Longitude: 91.7874833 // Dhaka/Coordinates:  23.8041° N, 90.4152° E -----------
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

  void _listenCurrentLocation() { //-------------------------------------------------- stream
    Geolocator.getPositionStream(locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      //distanceFilter: 1,
      timeLimit: Duration(seconds: 10),
    )).listen((p) {
      //print(p);
      currentPosition =p;
      print("currentPosition = $currentPosition");
      latLngList.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
      setState(() {});
    });
  }

  Future<void> _doSomething() async {
    print("_mapController.getVisibleRegion() = ");
    print(await _mapController.getVisibleRegion()); // LatLngBounds(LatLng(-41.69584836329773, 55.62881715595722), LatLng(67.13937965531485, 127.95026052743196))
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('geolocator'),backgroundColor: Colors.blue,),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(initialPosition!.latitude,initialPosition!.longitude), //LatLng(23.742144667472623, 90.38969244807959), // Latitude Longitude
          zoom: 17, // the more zoom, the closer to target location, 16-17 more commonly used.
          bearing: 0, // rotate clockwise in degree, A bearing of 0.0, the default, means the camera points north.
          tilt: 0,
        ),
        mapType: MapType.normal, // .satellite .hybrid .normal .terrain
        zoomControlsEnabled: true, // + - zoom in/out buttons
        zoomGesturesEnabled: true, //on tap zoom in
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _doSomething();
        },
        markers: {
          Marker(
              markerId: const MarkerId('initial-position'),
              position: LatLng(initialPosition!.latitude, initialPosition!.longitude),
              infoWindow: const InfoWindow(title: 'my initial position'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
          Marker(
              markerId: const MarkerId('current-position'),
              position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
              infoWindow: const InfoWindow(title: 'my current position'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('PolylineId-1'),
            color: Colors.green,
            width: 3,
            points: latLngList,
          )
        },
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
// currentPosition,1  = Latitude: 22.2429317, Longitude: 91.7874833
//currentPosition,27  = Latitude: 22.234705, Longitude: 91.79336


// void _listenCurrentLocation(){ // ------------------------------------------------- stream
//   try{
//     Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.best, // .best .bestForNavigation
//           //distanceFilter: 5,
//           timeLimit: Duration(seconds: 5),
//           /*LocationSettings.timeLimit: allows for setting a timeout interval.
//       * If between fetching locations the timeout interval is exceeded a TimeoutException will be thrown.
//       * By default no time limit is configured.*/
//         )
//     ).listen((p){
//       //print(p); // p.latitude, p.longitude ?
//       currentPosition = p;
//       print("currentPosition,${count++} = $currentPosition");
//       if(currentPosition==initialPosition){
//         print("currentPosition==initialPosition ----------------------------------------");
//       }
//       //positionStream.cancel();
//     });
//   }catch(e){
//     print("error occurred: $e");
//     count =-500;
//     _listenCurrentLocation();
//   }
// }


//Future<void> _onScreenStart()async{ //------------------------------------------------- once
// LocationPermission permission = await Geolocator.checkPermission();
// print("permission = $permission"); // permission = LocationPermission.denied
// LocationPermission requestStatus = await Geolocator.requestPermission();
// if(requestStatus==LocationPermission.whileInUse || requestStatus==LocationPermission.always){
//   Position position = await Geolocator.getCurrentPosition();
//   print(position); // Latitude: 37.4219983, Longitude: -122.084 ---------------------------------
// }