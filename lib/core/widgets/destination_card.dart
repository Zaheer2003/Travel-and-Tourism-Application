import 'package:flutter/material.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/features/destinations/views/detail_screen.dart';
import 'package:travel_tourism/features/favorites/services/favorite_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final FavoriteService _favoriteService = FavoriteService();

  DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(destination: destination),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: destination.imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: destination.imageUrl,
                      height: 400,
                      width: 280,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      memCacheWidth: 600, // Optimize memory but keep crisp
                      placeholder: (context, url) => Container(
                        height: 400,
                        width: 280,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 400,
                        width: 280,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),
                    )
                  : Image.asset(
                      destination.imageUrl.replaceAll('\\', '/'),
                      height: 400,
                      width: 280,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          destination.imageUrl.replaceAll('\\', '/'),
                          height: 400,
                          width: 280,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 400,
                            width: 280,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 50),
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.location,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${destination.price}/day',
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: _favoriteService.isFavorite(destination.id),
                          builder: (context, snapshot) {
                            final isFavorite = snapshot.data ?? false;
                            return GestureDetector(
                              onTap: () => _favoriteService.toggleFavorite(destination.id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isFavorite 
                                    ? Colors.red.withOpacity(0.2) 
                                    : Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.white,
                                  size: 20,
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

