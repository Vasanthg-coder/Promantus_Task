import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AddStudent/add_student.dart';
import '../AddStudent/addStudent_provider.dart';
import '../Attendance/student_list.dart';
import '../Auth/login_view.dart';

class TeacherDashboard extends StatefulWidget {
  final String teacherName;

  const TeacherDashboard({super.key, required this.teacherName});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<StudentProvider>(context, listen: false).loadStudentsFromPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    // Group students by class + section
    final classGroups = <String, List<Map<String, String>>>{};
    for (var student in studentProvider.studentList) {
      final key = "${student.className} - ${student.section}";
      classGroups.putIfAbsent(key, () => []);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
            // ✅ Floating Action Button for Logout
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.logout,color: Colors.white,),
        tooltip: 'Logout',
        onPressed: () {
          studentProvider.logout(context);
            
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, ${widget.teacherName} 👋",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text("Total Students", style: TextStyle(color: Colors.white70)),
                                SizedBox(height: 6),
                                Text("${studentProvider.studentList.length}",
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),

              // My Classes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Classes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See All", style: TextStyle(color: Colors.blueAccent)),
                ],
              ),
              SizedBox(height: 16),

              classGroups.isEmpty
                  ? Center(child: Text("No Classes Found", style: TextStyle(color: Colors.grey)))
                  : Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: classGroups.keys.length,
                        itemBuilder: (context, index) {
                          final classKey = classGroups.keys.elementAt(index);
                          final parts = classKey.split(" - ");
                          final className = parts[0];
                          final section = parts[1];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudentListScreen(
                                    className: className,
                                    section: section,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 250,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   CircleAvatar(
  radius: 20,
  backgroundColor: Colors.blueAccent,
  child: Icon(
    Icons.class_,           // You can change this to any other icon
    color: Colors.white,
    size: 20,
  ),
),
                                    SizedBox(height: 8),
                                    Text("$className - $section",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => StudentListScreen(
                                              className: className,
                                              section: section,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("View Students", style: TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 24),

              // Add New Student Button
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddStudentPage()),
                    );
                    studentProvider.loadStudentsFromPrefs();
                  },
                  icon: Icon(Icons.person_add_alt_1, color: Colors.white),
                  label: Text("Add New Student", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
