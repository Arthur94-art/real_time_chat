import 'dart:io';

import 'package:real_time_chat/core/config/api_config.dart';
import 'package:real_time_chat/core/error/exeptions.dart';
import 'package:real_time_chat/core/http/http_client_impl.dart';
import 'package:real_time_chat/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String username);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl(this.httpClient);

  @override
  Future<AuthModel> login(String username) async {
    try {
      final response = await httpClient.post(
        '${ApiConfig.baseUrl}/auth/login',
        headers: {'Content-Type': 'application/json'},
        body: {'username': username},
      );

      return AuthModel.fromJson(response);
    } on SocketException catch (_) {
      throw const ServerException(
          'Failed to connect to the server. Please check your network connection.');
    } catch (e) {
      throw ServerException('Failed to login: $e');
    }
  }
}
