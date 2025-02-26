import 'package:flutter/material.dart';
import 'package:flutter_share_preference_my_app/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int number = 0;
  String username = "User";

  void incrementNumber() async {
    number++;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("counter", number);
    setState(() {});
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    number = prefs.getInt("counter") ?? 0;
    username = prefs.getString("username") ?? "User";
    setState(() {});
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await prefs.remove("username");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Welcome to the App"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Hello, ${username}!",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You are logged in successfully.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
