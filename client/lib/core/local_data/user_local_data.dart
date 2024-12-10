import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';
import 'package:real_time_chat/features/auth/domain/entities/user_entitiy.dart';

class UserLocalData {
  final Box<UserModel> box;

  UserLocalData(this.box);

  Future<void> saveUser(UserEntity user) async {
    final hiveUser = UserModel.fromEntity(user);
    await box.put('currentUser', hiveUser);
  }

  UserEntity? getCurrentUser() {
    final hiveUser = box.get('currentUser');
    if (hiveUser != null) {
      return hiveUser.toEntity();
    }
    return null;
  }

  Future<void> clearUser() async {
    await box.delete('currentUser');
  }
}

Future<void> logHiveData<T>(String boxName) async {
  try {
    final box = Hive.box<T>(boxName);
    log('Logging data from Hive box: $boxName');

    if (box.isEmpty) {
      log('Box "$boxName" is empty.');
    } else {
      for (var key in box.keys) {
        final value = box.get(key);
        log('Key: $key, Value: ${(value as UserModel).username}');
      }
    }
  } catch (e) {
    log('Failed to log Hive data: $e');
  }
}
