
# 📱 Travel & Tourism App Features

This document outlines the currently implemented features and offline capabilities of the Travel & Tourism Flutter application.

## 🌟 Available Features

### 1. 🔐 User Authentication
- **Secure Login/Signup**: Implementation using Firebase Authentication.
- **Social Auth**: Support for Google Sign-In.
- **Persistent Sessions**: Automatic login state management using Riverpod & Firebase Stream.

### 2. 🏠 Home Dashboard
- **Dynamic Content**:
  - **Explore by Category**: Filter destinations by Beach, Mountain, Culture, etc.
  - **Trending Destinations**: Horizontal scroll of top-rated locations.
  - **Top Hotels**: Curated list of premium accommodations.
  - **Iconic Train Routes**: Special section for scenic railway journeys.
- **Global Search**: Search bar to fund destinations, hotels, or attractions.

### 3. 🗺️ Destination Exploration
- **Smart Browsing**: `ExploreScreen` with grid view and categorization.
- **Interactive Maps**: `DestinationMapScreen` integration (Google Maps) to visualize locations.
- **Detailed Views**: Rich content pages with high-quality images, descriptions, pricing, and ratings.
- **Weather Integration**: Real-time LIVE weather updates for every destination to help plan your trip.

### 4. 🏨 Hotel Management
- **Hotel Browsing**: Dedicated listings for hotels.
- **Advanced Details**: Room amenities (Pool, Spa, Casino), pricing per night, and star ratings.
- **Booking System**: Feature-complete booking flow (`HotelBooking`) to modify and save reservations.

### 5. 🚂 Train Journeys
- **Route Visualization**: Showcases famous routes like "The Main Line" (Ella to Kandy) and "Coastal Line".
- **Schedule Information**: View daily train schedules and direct booking links.

### 6. 🛠️ Smart Tools
- **Currency Converter**: Real-time currency conversion tool to help travelers plan expenses (`currency_converter_screen.dart`).

### 7. 👤 User Profile
- **Personal Information**: Manage user details.
- **Bookings Management**: View history of Hotel and Destination bookings.
- **Favorites/Wishlist**: Save trusted spots for later access.

---

## ⚡ Offline Features & Capabilities

The application is engineered to be robust with intermittent or no internet connection.

### 1. 💾 Local Data Persistence (Hive)
We use **Hive**, a fast and lightweight NoSQL database, to enable full offline access to critical user data:
- **Favorites**: Users can view their wishlisted items without an internet connection.
- **Bookings**: Past and upcoming bookings are cached locally, ensuring ticket info is always available.
- **Architecture**: The `OfflineService` manages the synchronization between local Hive boxes and remote Firestore data.

### 2. 🖼️ Smart Image Caching
- **CachedNetworkImage**: All remote images are cached on the device after the first load.
- **User Experience**: Browsing previously visited pages is instantaneous and works fully offline.

### 3. 📦 Bundled Assets
- **Critical Media**: Core imagery (e.g., iconic train routes, top hotel thumbnails) is bundled directly in the app assets (`assets/train/`, `assets/Hotels/`).
- **Zero Latency**: These assets load instantly and require zero data usage.

### 4. ☁️ Firebase Offline Persistence
- **Firestore Caching**: The Firestore SDK automatically caches active queries.
- **Seamless Sync**: Changes made while offline (like adding a booking) are queued and automatically synchronized when the connection is restored.
