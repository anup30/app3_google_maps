// google maps
// add, https://github.com/RafatMeraz/ostad_flutter_batch_five/tree/module-21-class-2/live_class_project

import 'package:app3_google_maps/geolocator_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// to do : user set a marker
// holes in polygon, draw 'A' in map
// implement open street map

void main(){runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
// clas 3, Geo location, 13:00
class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _doSomething() async {
    print("_mapController.getVisibleRegion() = ");
    print(await _mapController.getVisibleRegion()); // LatLngBounds(LatLng(-41.69584836329773, 55.62881715595722), LatLng(67.13937965531485, 127.95026052743196))
    // _mapController. // functions
  }

  List<LatLng> latLngList =
   [
    const LatLng(23.740341307078115, 90.38882710039616),
    const LatLng(23.740324734215356, 90.39145734161139),
    const LatLng(23.742737598077895, 90.39118140935898),
    const LatLng(23.743868823619685, 90.38998179137707),
    const LatLng(23.74330996382975, 90.3886155411601),
    const LatLng(23.741055472697827, 90.38797348737717),
    //LatLng(23.740341307078115, 90.38882710039616), // closing with first
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('google maps app'),),
      body: GoogleMap(
        mapType: MapType.normal, // .satellite .hybrid .normal .terrain
        zoomControlsEnabled: true, // + - zoom in/out buttons
        zoomGesturesEnabled: true, //on tap zoom in
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        // liteModeEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _doSomething();
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.742144667472623, 90.38969244807959), // Latitude Longitude
          zoom: 15, // the more zoom, the closer to target location, 16-17 more commonly used.
          bearing: 1, // rotate clockwise in degree, A bearing of 0.0, the default, means the camera points north.
          tilt: 0,
        ),
        onTap: (LatLng latLng) {
          print('tapped on map : $latLng');
        },
        onLongPress: (LatLng latLng) {
          print('on Long press : $latLng');
        },
        markers: {
          Marker( // how user can set a Marker ? <-----------------------------------
              markerId: const MarkerId('my-new-restaurant'),
              position: const LatLng(23.742443588311794, 90.3894929587841),
              infoWindow: const InfoWindow(title: 'my new restaurant'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              draggable: true,
              flat: false, //true
            //onTap: (){}
          ),
          Marker(
              markerId: const MarkerId('my-new-club'),
              position: const LatLng(23.74183162848683, 90.389587841928),
              infoWindow: const InfoWindow(title: 'my new club'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              draggable: true,
              flat: false,
          ),
          Marker(
              markerId: const MarkerId('my-new-hotel'),
              position: const LatLng(23.741736489038175, 90.3900247067213),
              infoWindow: const InfoWindow(title: 'my new hotel'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
              draggable: true,
              flat: false
          )
        },
        circles: {
          Circle(
              circleId: const CircleId('my-new-circle-1'),
              center: const LatLng(23.742443588311794, 90.3894929587841),
              radius: 50,
              strokeColor: Colors.orange,
              strokeWidth: 3,
              fillColor: Colors.yellow.withOpacity(0.1)
          ),
          Circle(
              circleId: const CircleId('my-new-circle-2'),
              center: const LatLng(23.74122027959254, 90.38924183696508),
              radius: 50,
              strokeColor: Colors.blue,
              strokeWidth: 3,
              fillColor: Colors.lightGreen.withOpacity(0.1),
              onTap: () {
                print('Tapped on circle');
              },
              consumeTapEvents: true
          ),
        },
        polylines: {
          Polyline(
              polylineId: PolylineId('poly-one'),
              color: Colors.green,
              width: 3,
              points: latLngList,
              // [
              //   LatLng(23.740341307078115, 90.38882710039616),
              //   LatLng(23.740324734215356, 90.39145734161139),
              //   LatLng(23.742737598077895, 90.39118140935898),
              //   LatLng(23.743868823619685, 90.38998179137707),
              //   LatLng(23.74330996382975, 90.3886155411601),
              //   LatLng(23.741055472697827, 90.38797348737717),
              //   //LatLng(23.740341307078115, 90.38882710039616), // closing with first
              // ],
          )
        },
        polygons: {
          Polygon(
              polygonId: const PolygonId('my-polygonId'),
              fillColor: Colors.orange.withOpacity(0.1),
              strokeColor: Colors.orange,
              strokeWidth: 2,
              holes: const [], // TO DO: explore it yourself <-----
              points: const [
                LatLng(23.740224069374076, 90.3841932490468),
                LatLng(23.739797470555377, 90.38689322769642),
                LatLng(23.743004600108883, 90.38830272853374),
                LatLng(23.745184789315726, 90.38672659546137),
                LatLng(23.74386084430952, 90.38525439798832),
              ]
          )
        },

      ),
    );
  }
}
/* Maps SDK for Android overview  https://developers.google.com/maps/documentation/android-sdk/overview
 Build awesome apps with Google’s knowledge of the real world https://developers.google.com/maps
 > get started.
 >documentation > google maps for flutter
 >overview
 > setup a flutter project

  read instructions in https://pub.dev/packages/google_maps_flutter > and add api key
  passport, dual currency card > billing information to google: free api key.

 */

