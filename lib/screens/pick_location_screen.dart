import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isMyLocationEnabled = false;
  String? _address;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _isMyLocationEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_selectedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962), // Googleplex
          zoom: 14,
        ),
        myLocationEnabled: _isMyLocationEnabled,
        myLocationButtonEnabled: true,
        onTap: (location) async {
          final placemarks = await geo.placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          String? address;
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            address =
                '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
          }
          setState(() {
            _selectedLocation = location;
            _address = address;
          });

          // Add a small delay to allow the map to update with the new marker
          await Future.delayed(const Duration(milliseconds: 100));

          if (mounted) {
            _mapController?.showMarkerInfoWindow(
              const MarkerId('selected-location'),
            );
          }
        },
        markers:
            _selectedLocation == null
                ? {}
                : {
                  Marker(
                    markerId: const MarkerId('selected-location'),
                    position: _selectedLocation!,
                    infoWindow: InfoWindow(
                      title: 'Selected Location',
                      snippet: _address,
                    ),
                  ),
                },
      ),
    );
  }
}
