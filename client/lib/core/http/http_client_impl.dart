import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class HttpClient {
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });
}

class HttpClientImpl implements HttpClient {
  final http.Client client;

  HttpClientImpl(this.client);

  @override
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }
}
