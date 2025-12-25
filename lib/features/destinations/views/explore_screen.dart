import 'package:flutter/material.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/core/widgets/destination_card.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/core/database_service.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Text(
                    'Explore',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: 'Search places...',
                    hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of destinations
            Expanded(
              child: StreamBuilder<List<Destination>>(
                stream: _db.destinations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Unable to load destinations.\nCheck Firestore Security Rules.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ),
                    );
                  }

                  final allDestinations = snapshot.data ?? [];

                  if (allDestinations.isEmpty) {
                    return const Center(child: Text('No destinations found.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: allDestinations.length,
                    itemBuilder: (context, index) {
                      final dest = allDestinations[index];
                      return _buildGridCard(context, dest);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, Destination dest) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(destination: dest),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: dest.imageUrl.startsWith('http')
                  ? Image.network(
                      dest.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Image.asset(
                      dest.imageUrl.replaceAll('\\', '/'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          dest.imageUrl.replaceAll('\\', '/'),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        );
                      },
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dest.location,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${dest.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







