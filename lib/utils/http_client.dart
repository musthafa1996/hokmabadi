import 'dart:typed_data';
import 'dart:convert';

import '../../exceptions/unauthenticated_exception.dart';
import 'package:http/http.dart' as http;

import '../exceptions/unauthenticated_exception.dart';

class AppHttpClient extends http.BaseClient {
  final _client = http.Client();

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.delete(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.head(url, headers: headers);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.patch(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.post(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.put(url, headers: headers, body: body);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _client.read(url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    return _client.readBytes(url, headers: headers);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _client.send(request);
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }
    return response;
  }
}
