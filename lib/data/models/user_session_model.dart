import 'package:equatable/equatable.dart';

/// Role of a logged-in user. Rights are derived from the role.
/// Unknown/missing role falls back to [member] (least privilege).
enum UserRole {
  main,
  head,
  member;

  static UserRole fromString(String? v) {
    switch (v?.toLowerCase()) {
      case 'main':
      case 'owner':
      case 'admin':
        return UserRole.main;
      case 'head':
        return UserRole.head;
      default:
        return UserRole.member;
    }
  }

  bool get canCreateForm => this == UserRole.main;
  bool get canAssignDepartments => this == UserRole.main;
  bool get canManageUsers => this == UserRole.main;
  bool get canEditForm => this == UserRole.main || this == UserRole.head;
  bool get canViewResponses => this == UserRole.main || this == UserRole.head;
  bool get canFillForm => true;
  bool get canCreateMembers => this == UserRole.main || this == UserRole.head;
  bool get canManageMembers => this == UserRole.main || this == UserRole.head;
}

class DepartmentModel extends Equatable {
  final String id;
  final String name;

  const DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(id: json['id'].toString(), name: '${json['name'] ?? ''}');

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class UserSession extends Equatable {
  final String userId;
  final String email;
  final String? orgId;
  final UserRole role;
  final List<DepartmentModel> departments;

  const UserSession({
    required this.userId,
    required this.email,
    required this.role,
    this.orgId,
    this.departments = const [],
  });

  Set<String> get departmentIds => departments.map((d) => d.id).toSet();

  /// Main user sees everything; head/member only forms of their departments.
  bool canSeeForm(Iterable<String> formDepartmentIds) =>
      role == UserRole.main ||
          formDepartmentIds.any(departmentIds.contains);

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    userId: '${json['user_id']}',
    email: '${json['email'] ?? ''}',
    orgId: json['org_id']?.toString(),
    role: UserRole.fromString(json['role']?.toString()),
    departments: ((json['departments'] as List?) ?? [])
        .map((e) => DepartmentModel.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'email': email,
    'org_id': orgId,
    'role': role.name,
    'departments': departments.map((d) => d.toJson()).toList(),
  };

  @override
  List<Object?> get props => [userId, email, orgId, role, departments];
}