import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddStudent/addStudent_provider.dart';
import 'Attendance/attendance_provider.dart';
import 'Auth/auth_provider.dart';
import 'Auth/login_view.dart';
import 'Auth/register_view.dart';
import 'Home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignupProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()..loadStudentsFromPrefs()),
          ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ],
        child: MaterialApp(
          title: 'Student App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: FutureBuilder<bool>(
            future: checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else {
                if (snapshot.data == true) {
                  return TeacherDashboard(teacherName: Provider.of<SignupProvider>(context).teacherName,);
                } else {
                  return const LoginScreen();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
