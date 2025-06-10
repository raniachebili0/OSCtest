import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class MarvelApiService {
  final String baseUrl = "https://gateway.marvel.com/v1/public";

  final String publicKey = '1e547dbf5528661feaffab03d3b7412c';
  final String privateKey = '84a68b6c81e8752d7f2b57e77890a4dafe2b241e';

  String generateHash(String timestamp) {
    final String toBeHashed = timestamp + privateKey + publicKey;
    return md5.convert(utf8.encode(toBeHashed)).toString();
  }

  Uri buildUri(String endpoint, [Map<String, String>? extraParams]) {
    final String ts = DateTime.now().millisecondsSinceEpoch.toString();
    final String hash = generateHash(ts);

    final Map<String, String> queryParams = {
      'ts': ts,
      'apikey': publicKey,
      'hash': hash,
      if (extraParams != null) ...extraParams,
    };

    return Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
  }

  Future<List<dynamic>> getCharacters({int limit = 20}) async {
    final url = buildUri('/characters', {
      'limit': limit.toString(),
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']['results'];
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<List<dynamic>> getCharacterComics(int characterId, {int limit = 10}) async {
    final url = buildUri('/characters/$characterId/comics', {
      'limit': limit.toString(),
      'orderBy': '-onsaleDate',
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']['results'];
    } else {
      throw Exception('Failed to load comics');
    }
  }
}
