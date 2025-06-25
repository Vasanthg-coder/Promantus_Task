import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addStudent_provider.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final dobController = TextEditingController();

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Add New Student", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField("Student Name", provider.nameController),
                SizedBox(height: 16),
                buildTextField("Roll Number", provider.rollController, keyboardType: TextInputType.number),
                SizedBox(height: 16),
                buildTextField("Parent Name", provider.parentController),
                SizedBox(height: 16),
                buildDOBField(context),
                SizedBox(height: 16),
                buildDropdown("Gender", provider.selectedGender, ['Male', 'Female', 'Other'], (val) {
                  provider.selectedGender = val!;
                  provider.notifyListeners();
                }),
                SizedBox(height: 16),
                buildDropdown("Class", provider.selectedClass, provider.classList, (val) {
                  provider.selectedClass = val!;
                  provider.notifyListeners();
                }),
                SizedBox(height: 16),
                buildDropdown("Section", provider.selectedSection, provider.sectionList, (val) {
                  provider.selectedSection = val!;
                  provider.notifyListeners();
                }),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.dobController.text = dobController.text;
                      provider.addStudent(context);
                    }
                  },
                  child: Text("Add Student", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.trim().isEmpty ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget buildDOBField(BuildContext context) {
    return TextFormField(
      controller: dobController,
      readOnly: true,
      validator: (value) => value == null || value.isEmpty ? 'Date of Birth is required' : null,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2010),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
      },
      decoration: InputDecoration(
        labelText: "Date of Birth",
        labelStyle: TextStyle(color: Colors.blueAccent),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String selectedValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.blueAccent)),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            underline: SizedBox(),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
            items: options.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
