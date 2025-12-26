import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';
import 'package:travel_tourism/features/hotels/models/hotel.dart';
import 'package:travel_tourism/features/trains/models/train_route.dart';

class DatabaseService {
  final CollectionReference destinationCollection = 
      FirebaseFirestore.instance.collection('destinations');
  final CollectionReference hotelCollection = 
      FirebaseFirestore.instance.collection('hotels');
  final CollectionReference trainCollection = 
      FirebaseFirestore.instance.collection('train_routes');

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

  // Get train routes stream
  Stream<List<TrainRoute>> get trainRoutes {
    return trainCollection.snapshots().map(_trainListFromSnapshot);
  }

  List<TrainRoute> _trainListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TrainRoute.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  bool _isUploading = false;

  // Combined upload for destinations, hotels and trains
  Future<void> uploadInitialData() async {
    if (_isUploading) return;
    _isUploading = true;
    print('DATABASE: Starting initial data sync...');
    try {
      await uploadDestinations().catchError((e) => print('Error in destinations: $e'));
      await uploadHotels().catchError((e) => print('Error in hotels: $e'));
      await uploadTrainRoutes().catchError((e) => print('Error in train routes: $e'));
      print('DATABASE: Initial data sync completed.');
    } catch (e) {
      print('⚠️ Database initialization warning: $e');
    } finally {
      _isUploading = false;
    }
  }

  // Add dummy destinations
  Future<void> uploadDestinations() async {
    try {
      final snapshot = await destinationCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        // Check if we need to add NEW ones
        if (snapshot.docs.length < 10) {
           // Continue to upload more if needed, but for simplicity we'll skip if exists
           return;
        }
        return;
      }

      print('No destinations found. Starting upload...');
      List<Destination> dummyData = [
        Destination(
          id: '',
          name: 'Sigiriya',
          location: 'Central Province',
          imageUrl: 'https://images.unsplash.com/photo-1588258524675-55d6563e4678?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
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
          imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
          description: 'Scenic mountain village famous for the Nine Arch Bridge and tea plantations.',
          price: 120,
          rating: 4.8,
          categories: ['Mountains', 'Nature'],
          lat: 6.8724,
          lng: 81.0470,
        ),
        Destination(
          id: '',
          name: 'Kandy',
          location: 'Central Province',
          imageUrl: 'https://images.unsplash.com/photo-1546708973-b339540b5162?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
          description: 'The cultural capital of Sri Lanka, home to the Temple of the Tooth Relic.',
          price: 130,
          rating: 4.7,
          categories: ['Culture', 'City'],
          lat: 7.2906,
          lng: 80.6337,
        ),
        Destination(
          id: '',
          name: 'Adam\'s Peak',
          location: 'Sabaragamuwa',
          imageUrl: 'https://images.unsplash.com/photo-1621601730030-22c7f4802c61?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
          description: 'A sacred mountain popular for its sunrise climbs and amazing views.',
          price: 80,
          rating: 4.9,
          categories: ['Hiking', 'Spiritual'],
          lat: 6.8096,
          lng: 80.5000,
        ),
        Destination(
          id: '',
          name: 'Trincomalee',
          location: 'Eastern Province',
          imageUrl: 'https://images.unsplash.com/photo-1588001646270-e4b52ffda2e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
          description: 'Deep natural harbor and pristine white sandy beaches.',
          price: 150,
          rating: 4.6,
          categories: ['Beach', 'Nature'],
          lat: 8.5711,
          lng: 81.2335,
        ),
        Destination(
          id: '',
          name: 'Polonnaruwa',
          location: 'North Central',
          imageUrl: 'https://images.unsplash.com/photo-1627916607164-7b20241db935?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100&dpr=2',
          description: 'The medieval capital of Sri Lanka with well-preserved ruins.',
          price: 110,
          rating: 4.7,
          categories: ['History', 'Culture'],
          lat: 7.9403,
          lng: 81.0188,
        ),
      ];

      for (var dest in dummyData) {
        await destinationCollection.add(dest.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadHotels() async {
    try {
      final snapshot = await hotelCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) return;

      List<Hotel> dummyHotels = [
        Hotel(
          id: '',
          name: 'Cinnamon Life City of Dreams',
          location: 'Colombo',
          imageUrl: 'assets/Hotels/Cinnamon Life City of Dreams.jpg',
          pricePerNight: 350,
          rating: 4.9,
          amenities: ['Casino', 'Luxury Mall', 'Rooftop Deck', '7 Restaurants'],
          description: 'Colombo\'s new icon. An integrated resort blending contemporary luxury, vibrant entertainment, and world-class dining.',
        ),
        Hotel(
          id: '',
          name: 'The Grand Hotel Nuwara Eliya',
          location: 'Nuwara Eliya',
          imageUrl: 'assets/Hotels/The Grand Hotel Nuwara Eliya - Heritage Grand.jpg',
          pricePerNight: 220,
          rating: 4.8,
          amenities: ['High Tea', 'Golf Course', 'Heated Pool', 'Wine Bar'],
          description: 'Experience old-world charm in \'Little England\'. A masterful colonial heritage hotel surrounded by award-winning gardens.',
        ),
        Hotel(
          id: '',
          name: 'Taj Bentota Resort & Spa',
          location: 'Bentota',
          imageUrl: 'assets/Hotels/Taj Bentota Resort & Spa.jpg',
          pricePerNight: 290,
          rating: 4.7,
          amenities: ['Private Beach', 'Jiva Spa', 'Pool Bar', 'Water Sports'],
          description: 'A tropical haven where the Indian Ocean meets golden sands, offering exquisite hospitality and timeless luxury.',
        ),
        Hotel(
          id: '',
          name: 'Galle Face Hotel',
          location: 'Colombo',
          imageUrl: 'assets/Hotels/Galle Face Hotel.jpg',
          pricePerNight: 260,
          rating: 4.8,
          amenities: ['Oceanfront Pool', 'Museum', 'Chequers Bar', 'Colonial Suites'],
          description: 'South Asia\'s leading Grande Dame, a colonial masterpiece on the oceanfront that has hosted royalty and travelers since 1864.',
        ),
        Hotel(
          id: '',
          name: 'Amaya Hills Kandy',
          location: 'Kandy',
          imageUrl: 'assets/Hotels/Amaya Hills Kandy.jpg',
          pricePerNight: 190,
          rating: 4.6,
          amenities: ['Panoramic Views', 'Ayurvedic Spa', 'Nightclub', 'Traditional Decor'],
          description: 'A hilltop palace reflecting the majesty of the Kingdom of Kandy, offering panoramic views of the Hanthana mountain range.',
        ),
        Hotel(
          id: '',
          name: 'Jetwing Jaffna',
          location: 'Jaffna',
          imageUrl: 'assets/Hotels/Jetwing Jaffna.jpg',
          pricePerNight: 160,
          rating: 4.5,
          amenities: ['Rooftop Bar', 'Jaffna Cuisine', 'City Views', 'Modern Rooms'],
          description: 'A symbol of Northern hospitality, combining modern comfort with the rich cultural heritage and flavors of the Jaffna peninsula.',
        ),
        Hotel(
          id: '',
          name: 'The Kingsbury Hotel',
          location: 'Colombo',
          imageUrl: 'assets/Hotels/The Kingsbury Hotel.jpg',
          pricePerNight: 280,
          rating: 4.7,
          amenities: ['Infinity Pool', 'Sky Lounge', 'High Tea', 'Ocean Views'],
          description: 'The epitome of luxury in Colombo, offering majestic ocean views and an atmosphere of regal elegance.',
        ),
        Hotel(
          id: '',
          name: 'Queen\'s Hotel',
          location: 'Kandy',
          imageUrl: 'assets/Hotels/Queen\'s Hotel.jpg',
          pricePerNight: 150,
          rating: 4.4,
          amenities: ['Colonial Architecture', 'Lake View', 'Ballroom', 'City Center'],
          description: 'A historic British Colonial style hotel situated in the heart of Kandy, overlooking the Kandy Lake and Temple of the Tooth.',
        ),
        Hotel(
          id: '',
          name: 'Trinco Blu By Cinnamon',
          location: 'Trincomalee',
          imageUrl: 'assets/Hotels/Trinco Blu By Cinnamon.jpg',
          pricePerNight: 200,
          rating: 4.6,
          amenities: ['Dolphin Watching', 'Beach Chalets', 'Seafood', 'Dive Center'],
          description: 'A retro-chic beach resort on the eastern coast, perfect for sun, sea, and whale watching adventures.',
        ),
        Hotel(
          id: '',
          name: 'Uga Bay Pasikuda',
          location: 'Pasikuda',
          imageUrl: 'assets/Hotels/Uga Bay - Pasikuda.jpg',
          pricePerNight: 320,
          rating: 4.9,
          amenities: ['Infinity Pool', 'Underground Spa', 'Beach Villas', 'Fine Dining'],
          description: 'A luxury boutique resort on the pristine shores of Pasikuda Bay, blending tropical paradise with modern elegance.',
        ),
      ];

      for (var hotel in dummyHotels) {
        await hotelCollection.add(hotel.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadTrainRoutes() async {
    try {
      print('DEBUG: Checking train_routes collection...');
      final snapshot = await trainCollection.get();
      
      if (snapshot.docs.isNotEmpty) {
        print('DEBUG: Train routes already exist (${snapshot.docs.length}).');
        return;
      }

      print('DEBUG: No train routes found. Creating initial routes...');
      List<TrainRoute> dummyTrains = [
        TrainRoute(
          id: '',
          name: 'The Main Line (Podi Menike)',
          from: 'Colombo Fort',
          to: 'Badulla / Ella',
          imageUrl: 'assets/train/Ella to Kandy.jpg',
          description: 'Considered one of the most scenic train rides in the world through misty mountains and tea estates.',
          schedule: ['05:55 AM (Morning Express)', '08:30 AM (Udarata Menike)', '20:00 PM (Night Mail)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
        TrainRoute(
          id: '',
          name: 'Coastal Line',
          from: 'Colombo Fort',
          to: 'Galle / Matara',
          imageUrl: 'assets/train/colombo to galle.jpg',
          description: 'A beautiful journey along the southwest coast, literally meters from the ocean waves.',
          schedule: ['06:50 AM (Sagarika)', '10:30 AM (Galu Kumari)', '15:10 PM (Express)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
        TrainRoute(
          id: '',
          name: 'Yal Devi (Northern Line)',
          from: 'Colombo Fort',
          to: 'Jaffna',
          imageUrl: 'assets/train/Colombo to Jafna.jpg',
          description: 'The legendary express train connecting the capital with the vibrant northern capital of Jaffna.',
          schedule: ['05:45 AM (Express)', '06:35 AM (Intercity)', '13:15 PM (Express)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
      ];

      for (var train in dummyTrains) {
        await trainCollection.add(train.toMap());
        print('DEBUG: Added train route: ${train.name}');
      }
      print('✅ All train routes uploaded successfully!');
    } catch (e) {
      print('❌ Error in uploadTrainRoutes: $e');
    }
  }
}
