import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'detail_screen.dart';

class DestinationMapScreen extends StatefulWidget {
  final List<Destination> destinations;
  const DestinationMapScreen({super.key, required this.destinations});

  @override
  State<DestinationMapScreen> createState() => _DestinationMapScreenState();
}

class _DestinationMapScreenState extends State<DestinationMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (var dest in widget.destinations) {
      if (dest.lat != null && dest.lng != null && dest.lat != 0) {
        _markers.add(
          Marker(
            markerId: MarkerId(dest.id),
            position: LatLng(dest.lat!, dest.lng!),
            infoWindow: InfoWindow(
              title: dest.name,
              snippet: '\$${dest.price}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(destination: dest)),
                );
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Map', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.destinations.firstWhere((d) => d.lat != null && d.lat != 0).lat ?? 7.8731, 
                         widget.destinations.firstWhere((d) => d.lng != null && d.lng != 0).lng ?? 80.7718),
          zoom: 7,
        ),
        onMapCreated: (controller) => _mapController = controller,
        markers: _markers,
        myLocationEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
        style: Theme.of(context).brightness == Brightness.dark ? _darkMapStyle : null,
      ),
    );
  }

  // Basic dark mode style for the map
  final String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#242f3e"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#746855"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#242f3e"}]
    }
  ]
  ''';
}
