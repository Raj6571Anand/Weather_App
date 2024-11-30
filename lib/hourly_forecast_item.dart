import 'package:flutter/material.dart';
class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String value;


  const HourlyForecastItem({super.key,
    required this.icon,
    required this.value,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '$value °C',
              style: const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}