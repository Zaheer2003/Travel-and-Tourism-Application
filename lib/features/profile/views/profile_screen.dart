import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_tourism/features/auth/services/auth_service.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/features/settings/views/settings_screen.dart';
import 'package:travel_tourism/features/favorites/views/favorites_screen.dart';

import 'package:travel_tourism/features/profile/views/personal_info_screen.dart';
import 'package:travel_tourism/features/profile/views/payment_methods_screen.dart';
import 'package:travel_tourism/features/profile/views/feedback_screen.dart';
import 'package:travel_tourism/features/profile/views/help_support_screen.dart';
import 'package:travel_tourism/features/tools/views/currency_converter_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService _auth = AuthService();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Header with Gradient
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF6B9CF2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Hero(
                      tag: 'profile_avatar',
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                          user?.photoURL ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Text(
              user?.displayName ?? (user?.isAnonymous == true ? 'Guest User' : 'Traveler'),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? (user?.isAnonymous == true ? 'Incognito Mode' : 'No email logged'),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                   _buildProfileOption(
                    context, 
                    icon: Icons.person_outline, 
                    title: 'Personal Information',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.payment_outlined, 
                    title: 'Payment Methods',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.favorite_border, 
                    title: 'My Favorites',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.settings_outlined, 
                    title: 'Settings',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.currency_exchange_outlined, 
                    title: 'Currency Converter',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrencyConverterScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.message_outlined, 
                    title: 'Feedback',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen())),
                  ),
                  _buildProfileOption(
                    context, 
                    icon: Icons.help_outline, 
                    title: 'Help & Support',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen())),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileOption(
                    context, 
                    icon: Icons.logout, 
                    title: 'Log Out', 
                    isDestructive: true,
                    onTap: () async {
                      await _auth.signOut();
                    }
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, bool isDestructive = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap ?? () {},
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppTheme.primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}







