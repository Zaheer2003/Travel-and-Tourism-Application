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

  Future<WeatherData?> getWeather(String location) async {
    try {
      // First, get the current weather
      final currentResponse = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location,LK&appid=$apiKey&units=metric'),
      );

      if (currentResponse.statusCode == 200) {
        final data = json.decode(currentResponse.statusCode == 200 ? currentResponse.body : '');
        
        // OpenWeather Free API doesn't always include easy hourly in 2.5 without a separate call
        // For a clean demo, we'll use the main data and mock the hourly part from it
        // as the 5-day/3-hour forecast is a different endpoint.
        
        final double currentTemp = data['main']['temp'].toDouble();
        final String condition = data['weather'][0]['main'];
        final String iconCode = data['weather'][0]['icon'];

        // Generating mock hourly based on current for UI consistency
        List<HourlyForecast> hourly = List.generate(3, (index) {
          final hour = DateTime.now().hour + index + 1;
          return HourlyForecast(
            time: '${hour > 12 ? hour - 12 : hour} ${hour >= 12 ? 'PM' : 'AM'}',
            temp: currentTemp + (index * 0.5),
            icon: iconCode,
          );
        });

        return WeatherData(
          temp: currentTemp,
          condition: condition,
          icon: _getIconForCondition(condition),
          hourly: hourly,
        );
      }
    } catch (e) {
      print('Weather Error: $e');
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
