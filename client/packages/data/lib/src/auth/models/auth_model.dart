import 'package:domain/auth.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../auth.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends AuthEntity {
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  AuthModel({required super.token, required this.user});

  final UserModel user;
}
