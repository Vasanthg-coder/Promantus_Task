import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/login_view.dart';
import 'addStudent_model.dart';

class StudentProvider with ChangeNotifier {
  // Form controllers
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final parentController = TextEditingController();
  final dobController = TextEditingController();

  // Dropdown selections
  String selectedClass = 'Class 1';
  String selectedSection = 'A';
  String selectedGender = 'Male';

  // Dropdown options
  List<String> classList = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10'
  ];

  List<String> sectionList = ['A', 'B', 'C'];
  List<String> genderList = ['Male', 'Female', 'Other'];

  // Student list
  List<StudentModel> studentList = [];

  // Add a new student
  Future<void> addStudent(BuildContext context) async {
    final newStudent = StudentModel(
      name: nameController.text.trim(),
      roll: rollController.text.trim(),
      parentName: parentController.text.trim(),
      dob: dobController.text.trim(),
      gender: selectedGender,
      className: selectedClass,
      section: selectedSection,
    );

    studentList.add(newStudent);
    await saveToPrefs();

    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Student added successfully")),
    );

    // Clear form
    clearFields();

    notifyListeners();
  }

  // Save student list to SharedPreferences
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(studentList.map((e) => e.toJson()).toList());
    await prefs.setString('students', encoded);
  }

  // Load student list from SharedPreferences
  Future<void> loadStudentsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('students');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      studentList = decoded.map((e) => StudentModel.fromJson(e)).toList();
    }
    notifyListeners();
  }

  void clearFields() {
    nameController.clear();
    rollController.clear();
    parentController.clear();
    dobController.clear();
    selectedClass = classList.first;
    selectedSection = sectionList.first;
    selectedGender = genderList.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    parentController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.remove('isLoggedIn');
Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
  }
}
