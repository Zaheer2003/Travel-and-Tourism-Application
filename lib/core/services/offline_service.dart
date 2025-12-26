import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/hotels/models/hotel.dart';
import 'package:travel_tourism/features/bookings/models/booking.dart';
import 'package:travel_tourism/features/bookings/models/hotel_booking.dart';

class OfflineService {
  static const String favoritesBoxName = 'favorites';
  static const String bookingsBoxName = 'bookings';
  static const String hotelBookingsBoxName = 'hotel_bookings';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // We can store them as Maps to avoid complex TypeAdapters for now
    await Hive.openBox(favoritesBoxName);
    await Hive.openBox(bookingsBoxName);
    await Hive.openBox(hotelBookingsBoxName);
  }

  // Favorites Cache
  static Future<void> addFavorite(String id, Map<String, dynamic> data) async {
    final box = Hive.box(favoritesBoxName);
    await box.put(id, data);
  }

  static Future<void> removeFavorite(String id) async {
    final box = Hive.box(favoritesBoxName);
    await box.delete(id);
  }

  static Future<void> cacheFavorites(List<dynamic> favorites) async {
    final box = Hive.box(favoritesBoxName);
    await box.clear();
    for (var item in favorites) {
      if (item is Destination) {
        await box.put(item.id, item.toMap());
      } else if (item is Hotel) {
        await box.put(item.id, item.toMap());
      }
    }
  }

  static List<Map<String, dynamic>> getCachedFavorites() {
    final box = Hive.box(favoritesBoxName);
    return box.keys.map((key) {
      final data = Map<String, dynamic>.from(box.get(key));
      data['id'] = key.toString();
      return data;
    }).toList();
  }

  // Bookings Cache
  static Future<void> cacheBookings(List<Booking> bookings) async {
    final box = Hive.box(bookingsBoxName);
    await box.clear();
    for (var b in bookings) {
      await box.put(b.id, b.toMap());
    }
  }

  static Future<void> cacheHotelBookings(List<HotelBooking> bookings) async {
    final box = Hive.box(hotelBookingsBoxName);
    await box.clear();
    for (var b in bookings) {
      await box.put(b.id, b.toMap());
    }
  }
}
