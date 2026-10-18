import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../l10n/app_localizations.dart';

class VendorMapScreen extends StatelessWidget {
  const VendorMapScreen({super.key});
  static const locations =
      <({String name, String cuisine, double rating, double lat, double lng})>[
    (
      name: 'Cairo Bites',
      cuisine: 'Egyptian',
      rating: 4.7,
      lat: 30.0444,
      lng: 31.2357
    ),
    (
      name: 'Alex Grill',
      cuisine: 'Grill',
      rating: 4.5,
      lat: 31.2001,
      lng: 29.9187
    ),
    (
      name: 'Giza Wraps',
      cuisine: 'Wraps',
      rating: 4.6,
      lat: 30.0131,
      lng: 31.2089
    ),
    (
      name: 'Mansoura Kitchen',
      cuisine: 'Egyptian',
      rating: 4.4,
      lat: 31.0409,
      lng: 31.3785
    ),
    (
      name: 'Port Said Seafood',
      cuisine: 'Seafood',
      rating: 4.8,
      lat: 31.2653,
      lng: 32.3019
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l.map)),
        body: GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(30.6, 31.1), zoom: 7),
            markers: locations
                .map((v) => Marker(
                    markerId: MarkerId(v.name),
                    position: LatLng(v.lat, v.lng),
                    infoWindow: InfoWindow(
                        title: v.name,
                        snippet: '${v.cuisine} • ${v.rating} ★')))
                .toSet()));
  }
}
