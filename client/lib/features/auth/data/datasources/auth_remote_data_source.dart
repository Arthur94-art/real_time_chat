import 'dart:io';

import 'package:real_time_chat/core/config/api_config.dart';
import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:real_time_chat/core/http/http_client_impl.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl(this.httpClient);

  @override
  Future<UserModel> login(String username) async {
    try {
      final response = await httpClient.post(
        '${ApiConfig.baseUrl}/auth/login',
        headers: {'Content-Type': 'application/json'},
        body: {'username': username},
      );

      return UserModel.fromJson(response);
    } on SocketException catch (_) {
      throw const ServerException(
          'Failed to connect to the server. Please check your network connection.');
    } catch (e) {
      throw ServerException('Failed to login: $e');
    }
  }
}
