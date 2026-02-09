import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:app_platform_core/core.dart';

import '../token/token_provider.dart';
import 'api_client.dart';

class HttpApiClient implements ApiClient {
  final String baseUrl;
  final http.Client client;
  final TokenProvider tokenProvider;
  final Duration timeout;

  HttpApiClient({
    required this.baseUrl,
    required this.client,
    required this.tokenProvider,
    this.timeout = const Duration(seconds: 30),
  });

  // =====================================================
  // GET
  // =====================================================

  @override
  Future<Result<T>> get<T>(
      String path, {
        Map<String, dynamic>? query,
        required JsonParser<T> parser,
      }) {
    final uri = Uri.parse('$baseUrl$path')
        .replace(queryParameters: query);

    return _request(
      method: _HttpMethod.get,
      uri: uri,
      parser: parser,
    );
  }

  // =====================================================
  // POST
  // =====================================================

  @override
  Future<Result<T>> post<T>(
      String path, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? query,
        required JsonParser<T> parser,
      }) {
    final uri = Uri.parse('$baseUrl$path')
        .replace(queryParameters: query);

    return _request(
      method: _HttpMethod.post,
      uri: uri,
      body: body,
      parser: parser,
    );
  }

  // =====================================================
  // PUT
  // =====================================================

  @override
  Future<Result<T>> put<T>(
      String path, {
        Map<String, dynamic>? body,
        required JsonParser<T> parser,
      }) {
    final uri = Uri.parse('$baseUrl$path');

    return _request(
      method: _HttpMethod.put,
      uri: uri,
      body: body,
      parser: parser,
    );
  }

  // =====================================================
  // PATCH
  // =====================================================

  @override
  Future<Result<T>> patch<T>(
      String path, {
        Map<String, dynamic>? body,
        required JsonParser<T> parser,
      }) {
    final uri = Uri.parse('$baseUrl$path');

    return _request(
      method: _HttpMethod.patch,
      uri: uri,
      body: body,
      parser: parser,
    );
  }

  // =====================================================
  // DELETE
  // =====================================================

  @override
  Future<Result<T>> delete<T>(
      String path, {
        required JsonParser<T> parser,
      }) {
    final uri = Uri.parse('$baseUrl$path');

    return _request(
      method: _HttpMethod.delete,
      uri: uri,
      parser: parser,
    );
  }

  // =====================================================
  // CORE REQUEST
  // =====================================================

  Future<Result<T>> _request<T>({
    required _HttpMethod method,
    required Uri uri,
    Map<String, dynamic>? body,
    required JsonParser<T> parser,
  }) async {
    try {
      final token = await tokenProvider.getToken();

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      http.Response response;

      Future<http.Response> send() {
        switch (method) {
          case _HttpMethod.post:
            return client.post(
              uri,
              headers: headers,
              body: body != null ? jsonEncode(body) : null,
            );

          case _HttpMethod.put:
            return client.put(
              uri,
              headers: headers,
              body: body != null ? jsonEncode(body) : null,
            );

          case _HttpMethod.patch:
            return client.patch(
              uri,
              headers: headers,
              body: body != null ? jsonEncode(body) : null,
            );

          case _HttpMethod.delete:
            return client.delete(uri, headers: headers);

          case _HttpMethod.get:
            return client.get(uri, headers: headers);
        }
      }

      response = await send().timeout(timeout);

      return _handleResponse(response, parser);
    } on SocketException {
      return Failure(const NoInternetError());
    } on TimeoutException {
      return Failure(const TimeoutError());
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }

  // =====================================================
  // RESPONSE HANDLER
  // =====================================================

  Result<T> _handleResponse<T>(
      http.Response response,
      JsonParser<T> parser,
      ) {
    final statusCode = response.statusCode;

    dynamic decoded;

    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }
    }

    // SUCCESS
    if (statusCode >= 200 && statusCode < 300) {
      return Success(parser(decoded));
    }

    // ERROR MESSAGE EXTRACTION
    String message = 'Something went wrong';

    if (decoded is Map<String, dynamic>) {
      message =
          decoded['message'] ??
              decoded['error'] ??
              message;
    }

    switch (statusCode) {
      case 401:
        return Failure(const UnauthorizedError());

      case 403:
        return Failure(const ForbiddenError());

      case 404:
        return Failure(const NotFoundError());

      case 422:
        return Failure(
          ValidationError(
            message,
            fields: decoded?['errors'],
          ),
        );

      default:
        return Failure(ServerError(statusCode, message));
    }
  }
}

// =====================================================
// HTTP METHOD ENUM
// =====================================================

enum _HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}
