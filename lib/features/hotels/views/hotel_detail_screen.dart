import 'package:flutter/material.dart';
import 'package:travel_tourism/features/hotels/models/hotel.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/features/bookings/models/hotel_booking.dart';
import 'package:travel_tourism/features/hotels/services/hotel_booking_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:travel_tourism/features/favorites/services/favorite_service.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  final HotelBookingService _hotelBookingService = HotelBookingService();
  final FavoriteService _favoriteService = FavoriteService();
  final User? _user = FirebaseAuth.instance.currentUser;

  void _showHotelBookingModal(BuildContext context) {
    int rooms = 1;
    int guests = 1;
    DateTime checkInDate = DateTime.now().add(const Duration(days: 1));
    DateTime checkOutDate = DateTime.now().add(const Duration(days: 4));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final numberOfNights = checkOutDate.difference(checkInDate).inDays;
            final totalPrice = widget.hotel.pricePerNight * rooms * numberOfNights;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Reserve Your Stay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Check-in and Check-out Dates
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: checkInDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      onSurface: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setModalState(() {
                                checkInDate = date;
                                if (checkOutDate.isBefore(checkInDate.add(const Duration(days: 1)))) {
                                  checkOutDate = checkInDate.add(const Duration(days: 3));
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check-in',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM d, yyyy').format(checkInDate),
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: checkOutDate,
                              firstDate: checkInDate.add(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      onSurface: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setModalState(() => checkOutDate = date);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check-out',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM d, yyyy').format(checkOutDate),
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rooms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rooms',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setModalState(() => rooms > 1 ? rooms-- : null),
                            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                          Text(
                            '$rooms',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setModalState(() => rooms++),
                            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Guests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Guests',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setModalState(() => guests > 1 ? guests-- : null),
                            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                          Text(
                            '$guests',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setModalState(() => guests++),
                            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Booking Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$numberOfNights nights × $rooms room(s)',
                              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                            ),
                            Text(
                              '\$${(widget.hotel.pricePerNight * rooms * numberOfNights).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login to book a hotel')),
                          );
                          return;
                        }

                        final booking = HotelBooking(
                          id: '',
                          userId: _user!.uid,
                          hotelId: widget.hotel.id,
                          hotelName: widget.hotel.name,
                          hotelImage: widget.hotel.imageUrl,
                          hotelLocation: widget.hotel.location,
                          checkInDate: checkInDate,
                          checkOutDate: checkOutDate,
                          rooms: rooms,
                          guests: guests,
                          pricePerNight: widget.hotel.pricePerNight,
                          totalPrice: totalPrice,
                          status: 'Upcoming',
                          createdAt: DateTime.now(),
                          amenities: widget.hotel.amenities,
                        );

                        try {
                          await _hotelBookingService.createHotelBooking(booking);
                          Navigator.pop(context); // Close modal
                          
                          // Show Success Dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Booking Confirmed!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Your reservation at ${widget.hotel.name} has been successfully placed.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close Dialog
                                        // Optional: Navigate to bookings tab
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Text('Great!', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Booking failed: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Confirm Reservation',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Image with Parallax-like effect
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).cardColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<bool>(
                      stream: _favoriteService.isFavorite(widget.hotel.id),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;
                        return CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () async {
                              final added = await _favoriteService.toggleFavorite(widget.hotel.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(added ? 'Hotel added to favorites!' : 'Hotel removed from favorites'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.hotel.imageUrl.startsWith('http')
                    ? Image.network(
                        widget.hotel.imageUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                          child: Icon(Icons.hotel, size: 100, color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey),
                        ),
                      )
                    : Image.asset(
                        widget.hotel.imageUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                          child: Icon(Icons.hotel, size: 100, color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey),
                        ),
                      ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.hotel.name,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.displayLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.hotel.location,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.hotel.rating.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'About this Hotel',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.displayMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.hotel.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.displayMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: widget.hotel.amenities.map((amenity) => _buildAmenityChip(context, amenity)).toList(),
                      ),
                      const SizedBox(height: 120), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Price and Book Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price per night',
                          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
                        ),
                        Text(
                          '\$${widget.hotel.pricePerNight}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showHotelBookingModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Reserve Now',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(BuildContext context, String label) {
    IconData icon;
    switch (label.toLowerCase()) {
      case 'spa': case 'ayurvedic spa': case 'luxury spa': icon = Icons.spa_outlined; break;
      case 'pool': case 'infinity pool': case 'rooftop pool': case 'heated pool': case 'oceanfront pool': icon = Icons.pool_outlined; break;
      case 'gym': icon = Icons.fitness_center_outlined; break;
      case 'forest view': icon = Icons.forest_outlined; break;
      case 'mountain view': case 'panoramic views': icon = Icons.terrain_outlined; break;
      case 'ocean view': case 'sea view': case 'beachfront': case 'beach chalets': case 'ocean views': icon = Icons.beach_access_outlined; break;
      case 'city view': case 'city views': case 'city center': icon = Icons.location_city_outlined; break;
      case 'lake view': icon = Icons.water_outlined; break;
      case 'casino': icon = Icons.casino_outlined; break;
      case 'golf': case 'golf course': icon = Icons.golf_course_outlined; break;
      case 'wine bar': case 'rooftop bar': case 'pool bar': case 'historical bar': case 'chequers bar': case 'sky lounge': case 'nightclub': icon = Icons.local_bar_outlined; break;
      case 'fine dining': case 'gourmet dining': case 'cultural dining': case 'seafood': case 'jaffna cuisine': case '7 restaurants': icon = Icons.restaurant_outlined; break;
      case 'billiards room': icon = Icons.sports_esports_outlined; break;
      case 'museum': icon = Icons.museum_outlined; break;
      case 'luxury mall': icon = Icons.shopping_bag_outlined; break;
      case 'high tea': case 'heritage tea room': icon = Icons.coffee_outlined; break;
      case 'dolphin watching': case 'whale watching': icon = Icons.visibility_outlined; break;
      case 'water sports': case 'dive center': case 'underwater spa': icon = Icons.scuba_diving_outlined; break;
      case 'rooftop deck': icon = Icons.deck_outlined; break;
      case 'colonial architecture': case 'colonial suites': case 'traditional decor': case 'retro design': case 'beach villas': case 'modern rooms': case 'cultural theme': icon = Icons.architecture_outlined; break;
      default: icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}







