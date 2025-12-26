import 'package:flutter/material.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/favorites/services/favorite_service.dart';
import 'package:travel_tourism/core/database_service.dart';
import 'package:travel_tourism/core/widgets/destination_card.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/core/widgets/skeletons/destination_skeleton.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteService favoriteService = FavoriteService();
    final DatabaseService dbService = DatabaseService();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded, color: AppTheme.primaryColor),
            onPressed: () {
               // Force a rebuild or sync if needed
               (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: favoriteService.getFavoriteIds(),
        builder: (context, favSnapshot) {
          // Check cache first for immediate display or offline
          final cachedFavorites = favoriteService.getCachedFavorites();

          if (favSnapshot.connectionState == ConnectionState.waiting && cachedFavorites.isEmpty) {
            return _buildSkeletonGrid();
          }

          if (favSnapshot.hasError || (favSnapshot.data == null && cachedFavorites.isNotEmpty)) {
            // Show cached if offline/error
            return _buildGrid(cachedFavorites);
          }

          final favoriteIds = favSnapshot.data ?? [];

          if (favoriteIds.isEmpty && cachedFavorites.isEmpty) {
            return _buildEmptyState();
          }

          return StreamBuilder<List<Destination>>(
            stream: dbService.destinations,
            builder: (context, destSnapshot) {
              if (destSnapshot.connectionState == ConnectionState.waiting && cachedFavorites.isEmpty) {
                return _buildSkeletonGrid();
              }

              final allDestinations = destSnapshot.data ?? [];
              final favoriteDestinations = allDestinations
                  .where((d) => favoriteIds.contains(d.id))
                  .toList();

              // If stream is empty but we have IDs, or offline, fallback to cache
              if (favoriteDestinations.isEmpty && cachedFavorites.isNotEmpty) {
                return _buildGrid(cachedFavorites);
              }

              if (favoriteDestinations.isEmpty && !favSnapshot.hasData) {
                 return _buildEmptyState();
              }

              return _buildGrid(favoriteDestinations);
            },
          );
        },
      ),
    );
  }

  Widget _buildGrid(List<Destination> destinations) {
    if (destinations.isEmpty) return _buildEmptyState();
    
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return DestinationCard(destination: destinations[index]);
      },
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const DestinationSkeleton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, color: AppTheme.lightTextColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the heart on any destination to save it here!',
            style: TextStyle(color: AppTheme.lightTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, Destination dest) {
    return DestinationCard(destination: dest); // The current card is already good
  }
}







