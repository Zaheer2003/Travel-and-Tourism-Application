// Core constants for the Travel & Tourism app
class AppConstants {
  // App Info
  static const String appName = 'Travel & Tourism';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String destinationsCollection = 'destinations';
  static const String hotelsCollection = 'hotels';
  static const String bookingsCollection = 'bookings';
  static const String hotelBookingsCollection = 'hotelBookings';
  static const String usersCollection = 'users';
  static const String reviewsCollection = 'reviews';

  // Booking Status
  static const String statusUpcoming = 'Upcoming';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';

  // Default Values
  static const int defaultGuests = 1;
  static const int defaultRooms = 1;
  static const int defaultNights = 3;

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;

  // Image Placeholders
  static const String placeholderImageUrl = 'https://via.placeholder.com/400x300';

  // Date Formats
  static const String dateFormat = 'MMM d, yyyy';
  static const String shortDateFormat = 'd MMM';
  static const String timeFormat = 'HH:mm';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;

  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
}







