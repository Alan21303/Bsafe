import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SafetyResourcesScreen extends StatelessWidget {
  const SafetyResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Safety Resources'),
          backgroundColor: AppColors.navyBlue,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Safety Tips'),
              Tab(text: 'Emergency Contacts'),
              Tab(text: 'Quick Guide'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSafetyTips(),
            _buildEmergencyContacts(),
            _buildQuickGuide(),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTips() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTipCard(
          'Personal Safety',
          'Stay aware of your surroundings and trust your instincts.',
          Icons.person_outline,
          [
            'Walk confidently and stay alert',
            'Avoid dark, isolated areas',
            'Keep valuables out of sight',
            'Share your location with trusted contacts',
            'Use well-lit, populated routes',
          ],
        ),
        const SizedBox(height: 16),
        _buildTipCard(
          'Home Security',
          'Make your home a safer place with these tips.',
          Icons.home_outlined,
          [
            'Install proper lighting and security systems',
            'Keep doors and windows locked',
            'Don\'t advertise when you\'re away',
            'Know your neighbors',
            'Have an emergency plan',
          ],
        ),
        const SizedBox(height: 16),
        _buildTipCard(
          'Digital Safety',
          'Protect your digital presence and personal information.',
          Icons.phone_android_outlined,
          [
            'Use strong, unique passwords',
            'Enable two-factor authentication',
            'Be careful with personal information online',
            'Update your devices regularly',
            'Be wary of suspicious links and emails',
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyContacts() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContactCard(
          'Emergency Services',
          '911',
          Icons.emergency,
          'For immediate emergency response',
          AppColors.crimsonRed,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          'Police Non-Emergency',
          '311',
          Icons.local_police,
          'For non-emergency police assistance',
          AppColors.navyBlue,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          'Crime Stoppers',
          '1-800-222-TIPS',
          Icons.security,
          'Anonymous crime reporting',
          AppColors.burgundy,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          'Victim Support',
          '1-800-VICTIM',
          Icons.support_agent,
          '24/7 support for crime victims',
          AppColors.coral,
        ),
      ],
    );
  }

  Widget _buildQuickGuide() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGuideCard(
          'If You Feel Unsafe',
          [
            'Stay calm and assess the situation',
            'Move to a well-lit, populated area',
            'Call emergency services if needed',
            'Use the SOS feature in this app',
            'Alert trusted contacts',
          ],
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          'Witnessing a Crime',
          [
            'Ensure your own safety first',
            'Call emergency services',
            'Note important details',
            'Do not confront suspects',
            'Use the app to report anonymously',
          ],
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          'After an Incident',
          [
            'Report to law enforcement',
            'Document everything',
            'Seek medical attention if needed',
            'Contact victim support services',
            'Update emergency contacts',
          ],
        ),
      ],
    );
  }

  Widget _buildTipCard(String title, String subtitle, IconData icon, List<String> tips) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.navyBlue),
        title: Text(title),
        subtitle: Text(subtitle),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tips.map((tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, String contact, IconData icon, String description, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: TextButton(
          onPressed: () {
            // TODO: Implement contact action
          },
          child: Text(
            contact,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(String title, List<String> steps) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.navyBlue,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
} 