import '../../domain/entities/leave_type.dart';

class LeaveTypeModel extends LeaveType {
  const LeaveTypeModel({
    required super.id,
    required super.name,
    required super.code,
    required super.isPaid,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      isPaid: json['is_paid'] == 1 || json['is_paid'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'is_paid': isPaid};
  }
}
