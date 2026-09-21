import 'package:groovkin/utils/json_parsers.dart';

enum InviteUiState { idle, loading, success, failure }

class InviteRecord {
  InviteRecord({
    this.id,
    this.inviteType,
    this.role,
    this.email,
    this.code,
    this.status,
    this.isActive = false,
    this.maxUses,
    this.usedCount,
    this.usedAt,
    this.expiresAt,
    this.createdAt,
    this.emailSent = false,
    this.emailError,
    this.shareText,
  });

  final int? id;
  final String? inviteType;
  final String? role;
  final String? email;
  final String? code;
  final String? status;
  final bool isActive;
  final int? maxUses;
  final int? usedCount;
  final String? usedAt;
  final String? expiresAt;
  final String? createdAt;
  final bool emailSent;
  final String? emailError;
  final String? shareText;

  factory InviteRecord.fromJson(Map<String, dynamic> json) {
    return InviteRecord(
      id: parseInt(json['id']),
      inviteType: parseString(json['invite_type']),
      role: parseString(json['role']),
      email: parseString(json['email']),
      code: parseString(json['code']),
      status: parseString(json['status']),
      isActive: parseBool(json['is_active'] ?? json['status'] == 'active'),
      maxUses: parseInt(json['max_uses']),
      usedCount: parseInt(json['used_count']),
      usedAt: parseString(json['used_at']),
      expiresAt: parseString(json['expires_at']),
      createdAt: parseString(json['created_at']),
      emailSent: parseBool(json['email_sent']),
      emailError: parseString(json['email_error']),
      shareText: parseString(json['share_text']),
    );
  }

  bool get createdSuccessfully =>
      (code != null && code!.isNotEmpty) || status == 'active';
}

InviteRecord? parseInviteRecord(dynamic payload) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  if (data.isEmpty) return null;
  return InviteRecord.fromJson(data);
}

List<InviteRecord> parseInviteList(dynamic payload) {
  final root = parseMap(payload) ?? {};
  dynamic data = root['data'] ?? root;
  if (data is Map) {
    data = data['data'] ?? data;
  }
  if (data is! List) return const [];
  return data
      .whereType<Map>()
      .map((item) => InviteRecord.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
