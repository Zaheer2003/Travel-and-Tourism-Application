import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/features/bookings/models/booking.dart';
import 'package:travel_tourism/features/bookings/models/hotel_booking.dart';
import 'package:travel_tourism/features/bookings/services/booking_service.dart';
import 'package:travel_tourism/features/hotels/services/hotel_booking_service.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({super.key});

  final BookingService _bookingService = BookingService();
  final HotelBookingService _hotelBookingService = HotelBookingService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'Trips'),
              Tab(text: 'Hotels'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDestinationBookings(),
            _buildHotelBookings(),
            _buildCombinedBookingsByStatus('Upcoming'),
            _buildCombinedBookingsByStatus('Completed'),
            _buildCombinedBookingsByStatus('Cancelled'),
            _buildAllBookings(),
          ],
        ),
      ),
    );
  }

  // Destination Bookings Only
  Widget _buildDestinationBookings() {
    return StreamBuilder<List<Booking>>(
      stream: _bookingService.getUserBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return const EmptyBookingView(status: 'Destination');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return BookingCard(
              key: ValueKey(booking.id),
              booking: booking,
              onCancel: booking.status == 'Upcoming' 
                ? () => _showCancelDialog(context, booking) 
                : null,
            );
          },
        );
      },
    );
  }

  // Hotel Bookings Only
  Widget _buildHotelBookings() {
    return StreamBuilder<List<HotelBooking>>(
      stream: _hotelBookingService.getUserHotelBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return const EmptyBookingView(status: 'Hotel');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return HotelBookingCard(
              key: ValueKey(booking.id),
              booking: booking,
              onCancel: booking.status == 'Upcoming' 
                ? () => _showCancelHotelDialog(context, booking) 
                : null,
            );
          },
        );
      },
    );
  }

  // Combined Bookings by Status
  Widget _buildCombinedBookingsByStatus(String status) {
    return StreamBuilder<List<Booking>>(
      stream: _bookingService.getUserBookings(),
      builder: (context, destSnapshot) {
        return StreamBuilder<List<HotelBooking>>(
          stream: _hotelBookingService.getUserHotelBookings(),
          builder: (context, hotelSnapshot) {
            if (destSnapshot.connectionState == ConnectionState.waiting || 
                hotelSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final destBookings = (destSnapshot.data ?? [])
                .where((b) => b.status == status || (status == 'Completed' && b.status == 'Upcoming' && b.endDate.isBefore(DateTime.now())))
                .toList();
            final hotelBookings = (hotelSnapshot.data ?? [])
                .where((b) => b.status == status || (status == 'Completed' && b.status == 'Upcoming' && b.checkOutDate.isBefore(DateTime.now())))
                .toList();

            if (destBookings.isEmpty && hotelBookings.isEmpty) {
              return EmptyBookingView(status: status);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...destBookings.map((booking) => BookingCard(
                  key: ValueKey(booking.id),
                  booking: booking,
                  onCancel: status == 'Upcoming' ? () => _showCancelDialog(context, booking) : null,
                )),
                ...hotelBookings.map((booking) => HotelBookingCard(
                  key: ValueKey(booking.id),
                  booking: booking,
                  onCancel: status == 'Upcoming' ? () => _showCancelHotelDialog(context, booking) : null,
                )),
              ],
            );
          },
        );
      },
    );
  }

  // All Bookings
  Widget _buildAllBookings() {
    return StreamBuilder<List<Booking>>(
      stream: _bookingService.getUserBookings(),
      builder: (context, destSnapshot) {
        return StreamBuilder<List<HotelBooking>>(
          stream: _hotelBookingService.getUserHotelBookings(),
          builder: (context, hotelSnapshot) {
            if (destSnapshot.connectionState == ConnectionState.waiting || 
                hotelSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final destBookings = destSnapshot.data ?? [];
            final hotelBookings = hotelSnapshot.data ?? [];

            if (destBookings.isEmpty && hotelBookings.isEmpty) {
              return const EmptyBookingView(status: 'All');
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...destBookings.map((booking) => BookingCard(
                  key: ValueKey(booking.id),
                  booking: booking,
                  onCancel: booking.status == 'Upcoming' ? () => _showCancelDialog(context, booking) : null,
                )),
                ...hotelBookings.map((booking) => HotelBookingCard(
                  key: ValueKey(booking.id),
                  booking: booking,
                  onCancel: booking.status == 'Upcoming' ? () => _showCancelHotelDialog(context, booking) : null,
                )),
              ],
            );
          },
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Cancel Trip?', style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
        content: Text('Are you sure you want to cancel your trip to ${booking.destinationName}?', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, keep it', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await _bookingService.updateBookingStatus(booking.id, 'Cancelled');
              Navigator.pop(context); // Close confirm dialog
              
              // Show Success Pop message
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 48),
                      const SizedBox(height: 16),
                      const Text('Booking Cancelled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('The trip to ${booking.destinationName} has been cancelled.', textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCancelHotelDialog(BuildContext context, HotelBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Cancel Reservation?', style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
        content: Text('Are you sure you want to cancel your reservation at ${booking.hotelName}?', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, keep it', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await _hotelBookingService.updateHotelBookingStatus(booking.id, 'Cancelled');
              Navigator.pop(context); // Close confirm dialog
              
              // Show Success Pop message
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 48),
                      const SizedBox(height: 16),
                      const Text('Reservation Cancelled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Your stay at ${booking.hotelName} has been cancelled.', textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class EmptyBookingView extends StatelessWidget {
  final String status;
  const EmptyBookingView({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            'No $status bookings yet',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;

  const BookingCard({super.key, required this.booking, this.onCancel});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = '${DateFormat('d MMM').format(booking.startDate)} - ${DateFormat('d MMM').format(booking.endDate)}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: booking.destinationImage.startsWith('http')
                  ? Image.network(
                      booking.destinationImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80, height: 80, color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    )
                  : Image.asset(
                      booking.destinationImage.replaceAll('\\', '/'),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          booking.destinationImage.replaceAll('\\', '/'),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80, height: 80, 
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200], 
                            child: const Icon(Icons.image_not_supported)),
                        );
                      },
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking.destinationName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.displayMedium?.color),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(dateRange, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${booking.guests} Guests • \$${booking.totalPrice}', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          if (onCancel != null) ...[ 
            const SizedBox(height: 16),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                label: const Text('Cancel Trip', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(booking.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        booking.status,
        style: TextStyle(color: _getStatusColor(booking.status), fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HotelBookingCard extends StatelessWidget {
  final HotelBooking booking;
  final VoidCallback? onCancel;

  const HotelBookingCard({super.key, required this.booking, this.onCancel});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = '${DateFormat('d MMM').format(booking.checkInDate)} - ${DateFormat('d MMM').format(booking.checkOutDate)}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: booking.hotelImage.startsWith('http')
                  ? Image.network(
                      booking.hotelImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                        child: const Icon(Icons.hotel),
                      ),
                    )
                  : Image.asset(
                      booking.hotelImage.replaceAll('\\', '/'),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                        child: const Icon(Icons.hotel),
                      ),
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                                booking.hotelName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.displayMedium?.color),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                booking.hotelLocation,
                                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(dateRange, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${booking.rooms} Room(s) • ${booking.guests} Guests • \$${booking.totalPrice.toStringAsFixed(2)}', 
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 16),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                label: const Text('Cancel Reservation', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(booking.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        booking.status,
        style: TextStyle(color: _getStatusColor(booking.status), fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}







