import 'package:domain/auth.dart';
import 'package:json_annotation/json_annotation.dart';

import 'profile_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    super.email,
    required super.role,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final ProfileModel? profile;
}
