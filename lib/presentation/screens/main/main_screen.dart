import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home_screen.dart';
import '../home/crime_map_screen.dart';
import '../profile/profile_screen.dart';
import '../resources/safety_resources_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProfileScreen(),
    CrimeMapScreen(),
    SafetyResourcesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween(begin: 0.0, end: 0.25).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    ));

    _scaleAnimation = Tween(begin: 1.0, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFabTapped() async {
    await _animationController.forward();
    if (!mounted) return;

    final url =
        'https://metamask.app.link/dapp/https://reclaim-report.vercel.app/app/';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Could not launch MetaMask. Please make sure it is installed.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 64,
          width: 64,
          margin: const EdgeInsets.only(top: 30),
          child: FloatingActionButton(
            backgroundColor: AppColors.crimsonRed,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            onPressed: _onFabTapped,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: const Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                    _buildNavItem(1, Icons.person_outline, Icons.person, 'Profile'),
                  ],
                ),
              ),
              const SizedBox(width: 64), // Space for FAB
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(2, Icons.map_outlined, Icons.map, 'Map'),
                    _buildNavItem(3, Icons.shield_outlined, Icons.shield, 'Safety'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.navyBlue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.navyBlue : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
