import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/hotels/models/hotel.dart';

class DatabaseService {
  final CollectionReference destinationCollection = 
      FirebaseFirestore.instance.collection('destinations');
  final CollectionReference hotelCollection = 
      FirebaseFirestore.instance.collection('hotels');

  // Get destinations stream
  Stream<List<Destination>> get destinations {
    return destinationCollection.snapshots().map(_destinationListFromSnapshot);
  }

  // Destination list from snapshot
  List<Destination> _destinationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Destination.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Get hotels stream
  Stream<List<Hotel>> get hotels {
    return hotelCollection.snapshots().map(_hotelListFromSnapshot);
  }

  // Hotel list from snapshot
  List<Hotel> _hotelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Hotel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  bool _isUploading = false;

  // Combined upload for destinations and hotels
  Future<void> uploadInitialData() async {
    if (_isUploading) return;
    _isUploading = true;
    try {
      await uploadDestinations();
      await uploadHotels();
    } catch (e) {
      print('⚠️ Database initialization warning: $e');
      if (e.toString().contains('permission-denied')) {
        print('💡 Tip: Please check your Firebase Firestore rules. You might need to allow read/write access for development.');
      }
    } finally {
      _isUploading = false;
    }
  }

  // Add dummy destinations
  Future<void> uploadDestinations() async {
    try {
      final snapshot = await destinationCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) return;

      print('No destinations found. Starting upload...');
      List<Destination> dummyData = [
        Destination(
          id: '',
          name: 'Sigiriya',
          location: 'Central Province',
          imageUrl: 'https://images.unsplash.com/photo-1588258524675-55d6563e4678?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Ancient rock fortress designated as a UNESCO World Heritage Site.',
          price: 159,
          rating: 4.9,
          categories: ['Culture', 'History'],
          lat: 7.9570,
          lng: 80.7603,
        ),
        Destination(
          id: '',
          name: 'Ella',
          location: 'Uva Province',
          imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Scenic mountain village famous for the Nine Arch Bridge and tea plantations.',
          price: 120,
          rating: 4.8,
          categories: ['Mountains', 'Nature'],
          lat: 6.8724,
          lng: 81.0470,
        ),
        Destination(
          id: '',
          name: 'Mirissa',
          location: 'Southern Province',
          imageUrl: 'assets/images/mirissa.jpg',
          description: 'Beautiful tropical beach known for whale watching and surfing.',
          price: 140,
          rating: 4.7,
          categories: ['Beach', 'Surfing'],
          lat: 5.9483,
          lng: 80.4716,
        ),
        Destination(
          id: '',
          name: 'Nuwara Eliya',
          location: 'Central Province',
          imageUrl: 'https://images.unsplash.com/photo-1625902347781-678a3c480bd5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Colonial-era hill station known as "Little England" surrounded by tea.',
          price: 180,
          rating: 4.6,
          categories: ['Hill Station', 'Tea'],
          lat: 6.9497,
          lng: 80.7891,
        ),
        Destination(
          id: '',
          name: 'Yala National Park',
          location: 'Southern Province',
          imageUrl: 'https://images.unsplash.com/photo-1541018613454-00ed6449179d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Famous for its high density of leopards and diverse wildlife.',
          price: 100,
          rating: 4.8,
          categories: ['Wildlife', 'Safari'],
          lat: 6.3681,
          lng: 81.5173,
        ),
        Destination(
          id: '',
          name: 'Galle Fort',
          location: 'Southern Province',
          imageUrl: 'https://images.unsplash.com/photo-1578581650394-672905955677?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Historical fortification built by the Portuguese and fortified by the Dutch.',
          price: 90,
          rating: 4.7,
          categories: ['History', 'Architecture'],
          lat: 6.0272,
          lng: 80.2173,
        ),
      ];

      for (var dest in dummyData) {
        await destinationCollection.add(dest.toMap());
      }
      print('✅ Destinations uploaded successfully!');
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        rethrow;
      }
      print('❌ Error uploading destinations: $e');
    }
  }

  // Add dummy hotels
  Future<void> uploadHotels() async {
    try {
      final snapshot = await hotelCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return;
      }

      print('No hotels found. Starting upload...');
      List<Hotel> dummyHotels = [
        Hotel(
          id: '',
          name: 'Heritance Kandalama',
          location: 'Dambulla',
          imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 250,
          rating: 4.8,
          amenities: ['Spa', 'Pool', 'Forest View', 'Gym'],
          description: 'An architectural masterpiece unique to Sri Lanka, designed by Geoffrey Bawa.',
        ),
        Hotel(
          id: '',
          name: '98 Acres Resort & Spa',
          location: 'Ella',
          imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 320,
          rating: 4.9,
          amenities: ['Tea Plucking', 'Pool', 'Mountain View', 'Hiking'],
          description: 'A beautiful luxury hotel standing on a 98-acre tea estate in Ella.',
        ),
        Hotel(
          id: '',
          name: 'Wild Coast Tented Lodge',
          location: 'Yala',
          imageUrl: 'https://images.unsplash.com/photo-1544124499-1836ba274293?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 450,
          rating: 4.7,
          amenities: ['Safari', 'Luxury Tents', 'Pool', 'Gourmet Dining'],
          description: 'Where the jungle meets the ocean. A unique safari experience in Yala.',
        ),
      ];

      for (var hotel in dummyHotels) {
        await hotelCollection.add(hotel.toMap());
      }
      print('✅ All dummy hotels uploaded successfully!');
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        rethrow;
      }
      print('❌ Error uploading hotels: $e');
    }
  }
}







