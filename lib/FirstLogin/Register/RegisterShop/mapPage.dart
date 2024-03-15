import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'end/RequiredRegisterPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:varnaboomweb/Detail.dart';

class mapRegister extends StatefulWidget {
  mapRegister({Key? key}) : super(key: key);

  @override
  _mapRegisterState createState() => _mapRegisterState();
}

class _mapRegisterState extends State<mapRegister> {
  double targetlat = 35.785066;
  double targetlng = 51.379504;

  late double my_lat;
  late double my_lng;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> setLocation() async {
    Position mylocation = await _determinePosition();

    print(mylocation);

    setState(() {
      targetlat = mylocation.latitude;
      targetlng = mylocation.longitude;
      my_lng = mylocation.longitude;
      my_lat = mylocation.latitude;
    });
  }

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF400CCCB),
          child: Icon(Icons.done),
          onPressed: () async {
            registerInformationShop['lat'] = my_lat.toString();
            registerInformationShop['lng'] = my_lng.toString();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (co) => Directionality(
            //             textDirection: TextDirection.rtl,
            //             child: endregister())));
            Navigator.pop(context);
          }),
      body: FlutterMap(
        options: MapOptions(
          onTap: (context, n) {
            setState(() {
              my_lat = n.latitude;
              my_lng = n.longitude;
            });
          },
          center: LatLng(my_lat, my_lng),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
            },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(targetlat, targetlng),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.my_location,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(my_lat, my_lng),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
