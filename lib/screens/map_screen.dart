// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:groce_ease/screens/HomeScreen.dart';
import 'package:groce_ease/auth/firebase_auth.dart';
import 'package:groce_ease/controller/language_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;

  const MapScreen.fromAuth(
      {super.key, required this.phoneNumber, required this.name});

  const MapScreen({
    Key? key,
  })  : phoneNumber = '',
        name = '', // Provide initial values here
        super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? currentLocation;
  LatLng? pointerLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            languageController.isEnglish
                ? "Search your loaction"
                : "اپنی لوکیشن تلاش کریں",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? const LatLng(0, 0),
              zoom: 17.0,
            ),
            markers: markers,
            onCameraMove: (CameraPosition position) {
              setState(() {
                pointerLocation = position.target;
              });
            },
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          if (pointerLocation != null)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 30,
              left: MediaQuery.of(context).size.width / 2 - 15,
              child: Container(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.green[900];
              }
              return Colors.green;
            },
          ),
        ),
        onPressed: () {
          confirmDeliveryLocation();
        },
        child: Text(languageController.isEnglish
            ? 'Confirm Delivery Location'
            : 'تصدیق کریں ہونے والی ترسیل کی جگہ'),
      ),
    );
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request location permission
      await Geolocator.requestPermission();
    }
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      markers = {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarker,
        ),
      };
      mapController.animateCamera(CameraUpdate.newLatLng(currentLocation!));
      pointerLocation = currentLocation;
      markers.clear(); // Remove existing markers
    });
  }

  void confirmDeliveryLocation() async {
    if (pointerLocation != null) {
      // Perform service area validation
      bool isServiceArea = checkServiceArea(
        pointerLocation!.latitude,
        pointerLocation!.longitude,
      );

      if (isServiceArea) {
        // Get the full address including the city name
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pointerLocation!.latitude,
          pointerLocation!.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String street = placemark.street ?? '';
          String city = placemark.administrativeArea ?? '';
          String address = '$street, $city';
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('location', address);
          // Navigate to the home screen and pass the full address
          widget.phoneNumber.isNotEmpty
              ? Get.offAll(
                  HomeScreen(
                    phoneNumber: widget.phoneNumber,
                    name: widget.name,
                    isEnglish: languageController.isEnglish,
                    location: address,
                  ),
                )
              : Get.to(HomeScreen(
                  name: widget.name,
                  phoneNumber: widget.phoneNumber,
                  isEnglish: languageController.isEnglish,
                  location: address,
                ));
        } else {
          // Handle case when no placemark is available
          showErrorDialog(languageController.isEnglish
              ? 'Address not found'
              : 'پتہ نہیں ملا');
        }
      } else {
        // Show pop-up if user is not in service area
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(languageController.isEnglish
                ? 'Service Not Available'
                : 'سروس دستیاب نہیں'),
            content: Text(languageController.isEnglish
                ? 'Sorry, the service is not available in your area.'
                : 'معذرت، آپ کے علاقے میں سروس دستیاب نہیں ہے".'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageController.isEnglish ? 'Error' : 'خطا'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool checkServiceArea(double latitude, double longitude) {
    double minLatitude = 34.1337; // Minimum latitude of the service area
    double maxLatitude = 34.2255; // Maximum latitude of the service area
    double minLongitude = 73.2075; // Minimum longitude of the service area
    double maxLongitude = 73.3054; // Maximum longitude of the service area

    if (latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude) {
      return true; // User is within the service area
    } else {
      return false; // User is outside the service area
    }
  }
}
