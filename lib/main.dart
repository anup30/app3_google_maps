// google maps
// add, https://github.com/RafatMeraz/ostad_flutter_batch_five/tree/module-21-class-2/live_class_project

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeMapSomething() async {
    print("_mapController.getVisibleRegion() = ");
    print(await _mapController.getVisibleRegion()); // LatLngBounds(LatLng(-41.69584836329773, 55.62881715595722), LatLng(67.13937965531485, 127.95026052743196))
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('google maps app'),),
      body: GoogleMap(
        mapType: MapType.normal, // .satellite .hybrid .normal
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        // liteModeEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _initializeMapSomething();
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.742144667472623, 90.38969244807959), // Latitude Longitude
          zoom: 16, // the more zoom, the closer to target location
          bearing: 5, // in degree, A bearing of 0.0, the default, means the camera points north.
          tilt: 0,
        ),
        onTap: (LatLng latLng) {
          print('tapped on map : $latLng');
        },
        onLongPress: (LatLng latLng) {
          print('on Long press : $latLng');
        },
        markers: {
          Marker(
              markerId: const MarkerId('my-new-restaurant'),
              position: const LatLng(23.742443588311794, 90.3894929587841),
              infoWindow: const InfoWindow(title: 'my new restaurant'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              draggable: true,
              flat: false, //true
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
              circleId: const CircleId('my-new-restaurant'),
              center: const LatLng(23.742443588311794, 90.3894929587841),
              radius: 50,
              strokeColor: Colors.orange,
              strokeWidth: 3,
              fillColor: Colors.orange.withOpacity(0.15)
          ),
          Circle(
              circleId: const CircleId('my-new-restaurant-for-programm'),
              center: const LatLng(23.74122027959254, 90.38924183696508),
              radius: 50,
              strokeColor: Colors.blue,
              strokeWidth: 3,
              fillColor: Colors.lightGreen.withOpacity(0.15),
              onTap: () {
                print('Tapped on circle');
              },
              consumeTapEvents: true
          ),
        },
        polylines: {
          const Polyline(
              polylineId: PolylineId('ploy-one'),
              color: Colors.blueAccent,
              width: 5,
              points: [
                LatLng(23.740341307078115, 90.38882710039616),
                LatLng(23.740324734215356, 90.39145734161139),
                LatLng(23.742737598077895, 90.39118140935898),
                LatLng(23.740341307078115, 90.38882710039616),
              ]
          )
        },
        polygons: {
          Polygon(
              polygonId: const PolygonId('random-id'),
              fillColor: Colors.orange.withOpacity(0.4),
              strokeColor: Colors.orange,
              strokeWidth: 3,
              holes: const [], // TODO: explore it by yourself <-----
              points: const [
                LatLng(23.739841971936272, 90.3895965591073),
                LatLng(23.73569345718147, 90.38991339504719),
                LatLng(23.737665990064247, 90.39202865213156),
                LatLng(23.739380384460528, 90.38338992744684),
                LatLng(23.736511078293713, 90.38516487926245)
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

