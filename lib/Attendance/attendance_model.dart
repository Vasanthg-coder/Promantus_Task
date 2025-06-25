class AttendanceModel {
  final String roll;
  final String status;

  AttendanceModel({required this.roll, required this.status});

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'status': status,
      };

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      roll: json['roll'],
      status: json['status'],
    );
  }
}
