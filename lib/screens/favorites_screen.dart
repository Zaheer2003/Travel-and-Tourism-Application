import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/favorite_service.dart';
import '../services/database_service.dart';
import '../widgets/destination_card.dart';
import '../theme/app_theme.dart';

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
      ),
      body: StreamBuilder<List<String>>(
        stream: favoriteService.getFavoriteIds(),
        builder: (context, favSnapshot) {
          if (favSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = favSnapshot.data ?? [];

          if (favoriteIds.isEmpty) {
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

          return StreamBuilder<List<Destination>>(
            stream: dbService.destinations,
            builder: (context, destSnapshot) {
              if (destSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allDestinations = destSnapshot.data ?? [];
              final favoriteDestinations = allDestinations
                  .where((d) => favoriteIds.contains(d.id))
                  .toList();

              return GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: favoriteDestinations.length,
                itemBuilder: (context, index) {
                  // We use a slightly smaller version or the standard card
                  final dest = favoriteDestinations[index];
                  return _buildSmallCard(context, dest);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, Destination dest) {
    return DestinationCard(destination: dest); // The current card is already good
  }
}
