import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // <---

class GeolocatorScreen extends StatefulWidget {
  const GeolocatorScreen({super.key});

  @override
  State<GeolocatorScreen> createState() => _GeolocatorScreenState();
}

class _GeolocatorScreenState extends State<GeolocatorScreen> {
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
      Timer.periodic(const Duration(seconds: 10), (_) {
        _setCurrentPosition();
      });
    });
  }

  Future<void> _onScreenStart()async{
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print("isEnabled = $isEnabled");
    //print(await Geolocator.getLastKnownPosition());
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
      initialPosition = await Geolocator.getCurrentPosition();
      latLngList.add(LatLng(initialPosition!.latitude, initialPosition!.longitude));
      currentPosition = initialPosition;
      print("initialPosition = $initialPosition");
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


  Future<void> _setCurrentPosition()async{
    currentPosition = await Geolocator.getCurrentPosition();
    latLngList.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
    print("currentPosition,${++count}  = $currentPosition");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker',
          style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
      body: initialPosition==null?
      const Center(child: CircularProgressIndicator(),):
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(initialPosition!.latitude,initialPosition!.longitude),
          zoom: 17,
          bearing: 0,
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
        },
        markers: {
          Marker(
            markerId: const MarkerId('initial-position'),
            position: LatLng(initialPosition!.latitude, initialPosition!.longitude),
            infoWindow: const InfoWindow(title: 'my initial position'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: (){
              _showAlertDialog('Initial Location Info', initialPosition!);
            }
          ),
          Marker(
            markerId: const MarkerId('current-position'),
            position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            infoWindow: const InfoWindow(title: 'my current position'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              onTap: (){
                _showAlertDialog('Current Location Info', currentPosition!);
              }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentPosition!.latitude, currentPosition!.longitude),
              zoom: 17,
            ),
          ));
        },
        backgroundColor: Colors.blue.withOpacity(0.5),
        tooltip: "animate to current location",
        child: const Icon(Icons.animation),
      ),
    );
  }
  void _showAlertDialog(String text, Position position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Latitude: ${position.latitude}'),
                Text('Longitude: ${position.longitude}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {Navigator.pop(context);},
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
