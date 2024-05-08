import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  Position? initialPosition;
  Position? currentPosition;
  List<LatLng> latLngList = [];
  int count =0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onScreenStart();
      _listenCurrentLocation();
    });
  }

  Future<void> _onScreenStart()async{
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print("isEnabled = $isEnabled");
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

  Stream<LatLng> _listenCurrentLocation()async*{ // ------------------------------------------------- stream
    try{
      Geolocator.getPositionStream (
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 10),
          )
      ).listen((p){
        currentPosition = p;
        latLngList.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
        setState(() {});
        print("currentPosition,${count++} = $currentPosition");

      });
    }catch(e){
      print("error occurred: $e");
      count =-500;
    }
    yield LatLng(currentPosition!.latitude, currentPosition!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('geolocator'),backgroundColor: Colors.blue,),
      body: Center(
        child: StreamBuilder(
          stream: _listenCurrentLocation(),
          builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
            if(!snapshot.hasData){
              return const CircularProgressIndicator();
            }
            if(snapshot.hasError){
              return const Text('Error');
            }
            return snapshot.data==null? const Text('waiting...'):
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(initialPosition!.latitude,initialPosition!.longitude),
                zoom: 15,
              ),
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('initial-position'),
                  position: LatLng(initialPosition!.latitude, initialPosition!.longitude),
                  infoWindow: const InfoWindow(title: 'my initial position'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId('current-position'),
                  position: snapshot.data!, //LatLng(currentPosition!.latitude, currentPosition!.longitude),
                  infoWindow: const InfoWindow(title: 'my current position'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('PolylineId-1'),
                  color: Colors.blue,
                  width: 5,
                  points: latLngList,
                )
              },
            );
          },
        ),
      ),
    );
  }
}