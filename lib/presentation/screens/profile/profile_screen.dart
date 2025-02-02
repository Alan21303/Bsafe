import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_constants.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.navyBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.navyBlue,
                          AppColors.burgundy,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            final user = authProvider.user;
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: user?.photoURL != null
                                      ? NetworkImage(user!.photoURL!)
                                      : null,
                                  child: user?.photoURL == null
                                      ? const Icon(Icons.person, size: 40)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user?.displayName ?? 'User',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSafetyScore(),
                  const SizedBox(height: 24),
                  _buildEmergencyContacts(),
                  const SizedBox(height: 24),
                  _buildSafetyPreferences(),
                  const SizedBox(height: 24),
                  _buildActivitySummary(),
                  const SizedBox(height: 24),
                  _buildSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyScore() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Safety Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navyBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '85/100',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.burgundy),
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildScoreChip('Location Sharing Active', Icons.location_on),
                _buildScoreChip('Emergency Contacts Set', Icons.contacts),
                _buildScoreChip('Safety Alerts On', Icons.notifications_active),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.navyBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.navyBlue,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.navyBlue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                // TODO: Implement add contact
              },
              child: Text(
                'Add New',
                style: TextStyle(
                  color: AppColors.burgundy,
                ),
              ),
            ),
          ),
          _buildContactTile(
            'John Doe',
            'Primary Contact',
            '+1 234-567-8900',
            Icons.star,
          ),
          _buildContactTile(
            'Jane Smith',
            'Secondary Contact',
            '+1 234-567-8901',
            Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    String name,
    String relation,
    String phone,
    IconData icon,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.burgundy.withOpacity(0.1),
        child: Icon(
          icon,
          color: AppColors.burgundy,
        ),
      ),
      title: Text(name),
      subtitle: Text(relation),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phone,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.phone,
            color: AppColors.burgundy,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyPreferences() {
    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Safety Preferences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Automatic Location Sharing'),
            subtitle: const Text('Share location during emergency'),
            value: true,
            onChanged: (value) {
              // TODO: Implement location sharing toggle
            },
            activeColor: AppColors.burgundy,
          ),
          SwitchListTile(
            title: const Text('Safety Check Reminders'),
            subtitle: const Text('Periodic check-ins when in high-risk areas'),
            value: true,
            onChanged: (value) {
              // TODO: Implement safety check toggle
            },
            activeColor: AppColors.burgundy,
          ),
          SwitchListTile(
            title: const Text('Crime Alerts'),
            subtitle: const Text('Notifications about nearby incidents'),
            value: true,
            onChanged: (value) {
              // TODO: Implement crime alerts toggle
            },
            activeColor: AppColors.burgundy,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActivityStat(
                  'Safe Hours',
                  '124',
                  Icons.timer,
                  AppColors.navyBlue,
                ),
                _buildActivityStat(
                  'Alerts Sent',
                  '3',
                  Icons.notification_important,
                  AppColors.crimsonRed,
                ),
                _buildActivityStat(
                  'Check-ins',
                  '28',
                  Icons.check_circle,
                  AppColors.burgundy,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            'Account Settings',
            Icons.person_outline,
            () {
              // TODO: Navigate to account settings
            },
          ),
          _buildSettingsTile(
            'Privacy & Security',
            Icons.security,
            () {
              // TODO: Navigate to privacy settings
            },
          ),
          _buildSettingsTile(
            'Notification Preferences',
            Icons.notifications_none,
            () {
              // TODO: Navigate to notification settings
            },
          ),
          _buildSettingsTile(
            'Help & Support',
            Icons.help_outline,
            () {
              // TODO: Navigate to help
            },
          ),
          _buildSettingsTile(
            'Sign Out',
            Icons.exit_to_app,
            () {
              // TODO: Implement sign out
            },
            color: AppColors.crimsonRed,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.navyBlue,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
