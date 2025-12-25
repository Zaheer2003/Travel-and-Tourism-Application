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
    try {
      await uploadDestinations();
      await uploadHotels();
      await uploadTrainRoutes();
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
          name: 'Kandy',
          location: 'Central Province',
          imageUrl: 'https://images.unsplash.com/photo-1546708973-b339540b5162?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
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
          imageUrl: 'https://images.unsplash.com/photo-1621601730030-22c7f4802c61?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
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
          imageUrl: 'https://images.unsplash.com/photo-1588001646270-e4b52ffda2e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
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
          imageUrl: 'https://images.unsplash.com/photo-1627916607164-7b20241db935?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
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
          name: 'Heritance Kandalama',
          location: 'Dambulla',
          imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 250,
          rating: 4.8,
          amenities: ['Spa', 'Pool', 'Forest View'],
          description: 'Designed by Geoffrey Bawa, built into a rock face.',
        ),
        Hotel(
          id: '',
          name: 'Cinnamon Bentota Beach',
          location: 'Bentota',
          imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de4d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 280,
          rating: 4.7,
          amenities: ['Private Beach', 'Water Sports', 'Pool'],
          description: 'Ultimate river and sea-side resort at Bentota.',
        ),
        Hotel(
          id: '',
          name: 'The Fortress Resort',
          location: 'Galle',
          imageUrl: 'https://images.unsplash.com/photo-1540541338287-41700207dee6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          pricePerNight: 350,
          rating: 4.9,
          amenities: ['Ocean View', 'Ayurvedic Spa', 'Gourmet Dining'],
          description: 'A luxurious boutique hotel inspired by the Galle Fort.',
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
      print('DEBUG: Checking for train routes...');
      final snapshot = await trainCollection.get();
      print('DEBUG: Found ${snapshot.docs.length} train routes in Firestore');
      
      if (snapshot.docs.isNotEmpty) return;

      print('DEBUG: Collection empty. Uploading dummy trains...');
        TrainRoute(
          id: '',
          name: 'The Main Line (Podi Menike)',
          from: 'Colombo Fort',
          to: 'Badulla / Ella',
          imageUrl: 'https://images.unsplash.com/photo-1589139366408-9df8354c0e64?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'Considered one of the most scenic train rides in the world through misty mountains and tea estates.',
          schedule: ['05:55 AM (Morning Express)', '08:30 AM (Udarata Menike)', '20:00 PM (Night Mail)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
        TrainRoute(
          id: '',
          name: 'Coastal Line',
          from: 'Colombo Fort',
          to: 'Galle / Matara',
          imageUrl: 'https://images.unsplash.com/photo-1587595431973-160d0d94add1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100', // Reusing Ella for now or search
          description: 'A beautiful journey along the southwest coast, literally meters from the ocean waves.',
          schedule: ['06:50 AM (Sagarika)', '10:30 AM (Galu Kumari)', '15:10 PM (Express)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
        TrainRoute(
          id: '',
          name: 'Yal Devi (Northern Line)',
          from: 'Colombo Fort',
          to: 'Jaffna',
          imageUrl: 'https://images.unsplash.com/photo-1627915607164-7b20241db935?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=100',
          description: 'The legendary express train connecting the capital with the vibrant northern capital of Jaffna.',
          schedule: ['05:45 AM (Express)', '06:35 AM (Intercity)', '13:15 PM (Express)'],
          bookingUrl: 'https://seatreservation.railway.gov.lk/',
        ),
      ];

      for (var train in dummyTrains) {
        await trainCollection.add(train.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
