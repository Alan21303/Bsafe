import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CrimeMapScreen extends StatefulWidget {
  const CrimeMapScreen({super.key});

  @override
  State<CrimeMapScreen> createState() => _CrimeMapScreenState();
}

class _CrimeMapScreenState extends State<CrimeMapScreen> {
  String _selectedTimeFrame = 'Last 7 Days';
  String _selectedCrimeType = 'All';
  bool _showSafeRoutes = false;

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
          // TODO: Implement actual map widget
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text('Map will be implemented here'),
            ),
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
                  onPressed: () {
                    // TODO: Implement current location
                  },
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