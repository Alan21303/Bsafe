import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../resources/resources_screen.dart';
import '../support/support_intro_screen.dart';
import '../profile/profile_screen.dart';
import '../report/report_screen.dart';
import '../../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/emergency_sos_screen.dart';
import '../home/crime_map_screen.dart';
import '../report/crime_report_screen.dart';
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

  final List<Widget> _screens = [
    const EmergencySOSScreen(),
    const CrimeMapScreen(),
    const CrimeReportScreen(),
    const SafetyResourcesScreen(),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      body: _screens[_selectedIndex],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.navyBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Crime Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
