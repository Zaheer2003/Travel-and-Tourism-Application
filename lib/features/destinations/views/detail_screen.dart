import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/hotels/models/review.dart';
import 'package:travel_tourism/features/bookings/models/booking.dart';
import 'package:travel_tourism/features/hotels/services/review_service.dart';
import 'package:travel_tourism/features/bookings/services/booking_service.dart';
import 'package:travel_tourism/core/database_service.dart';
import 'package:travel_tourism/features/favorites/services/favorite_service.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ReviewService _reviewService = ReviewService();
  final BookingService _bookingService = BookingService();
  final DatabaseService _db = DatabaseService();
  final FavoriteService _favoriteService = FavoriteService();
  final User? _user = FirebaseAuth.instance.currentUser;

  void _showAddReviewModal(BuildContext context) {
    double rating = 3.0;
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Share Your Experience',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 8),
              Text(
                'How was your trip to this destination?',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 24),
              Text('Your Rating', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: 12),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                glow: false,
                itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
                onRatingUpdate: (val) => rating = val,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: commentController,
                maxLines: 4,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'Describe your visit, the views, or the culture...',
                  hintStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to post a review')));
                      return;
                    }

                    final review = Review(
                      id: '',
                      userId: _user!.uid,
                      userName: _user!.displayName ?? 'Anonymous',
                      userImage: _user!.photoURL ?? '',
                      destinationId: widget.destination.id,
                      rating: rating,
                      comment: commentController.text,
                      date: DateTime.now(),
                    );

                    await _reviewService.addReview(review);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review posted successfully!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Post Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingModal(BuildContext context) {
    int guests = 1;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 3));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  Text('Book Your Trip', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Guests', style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setModalState(() => guests > 1 ? guests-- : null),
                            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                          Text('$guests', style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          IconButton(
                            onPressed: () => setModalState(() => guests++),
                            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).iconTheme.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Dates', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    subtitle: Text('${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d').format(endDate)}', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                    trailing: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                    onTap: () async {
                      final range = await showDateRangePicker(
                        context: context,
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
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (range != null) {
                        setModalState(() {
                          startDate = range.start;
                          endDate = range.end;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                      Text(
                        '\$${(widget.destination.price * guests * (endDate.difference(startDate).inDays == 0 ? 1 : endDate.difference(startDate).inDays)).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to book')));
                          return;
                        }
                        final booking = Booking(
                          id: '',
                          userId: _user!.uid,
                          destinationId: widget.destination.id,
                          destinationName: widget.destination.name,
                          destinationImage: widget.destination.imageUrl,
                          startDate: startDate,
                          endDate: endDate,
                          guests: guests,
                          totalPrice: widget.destination.price * guests * (endDate.difference(startDate).inDays == 0 ? 1 : endDate.difference(startDate).inDays),
                          status: 'Upcoming',
                          createdAt: DateTime.now(),
                        );
                        await _bookingService.createBooking(booking);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip booked successfully!')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500,
            child: widget.destination.imageUrl.startsWith('http')
                ? Image.network(
                    widget.destination.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  )
                : Image.asset(
                    widget.destination.imageUrl.replaceAll('\\', '/'),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        widget.destination.imageUrl.replaceAll('\\', '/'),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
          ),
          
          // Floating Back and Favorite Buttons
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _favoriteService.isFavorite(widget.destination.id),
                  builder: (context, snapshot) {
                    final isFavorite = snapshot.data ?? false;
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).cardColor,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () => _favoriteService.toggleFavorite(widget.destination.id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Content
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.destination.name,
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayLarge?.color),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                                        const SizedBox(width: 4),
                                        Text(widget.destination.location, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 16)),
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
                                    Text(widget.destination.rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text('About Destination', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayMedium?.color)),
                          const SizedBox(height: 12),
                          Text(
                            widget.destination.description,
                            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
                          ),
                          const SizedBox(height: 32),
                          
                          // Nearby Highlights
                          Text('Nearby Highlights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayMedium?.color)),
                          const SizedBox(height: 16),
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: const DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1526772662000-3f88f10405ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map_outlined, color: AppTheme.primaryColor),
                                  const SizedBox(width: 8),
                                  Text('Explore Nearby Map', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 100,
                            child: StreamBuilder<List<Destination>>(
                              stream: _db.destinations,
                              builder: (context, snapshot) {
                                final others = (snapshot.data ?? []).where((d) => d.id != widget.destination.id).take(3).toList();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: others.length,
                                  itemBuilder: (context, index) {
                                    final d = others[index];
                                    return Container(
                                      width: 200,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[100]!),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                            child: d.imageUrl.startsWith('http')
                                              ? Image.network(d.imageUrl, width: 60, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 100, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 20)))
                                              : Image.asset(
                                                  d.imageUrl.replaceAll('\\', '/'),
                                                  width: 60,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      d.imageUrl.replaceAll('\\', '/'),
                                                      width: 60,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 100, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 20)),
                                                    );
                                                  },
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(d.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 1),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayMedium?.color)),
                              TextButton(onPressed: () => _showAddReviewModal(context), child: const Text('Add Review')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          StreamBuilder<List<Review>>(
                            stream: _reviewService.getReviews(widget.destination.id),
                            builder: (context, snapshot) {
                              final reviews = snapshot.data ?? [];
                              if (reviews.isEmpty) return Text('No reviews yet.', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color));
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final r = reviews[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(backgroundImage: NetworkImage(r.userImage.isEmpty ? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80' : r.userImage)),
                                    title: Text(r.userName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                    subtitle: Text(r.comment, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
                                        Text(r.rating.toString(), style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom Booking Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05), blurRadius: 20, offset: const Offset(0, -10))],
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '\$${widget.destination.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        TextSpan(text: ' /person', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _showBookingModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}







