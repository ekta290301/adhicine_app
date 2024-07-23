import 'package:adhicine_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  double progressValue = 0.0;

  final List<String> compartments = ["1", "2", "3", "4", "5", "6"];
  final List<Color> colours = [
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.yellow
  ];
  final List<Map<String, dynamic>> typeIcons = [
    {
      "type": "Tablet",
      "icon": Icons.tablet,
    },
    {"type": "Capsule", "icon": Icons.castle},
    {"type": "Cream", "icon": Icons.local_pharmacy},
    {"type": "Liquid", "icon": Icons.liquor},
  ];
  final List<String> times = ['Before Food', 'After Food', 'At Bedtime'];
  String? selectedCompartment;
  Color? selectedColour;
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;
  String? frequency = 'Everyday';
  String? timesADay = 'Three Times';
  String? selectedTime = 'Before Food';
  int quantity = 1;
  TextEditingController quantityController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  late String _userId;
  bool isListVisible = false;

  @override
  void initState() {
    super.initState();
    quantityController.text = quantity.toString();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
    checkIfListExists();
  }

  void checkIfListExists() async {
    DataSnapshot snapshot =
        await databaseReference.child("users/$_userId/medicines").get();
    if (snapshot.exists) {
      setState(() {
        isListVisible = true;
      });
    } else {
      setState(() {
        isListVisible = false;
      });
    }
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      quantityController.text = quantity.toString();
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        quantityController.text = quantity.toString();
      });
    }
  }

  void saveMedicineData() {
    databaseReference.child("users/$_userId/medicines").push().set({
      'compartment': selectedCompartment,
      'colour': selectedColour?.value,
      'type': selectedType,
      'quantity': quantity,
      'startDate': startDate != null
          ? DateFormat('dd/MM/yyyy').format(startDate!)
          : null,
      'endDate':
          endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : null,
      'frequency': frequency,
      'timesADay': timesADay,
      'selectedTime': selectedTime,
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicines'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Search Medicine Name",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
              ),
            ),
            SizedBox(height: 10.0),
            Text('Compartment'),
            SizedBox(height: 10.0),
            SizedBox(
              height: 50.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: compartments.length,
                itemBuilder: (context, index) {
                  final compartment = compartments[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCompartment = compartment;
                      });
                    },
                    child: Container(
                      width: 50.0,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: selectedCompartment == compartment
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          compartment,
                          style: TextStyle(
                            color: selectedCompartment == compartment
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
            Text('Colour'),
            SizedBox(height: 10.0),
            SizedBox(
              height: 50.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colours.length,
                itemBuilder: (context, index) {
                  final colour = colours[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColour = colour;
                      });
                    },
                    child: Container(
                      width: 50.0,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: colour,
                        border: selectedColour == colour
                            ? Border.all(color: Colors.black, width: 2.0)
                            : null,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
            Text('Type'),
            SizedBox(height: 10.0),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: typeIcons.length,
                      itemBuilder: (context, index) {
                        final type = typeIcons[index]["type"];
                        final icon = typeIcons[index]["icon"];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = type;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            margin: EdgeInsets.only(right: 10.0),
                            // decoration: BoxDecoration(
                            //   color: selectedType == type
                            //       ? Colors.blue.withOpacity(0.5)
                            //       : Colors.grey.withOpacity(0.2),
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: selectedType == type
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  type,
                                  style: TextStyle(
                                    color: selectedType == type
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Text('Quantity'),
            SizedBox(height: 10.0),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey))),
                    controller: quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        quantity = int.parse(value);
                      });
                    },
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: decrementQuantity,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: incrementQuantity,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Total Count"),
                Spacer(),
                Container(
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text('${(progressValue * 100).toInt()}'))),
              ],
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: progressValue,
                  onChanged: (newValue) {
                    setState(() {
                      progressValue = newValue;
                    });
                  },

                  min: 0.0,
                  max: 1.0,
                  divisions: 100, // Adjust this for finer control
                  label: '${(progressValue * 100).toInt()}%',
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('Set Date'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          startDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        startDate != null
                            ? DateFormat('dd/MM/yyyy').format(startDate!)
                            : 'Today',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          endDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        endDate != null
                            ? DateFormat('dd/MM/yyyy').format(endDate!)
                            : 'End Date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text('Frequency of Days'),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: frequency,
              items: ['Everyday', 'Every 2 Days', 'Weekly'].map((freq) {
                return DropdownMenuItem(
                  value: freq,
                  child: Text(freq),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  frequency = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            Text('How many times a Day'),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: timesADay,
              items: ['One Time', 'Two Times', 'Three Times'].map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  timesADay = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.history_rounded),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Dose 1"),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.history_rounded),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Dose 2"),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.history_rounded),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Dose 3"),
                  ],
                ),
                Divider(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: times.map((time) {
                  bool isSelected = selectedTime == time;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            isSelected ? Colors.black : Colors.black,
                        backgroundColor: isSelected
                            ? Color.fromARGB(255, 159, 204, 240)
                            : Color.fromARGB(255, 227, 237, 246), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(time),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  saveMedicineData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home_page()),
                  );
                },
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
