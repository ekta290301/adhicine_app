import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final Map<dynamic, dynamic> medicine;

  MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    String medicineName = medicine['type'] ?? 'Medicine Name';
    String doseTime = medicine['selectedTime'] ?? 'Before Breakfast';
    String status = 'Taken';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: ListTile(
          leading: Icon(Icons.medication, size: 40),
          title: Text('$medicineName 500mg Tablet'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doseTime),
              Text(''),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              Text(status),
            ],
          ),
        ),
      ),
    );
  }
}
