import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AddStudent/addStudent_provider.dart';
import '../Attendance/attendance_provider.dart';

class StudentListScreen extends StatelessWidget {
  final String className;
  final String section;

  const StudentListScreen({
    super.key,
    required this.className,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<StudentProvider>(context)
        .studentList
        .where((s) => s.className == className && s.section == section)
        .toList();

    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    final isBoardedSubmitted = attendanceProvider.isBoardingSubmittedFor(className, section);
    final isDeBoardedSubmitted = attendanceProvider.isDeBoardingSubmittedFor(className, section);

    return Scaffold(
      appBar: AppBar(
        title: Text("Class $className - $section"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: students.isEmpty
                ? Center(child: Text("No students in this class"))
                : ListView.builder(
                    itemCount: students.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final status = attendanceProvider.getStatusFor(student.roll, className, section);

                      bool enableBoarded = !isBoardedSubmitted;
                      bool enableDeBoarded = isBoardedSubmitted &&
                          (status == 'Boarded' || status == 'De Boarded');
                      bool enableNotBoarded = !isBoardedSubmitted;

                      String message = '';
                      if (!isBoardedSubmitted) {
                        message = "Mark 'Boarded' or 'Not Boarded' before submitting.";
                      } else if (status == 'Boarded') {
                        message = "Now you can mark as 'De Boarded' if needed.";
                      } else if (status == 'Not Boarded') {
                        message = "This student was marked as Not Boarded.";
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${student.name} (${student.roll})",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Parent: ${student.parentName}"),
                            Text("DOB: ${student.dob}"),
                            Text("Gender: ${student.gender}"),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                buildOption(
                                  label: "Boarded",
                                  selected: status == 'Boarded',
                                  enabled: enableBoarded,
                                  onTap: () => attendanceProvider.updateStatus(student.roll, className, section, 'Boarded'),
                                ),
                                SizedBox(width: 8),
                                buildOption(
                                  label: "De Boarded",
                                  selected: status == 'De Boarded',
                                  enabled: enableDeBoarded,
                                  onTap: () => attendanceProvider.updateStatus(student.roll, className, section, 'De Boarded'),
                                ),
                                SizedBox(width: 8),
                                buildOption(
                                  label: "Not Boarded",
                                  selected: status == 'Not Boarded',
                                  enabled: enableNotBoarded,
                                  onTap: () => attendanceProvider.updateStatus(student.roll, className, section, 'Not Boarded'),
                                ),
                              ],
                            ),
                            if (message.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600]),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (!isBoardedSubmitted)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        attendanceProvider.submitBoarding(className, section);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Boarding submitted")),
                        );
                      },
                      child: Text("Submit Boarding", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                if (isBoardedSubmitted && !isDeBoardedSubmitted)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        attendanceProvider.submitDeBoarding(className, section);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("DeBoarding submitted")),
                        );
                      },
                      child: Text("Submit DeBoarding", style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOption({
    required String label,
    required bool selected,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4, // Blurred look if disabled
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
