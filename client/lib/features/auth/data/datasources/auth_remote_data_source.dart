import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:real_time_chat/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String username);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthModel> login(String username) async {
    final response = await client.post(
      Uri.parse('http://localhost:3000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
