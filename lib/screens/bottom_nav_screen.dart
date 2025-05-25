import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:home_for_rent/controller/nav_controller.dart';
import 'package:home_for_rent/screens/homepage.dart';
import 'package:home_for_rent/screens/profile.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final List<Widget> _screens = [
    Homepage(),
    // Placeholder widgets for other tabs
    Center(child: Text("Favorites")),
    Center(child: Text("Cart")),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());

    return Obx(() => Scaffold(
          body: _screens[controller.currentIndex.value],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withAlpha((0.1 * 255).round())),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(12),
                  duration: const Duration(milliseconds: 300),
                  tabBackgroundColor: Colors.deepOrange.shade100,
                  color: Colors.grey[800],
                  activeColor: Colors.deepOrange,
                  iconSize: 24,
                  tabs: const [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(icon: Icons.favorite, text: 'Favorites'),
                    GButton(icon: Icons.shopping_cart, text: 'Cart'),
                    GButton(icon: Icons.person, text: 'Profile'),
                  ],
                  selectedIndex: controller.currentIndex.value,
                  onTabChange: (index) {
                    controller.changeTab(index);
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
