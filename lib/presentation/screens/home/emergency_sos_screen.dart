import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> {
  bool _isEmergencyMode = false;
  bool _isSafetyCheckActive = false;

  Future<void> _handleSOS() async {
    setState(() => _isEmergencyMode = true);
    
    // Request location permission
    final locationPermission = await Permission.location.request();
    if (locationPermission.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition();
        // TODO: Implement emergency contact notification
        // TODO: Implement offline SMS functionality
        print('Emergency triggered at: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print('Error getting location: $e');
      }
    }

    // Simulated emergency response
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isEmergencyMode = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency services have been notified'),
        backgroundColor: AppColors.crimsonRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: AppColors.navyBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTapDown: (_) async => await _handleSOS(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isEmergencyMode ? 280 : 250,
                  height: _isEmergencyMode ? 280 : 250,
                  decoration: BoxDecoration(
                    color: _isEmergencyMode ? AppColors.coral : AppColors.crimsonRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.crimsonRed.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isEmergencyMode ? 'ALERTING...' : 'SOS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Safety Check'),
                  subtitle: const Text('Automatically check on you in high-risk areas'),
                  value: _isSafetyCheckActive,
                  onChanged: (bool value) {
                    setState(() => _isSafetyCheckActive = value);
                    // TODO: Implement safety check logic
                  },
                  activeColor: AppColors.burgundy,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to emergency contacts setup
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navyBlue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Setup Emergency Contacts'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 