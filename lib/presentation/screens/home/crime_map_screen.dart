import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';

class CrimeMapScreen extends StatefulWidget {
  const CrimeMapScreen({super.key});

  @override
  State<CrimeMapScreen> createState() => _CrimeMapScreenState();
}

class _CrimeMapScreenState extends State<CrimeMapScreen> {
  final MapController _mapController = MapController();
  String _selectedTimeFrame = 'Last 7 Days';
  String _selectedCrimeType = 'All';
  bool _showSafeRoutes = false;
  LatLng? _currentLocation;
  final List<Marker> _crimeMarkers = [];

  // Sample crime data (replace with real data)
  final List<Map<String, dynamic>> _crimeData = [
    {
      'type': 'Theft',
      'location': LatLng(51.5074, -0.1278), // Example location
      'description': 'Bike theft reported',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'type': 'Suspicious Activity',
      'location': LatLng(51.5084, -0.1268),
      'description': 'Suspicious person reported',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
    },
  ];

  final List<String> _timeFrames = [
    'Last 24 Hours',
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months'
  ];

  final List<String> _crimeTypes = [
    'All',
    'Theft',
    'Assault',
    'Vandalism',
    'Suspicious Activity'
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeCrimeMarkers();
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result != LocationPermission.denied && 
          result != LocationPermission.deniedForever) {
        await _getCurrentLocation();
      }
    } else if (permission != LocationPermission.deniedForever) {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      
      // Move map to current location
      _mapController.move(
        _currentLocation ?? const LatLng(51.5074, -0.1278),
        13,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to get current location. Please check your location settings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _initializeCrimeMarkers() {
    for (var crime in _crimeData) {
      _crimeMarkers.add(
        Marker(
          point: crime['location'] as LatLng,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showCrimeDetails(crime),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.crimsonRed.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                _getCrimeIcon(crime['type'] as String),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }
  }

  IconData _getCrimeIcon(String crimeType) {
    switch (crimeType) {
      case 'Theft':
        return Icons.money_off;
      case 'Assault':
        return Icons.warning;
      case 'Vandalism':
        return Icons.broken_image;
      case 'Suspicious Activity':
        return Icons.visibility;
      default:
        return Icons.warning;
    }
  }

  void _showCrimeDetails(Map<String, dynamic> crime) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crime['type'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(crime['description'] as String),
            const SizedBox(height: 8),
            Text(
              'Reported: ${_formatTimestamp(crime['timestamp'] as DateTime)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Map'),
        backgroundColor: AppColors.navyBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(51.5074, -0.1278),
              initialZoom: 13,
              onMapReady: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 13);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.navyBlue.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ..._crimeMarkers,
                ],
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search location...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // TODO: Implement location search
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'locate',
                  onPressed: _getCurrentLocation,
                  backgroundColor: AppColors.burgundy,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'route',
                  onPressed: () {
                    setState(() {
                      _showSafeRoutes = !_showSafeRoutes;
                    });
                  },
                  backgroundColor: _showSafeRoutes ? AppColors.crimsonRed : AppColors.navyBlue,
                  child: const Icon(Icons.directions),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Crime Data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text('Time Frame'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _timeFrames.map((time) {
              return ChoiceChip(
                label: Text(time),
                selected: _selectedTimeFrame == time,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeFrame = time;
                  });
                  // TODO: Implement time filter
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Crime Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _crimeTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _selectedCrimeType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedCrimeType = type;
                  });
                  // TODO: Implement crime type filter
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
} 