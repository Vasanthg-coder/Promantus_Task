import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home_view.dart';
import 'auth_model.dart';

class SignupProvider extends ChangeNotifier {
  // Signup controllers
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login controllers
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  bool isLoading = false;
  bool isLoginLoading = false;
   String teacherName='';
  // Register new user
  Future<void> saveToPrefs(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2)); // simulate delay

    final newUser = UserModel(
      username: usernameController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Retrieve existing users
    final List<String> storedUsers = prefs.getStringList('users') ?? [];

    // Convert new user to JSON and add to list
    storedUsers.add(jsonEncode(newUser.toJson()));
    await prefs.setStringList('users', storedUsers);

    isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup successful")),
    );

    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context); // back to login
  }

  // Login user
 Future<void> login(BuildContext context) async {
  isLoginLoading = true;
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  await Future.delayed(Duration(seconds: 2)); // simulate delay

  final storedUsers = prefs.getStringList('users') ?? [];

  final inputUsername = loginUsernameController.text.trim();
  final inputPassword = loginPasswordController.text.trim();

  if (storedUsers.isEmpty) {
    isLoginLoading = false;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No users registered yet")),
    );
    return;
  }

  bool found = false;

  for (String userJson in storedUsers) {
    final user = UserModel.fromJson(jsonDecode(userJson));
    if (user.username == inputUsername && user.password == inputPassword) {
      found = true;
      teacherName=user.name;
      break;
    }
  }

  isLoginLoading = false;
  notifyListeners();

  if (found) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login successful")),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setBool('isLoggedIn', true);
      await Future.delayed(Duration(milliseconds: 300)); // optional delay
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => TeacherDashboard(
      teacherName: teacherName,
    ),
  ),
);

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid credentials")),
    );
  }
}

}
