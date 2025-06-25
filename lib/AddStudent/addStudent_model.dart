class StudentModel {
  final String name;
  final String roll;
  final String parentName;
  final String dob;
  final String gender;
  final String className;
  final String section;

  StudentModel({
    required this.name,
    required this.roll,
    required this.parentName,
    required this.dob,
    required this.gender,
    required this.className,
    required this.section,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'roll': roll,
        'parentName': parentName,
        'dob': dob,
        'gender': gender,
        'className': className,
        'section': section,
      };

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        name: json['name'],
        roll: json['roll'],
        parentName: json['parentName'],
        dob: json['dob'],
        gender: json['gender'],
        className: json['className'],
        section: json['section'],
      );
}
