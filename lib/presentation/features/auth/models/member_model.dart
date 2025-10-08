/// Model for Member (User) data
class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String department;
  final String employeeCode;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.department,
    required this.employeeCode,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Check if user is admin
  bool get isAdmin => role == 'ADMIN';

  /// Check if user is security
  bool get isSecurity => role == 'SECURITY';

  /// Check if user is active
  bool get isActive => status == 'active';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      employeeCode: json['employeeCode'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'email': email,
      'department': department,
      'employeeCode': employeeCode,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? department,
    String? employeeCode,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      department: department ?? this.department,
      employeeCode: employeeCode ?? this.employeeCode,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model for Login Response
class LoginResponse {
  final bool success;
  final String message;
  final Member data;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Member.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'token': token,
    };
  }
}
