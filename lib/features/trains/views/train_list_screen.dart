
import 'package:flutter/material.dart';
import 'package:travel_tourism/features/trains/models/train_route.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';
import 'package:travel_tourism/core/database_service.dart';
import 'package:travel_tourism/features/trains/views/train_route_screen.dart';

class TrainListScreen extends StatefulWidget {
  const TrainListScreen({super.key});

  @override
  State<TrainListScreen> createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen> {
  final DatabaseService _db = DatabaseService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Iconic Train Routes',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: 'Search train routes...',
                    hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<TrainRoute>>(
                stream: _db.trainRoutes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to load train routes.',
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                    );
                  }

                  var routes = snapshot.data ?? [];

                  if (_searchQuery.isNotEmpty) {
                    routes = routes.where((r) => 
                      r.name.toLowerCase().contains(_searchQuery) || 
                      r.from.toLowerCase().contains(_searchQuery) ||
                      r.to.toLowerCase().contains(_searchQuery)
                    ).toList();
                  }

                  if (routes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_train_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No train routes found.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final route = routes[index];
                      // Use a wider card style for the vertical list
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TrainRouteCard(route: route), 
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
