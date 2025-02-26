import 'package:flutter/material.dart';
import 'package:flutter_share_preference_my_app/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form Key

  @override
  void initState() {
    super.initState();
    checkExistingUser();
  }

  void checkExistingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString("username");

    if (savedUsername != null) {
      setState(() {
        _usernameController.text = savedUsername;
      });
    }
  }

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return; // Validate inputs

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString("username");
    String? savedPassword = prefs.getString("password");

    String inputUsername = _usernameController.text.trim();
    String inputPassword = _passwordController.text.trim();

    if (savedUsername == null || savedPassword == null) {
      // Sign Up New User
      prefs.setString("username", inputUsername);
      prefs.setString("password", inputPassword);
      prefs.setBool("isLoggedIn", true);
      navigateToHome();
    } else {
      // Log In Existing User
      if (inputUsername == savedUsername && inputPassword == savedPassword) {
        prefs.setBool("isLoggedIn", true);
        navigateToHome();
      } else {
        showError("Invalid username or password.");
      }
    }
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In / Log In")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Attach Form Key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create an Account",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a username.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a password.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
