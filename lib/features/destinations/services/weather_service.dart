import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temp;
  final String condition;
  final String icon;
  final List<HourlyForecast> hourly;

  WeatherData({
    required this.temp,
    required this.condition,
    required this.icon,
    required this.hourly,
  });
}

class HourlyForecast {
  final String time;
  final double temp;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
  });
}

class WeatherService {
  final String apiKey = '659650949c7735ded689c3208ca127f7';

  Future<WeatherData?> getWeather(String location, {double? lat, double? lng}) async {
    try {
      String url;
      if (lat != null && lng != null && lat != 0 && lng != 0) {
        url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$apiKey&units=metric';
        print('DEBUG: Weather - Fetching for coordinates ($lat, $lng)...');
      } else {
        final String encodedLocation = Uri.encodeComponent('$location,LK');
        url = 'https://api.openweathermap.org/data/2.5/weather?q=$encodedLocation&appid=$apiKey&units=metric';
        print('DEBUG: Weather - Fetching for $location...');
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final double currentTemp = (data['main']['temp'] ?? 0.0).toDouble();
        final String condition = data['weather'][0]['main'] ?? 'Clear';
        
        // Generating mock hourly based on current for UI consistency
        List<HourlyForecast> hourly = List.generate(3, (index) {
          final hour = (DateTime.now().hour + index + 1) % 24;
          final String period = hour >= 12 ? 'PM' : 'AM';
          final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
          
          return HourlyForecast(
            time: '$displayHour $period',
            temp: currentTemp + (index * 0.5),
            icon: _getIconForCondition(condition),
          );
        });

        return WeatherData(
          temp: currentTemp,
          condition: condition,
          icon: _getIconForCondition(condition),
          hourly: hourly,
        );
      } else {
        print('DEBUG: Weather - API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('DEBUG: Weather - Exception: $e');
    }
    return null;
  }

  String _getIconForCondition(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('cloud')) return '☁️';
    if (condition.contains('rain')) return '🌧️';
    if (condition.contains('clear')) return '☀️';
    if (condition.contains('thunder')) return '⛈️';
    return '☀️';
  }
}
