import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../models/MarvelCharacter.dart';

class MarvelApiException implements Exception {
  final String message;
  final int? statusCode;

  MarvelApiException({required this.message, this.statusCode});

  @override
  String toString() => 'MarvelApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class MarvelApiService {
  static const String _baseUrl = 'https://gateway.marvel.com/v1/public';
  static const String _publicKey = '1e547dbf5528661feaffab03d3b7412c';
  static const String _privateKey = '84a68b6c81e8752d7f2b57e77890a4dafe2b241e';

  Uri buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _generateHash(timestamp);

    final params = {
      'apikey': _publicKey,
      'ts': timestamp,
      'hash': hash,
      if (queryParams != null) ...queryParams,
    };

    return Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);
  }

  String _generateHash(String timestamp) {
    final String toBeHashed = timestamp + _privateKey + _publicKey;
    return md5.convert(utf8.encode(toBeHashed)).toString();
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['code'] != null && body['code'] != 200) {
        throw MarvelApiException(
          message: body['status'] ?? 'Unknown error',
          statusCode: body['code'],
        );
      }
      return body;
    } else {
      throw MarvelApiException(
        message: 'API request failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<MarvelCharacter>> getCharacters({int limit = 20}) async {
    try {
      final url = buildUri('/characters', {
        'limit': limit.toString(),
      });

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw MarvelApiException(
            message: 'Request timed out',
            statusCode: HttpStatus.requestTimeout,
          );
        },
      );

      final body = await _handleResponse(response);
      final results = body['data']['results'] as List<dynamic>;
      return results.map((json) => MarvelCharacter.fromJson(json)).toList();
    } on MarvelApiException {
      rethrow;
    } catch (e) {
      throw MarvelApiException(
        message: 'Failed to load characters: ${e.toString()}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCharacterComics(int characterId, {int limit = 10}) async {
    try {
      final url = buildUri('/characters/$characterId/comics', {
        'limit': limit.toString(),
        'orderBy': '-onsaleDate',
      });

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw MarvelApiException(
            message: 'Request timed out',
            statusCode: 408,
          );
        },
      );

      final body = await _handleResponse(response);
      return body['data']['results'] as List<Map<String, dynamic>>;
    } on MarvelApiException {
      rethrow;
    } catch (e) {
      throw MarvelApiException(
        message: 'Failed to load comics: ${e.toString()}',
      );
    }
  }
}
