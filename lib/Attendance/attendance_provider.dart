import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  final Map<String, String> _statusMap = {}; 

  // Track if boarding/deboarding submitted for class-section
  final Map<String, bool> _boardingSubmitted = {}; // "class-section" -> true
  final Map<String, bool> _deBoardingSubmitted = {}; // "class-section" -> true

  String _sectionKey(String className, String section) => "$className-$section";
  String _statusKey(String className, String section, String roll) =>
      "$className-$section-$roll";

  /// Check if boarding submitted for this class-section
  bool isBoardingSubmittedFor(String className, String section) {
    return _boardingSubmitted[_sectionKey(className, section)] ?? false;
  }

  /// Check if deboarding submitted for this class-section
  bool isDeBoardingSubmittedFor(String className, String section) {
    return _deBoardingSubmitted[_sectionKey(className, section)] ?? false;
  }

  /// Get status for a student in specific class-section
  String getStatusFor(String roll, String className, String section) {
    return _statusMap[_statusKey(className, section, roll)] ?? '';
  }

  /// Update status for a student in specific class-section
  void updateStatus(String roll, String className, String section, String status) {
    _statusMap[_statusKey(className, section, roll)] = status;
    notifyListeners();
  }

  /// Submit boarding for class-section
  void submitBoarding(String className, String section) {
    _boardingSubmitted[_sectionKey(className, section)] = true;
    notifyListeners();
  }

  /// Submit deboarding for class-section
  void submitDeBoarding(String className, String section) {
    _deBoardingSubmitted[_sectionKey(className, section)] = true;
    notifyListeners();
  }
}
