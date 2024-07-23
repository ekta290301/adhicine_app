import 'package:adhicine_app/AddMedicinePage.dart';
import 'package:adhicine_app/Sign_in.dart';
import 'package:adhicine_app/auth_service.dart';
import 'package:adhicine_app/medicine_card.dart';
import 'package:adhicine_app/userProfile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<Map<dynamic, dynamic>> medicineData = [];

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  var isLogoutLoading = false;
  late String _userId;
  String selectedButton = "Saturday,Sep3";

  void onButtonPressed(String button) {
    setState(() {
      selectedButton = button;
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchMedicines();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
    getData();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        _connectivityResult = result.first;
        _showConnectionDialog(result.first);
      });
    });
  }

  void getData() async {
    databaseReference.child("users/$_userId/medicines").onValue.listen((event) {
      var data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> tempData = [];
        data.forEach((key, value) {
          tempData.add(Map<String, dynamic>.from(value));
        });
        setState(() {
          medicineData = tempData;
        });
      }
    });
  }
  

  Future<void> logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    FirebaseAuth auth = await FirebaseAuth.instance;
    try {
      // await auth.signOut();
      await AuthService().saveUserLoggedIn(loginState: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Sign_In_page()),
      );
    } catch (e) {
      print("Error signing out: $e");
    } finally {
      setState(() {
        isLogoutLoading = false;
      });
    }
  }

  void _showConnectionDialog(ConnectivityResult result) {
    String title = "Your Device is not connected";
    String message = "";
    switch (result) {
      case ConnectivityResult.mobile:
        message = "Mobile data connection is being used.";
        break;
      case ConnectivityResult.wifi:
        message = "Wi-Fi connection is being used.";
        break;
      case ConnectivityResult.bluetooth:
        message = "Bluetooth connection is being used.";
        break;
      case ConnectivityResult.ethernet:
        message = "Ethernet connection is being used.";
        break;
      case ConnectivityResult.vpn:
        message = "VPN connection is being used.";
        break;
      case ConnectivityResult.none:
        message = "No connection.";
        break;
      default:
        message = "Unknown connection.";
        break;
    }

    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi Harry!'),
              Text(
                "5 Medicines Left",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                SizedBox(height: 10),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextButton("Saturday, Sep 3"),
                      SizedBox(width: 8),
                      buildTextButton("Sunday, Sep 4"),
                      SizedBox(width: 8),
                      buildTextButton("Monday, Sep 5"),
                      SizedBox(width: 8),
                      buildTextButton("Tuesday, Sep 6"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicineData.length,
              itemBuilder: (context, index) {
                final medicine = medicineData[index];
                return MedicineCard(
                  medicine: medicine,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMedicinePage()),
                );
              },
              child: Icon(Icons.add),
            ),
            label: 'Add Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
        ],
      ),
    );
  }

  Widget buildTextButton(String text) {
    bool isSelected = selectedButton == text;
    return TextButton(
      onPressed: () {
        print("$text button pressed");
        onButtonPressed(text);
      },
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? Color.fromARGB(255, 4, 35, 5) : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Color.fromRGBO(145, 145, 159, 1),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomDialog({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset('images/robot0.jpg'),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Connecting via Bluetooth...')),
                    );
                  },
                  icon: Icon(Icons.bluetooth),
                  label: Text('Bluetooth'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Connecting via Wi-Fi...')),
                    );
                  },
                  icon: Icon(Icons.wifi),
                  label: Text('Wi-Fi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
