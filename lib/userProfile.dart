import 'package:adhicine_app/Sign_in.dart';
import 'package:adhicine_app/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userName = '';
  String userEmail = '';
  bool isLogoutLoading = false;
  late String _userId;
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'users1';
    saveUserData().then((_) => loadUserData());
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    FirebaseAuth auth = await FirebaseAuth.instance;
    try {
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

  Future<void> saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users1')
          .doc(user.uid)
          .get();
      userName = userData['username'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
    }
  }

  Color _backgroundColor = Colors.blue.shade50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 33,
                    backgroundImage: AssetImage(''), // Replace with your image
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take Care!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        'Richa Bose',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(right: 270),
              child: Text(
                "Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
              ),
              title: Text('Notification'),
              subtitle: Text(
                'Check your medicine notification',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('Sound'),
              subtitle: Text(
                'Ring, Silent, Vibrate',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Manage Your Account'),
              subtitle: Text(
                'Password, Email ID, Phone Number',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
              subtitle: Text(
                'Check your medicine notification',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
              subtitle: Text(
                'Check your medicine notification',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(right: 270),
              child: Text(
                "Device",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.blue.shade50,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _backgroundColor = Colors.white;
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.bluetooth),
                        title: Text('Connect'),
                        subtitle: Text('Bluetooth, Wi-Fi'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _backgroundColor = Colors.white;
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.volume_up),
                        title: Text('Sound Option'),
                        subtitle: Text('Ring, Silent, Vibrate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Caretakers: 03',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile1.jpg'),
                        ),
                        Text("Dipa Lina"),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile2.jpg'),
                        ),
                        Text("Roz sadi"),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile3.jpg'),
                        ),
                        Text("Survy"),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.add),
                        ),
                        Text("Add"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: 330,
              padding: EdgeInsets.all(16.0),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Add Your Doctor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Or use invite link',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Terms of Use'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Rate Us'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Share'),
              onTap: () {},
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    logOut();
                  },
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
