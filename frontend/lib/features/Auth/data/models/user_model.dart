import '../../../../core/common/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.designation,
    super.departmentId,
    super.employeeCode,
    super.phone,
    super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'employee',
      designation: json['designation'],
      departmentId: json['department_id']?.toString(),
      employeeCode: json['employee_code'],
      phone: json['phone'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'designation': designation,
      'department_id': departmentId,
      'employee_code': employeeCode,
      'phone': phone,
      'status': status,
    };
  }
}
