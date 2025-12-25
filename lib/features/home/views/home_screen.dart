import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/hotels/models/hotel.dart';
import 'package:travel_tourism/core/widgets/destination_card.dart';
import 'package:travel_tourism/core/widgets/hotel_card.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/core/database_service.dart';
import 'package:travel_tourism/core/widgets/skeletons/destination_skeleton.dart';
import 'package:travel_tourism/core/widgets/skeletons/hotel_skeleton.dart';
import 'package:travel_tourism/features/destinations/views/destination_map_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _db.uploadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user, context),
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildSectionTitle(
                _searchQuery.isEmpty ? 'Trending Destinations' : 'Search Results', 
                'See all',
                onActionTap: () {
                   // Optional: Navigate to see all destinations
                },
              ),
              const SizedBox(height: 16),
              _buildDestinationsList(),
              const SizedBox(height: 32),
              if (_searchQuery.isEmpty) ...[
                _buildSectionTitle('Top Hotels', 'See all'),
                const SizedBox(height: 16),
                _buildHotelsList(),
                const SizedBox(height: 32),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Explore by Category',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayMedium?.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoriesList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User? user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where to?',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.displayName ?? 'Traveler',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.displayMedium?.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user?.photoURL ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=100'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: 'Search destinations, hotels...',
            hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action, {VoidCallback? onActionTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.displayMedium?.color,
                ),
              ),
              if (title == 'Trending Destinations') ...[
                const SizedBox(width: 8),
                StreamBuilder<List<Destination>>(
                  stream: _db.destinations,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => DestinationMapScreen(destinations: snapshot.data!))
                      ),
                      child: Icon(Icons.map_outlined, color: AppTheme.primaryColor, size: 20),
                    );
                  }
                ),
              ],
            ],
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              action,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsList() {
    return SizedBox(
      height: 380,
      child: StreamBuilder<List<Destination>>(
        stream: _db.destinations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24, right: 8),
              itemCount: 3,
              itemBuilder: (context, index) => const DestinationSkeleton(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Permission Denied',
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            );
          }
          var destinations = snapshot.data ?? [];
          
          if (_searchQuery.isNotEmpty) {
            destinations = destinations.where((d) => 
              d.name.toLowerCase().contains(_searchQuery) || 
              d.location.toLowerCase().contains(_searchQuery)
            ).toList();
          }

          if (destinations.isEmpty) {
            return const Center(
              child: Text('No destinations found for your search.'),
            );
          }
          
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 24, right: 8),
            itemCount: destinations.length,
            itemBuilder: (context, index) => DestinationCard(destination: destinations[index]),
          );
        },
      ),
    );
  }

  Widget _buildHotelsList() {
    return SizedBox(
      height: 240,
      child: StreamBuilder<List<Hotel>>(
        stream: _db.hotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24, right: 8),
              itemCount: 4,
              itemBuilder: (context, index) => const HotelSkeleton(),
            );
          }
          if (snapshot.hasError) {
            return const SizedBox(); // Hide if error
          }
          final hotels = snapshot.data ?? [];
          if (hotels.isEmpty) return const Center(child: Text('No hotels found.'));

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 24, right: 8),
            itemCount: hotels.length,
            itemBuilder: (context, index) => HotelCard(hotel: hotels[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 24, right: 8),
      child: Row(
        children: [
          _buildCategoryItem(Icons.beach_access_rounded, 'Beach'),
          _buildCategoryItem(Icons.landscape_rounded, 'Mountain'),
          _buildCategoryItem(Icons.forest_rounded, 'Forest'),
          _buildCategoryItem(Icons.castle_rounded, 'Culture'),
          _buildCategoryItem(Icons.hiking_rounded, 'Adventure'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}







