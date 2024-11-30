import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/AdditionalInfoItem.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String selectedCity = 'Kolkata';
  List<String> cities= ['Kolkata','Delhi','Mumbai','Bengaluru','Chennai','Patna'];

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {


      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&APPID=$openWeatherAPIKey'),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize:24),
        ),
        centerTitle: true,







        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
            child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),

            ),
          ),

        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentTempCel = (currentTemp - 273.15).toStringAsFixed(2);
          final currentSky = currentWeatherData['weather'][0]['main'];
          final humidity = currentWeatherData['main']['humidity'];
          final pressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final gust = currentWeatherData['wind']['gust'];
          final visibility = (currentWeatherData['visibility']) / 1000;
          final feelsLikeTemp = currentWeatherData['main']['feels_like'];
          final feelsLikeTempCel = (feelsLikeTemp - 273.15).toStringAsFixed(2);


          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(


              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on),
                    ),
                    DropdownButton<String>(
                      underline: const SizedBox.shrink(),

                      dropdownColor: Colors.grey.shade400,
                      value: cities.contains(selectedCity) ? selectedCity : cities[0],
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      items: cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: const TextStyle(
                              fontSize: 25,

                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newCity) {
                        if (newCity != null && newCity != selectedCity) {
                          setState(() {
                            selectedCity = newCity;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(

                  width: double.infinity,
                  child: Card(
                    // color: Colors.yellow.shade100,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTempCel °C',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                //  SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for(int i=0;i<38;i++)
                //       HourlyForecastItem(
                //         icon: data['list'][i+1]['weather'][0]['main']=='Clouds'||data['list'][i+1]['weather'][0]['main']=='Rain'?
                //         Icons.cloud:Icons.sunny,
                //         time: data['list'][i+1]['dt_txt'],
                //         value: data['list'][i+1]['main']['temp'].toString(),
                //       ),
                //
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final hourlyData = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp = hourlyData['main']['temp'];
                      final hourlyTempCel =
                          (hourlyTemp - 273.15).toStringAsFixed(2);
                      final time =
                          DateTime.parse(hourlyData['dt_txt'].toString());

                      return HourlyForecastItem(
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        value: hourlyTempCel,
                        time: DateFormat.j().format(time),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$humidity %',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$windSpeed m/s',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$pressure hPa',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.remove_red_eye,
                      label: 'Visibility',
                      value: '$visibility km',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.wind_power_outlined,
                      label: 'Gust',
                      value: '$gust m/s',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.thermostat,
                      label: 'Feels Like',
                      value: '$feelsLikeTempCel °C',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const Center(
                    child: Text(
                  'Powered by OpenWeather ©',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}







