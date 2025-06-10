class MarvelApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final String? details;

  MarvelApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  factory MarvelApiException.fromResponse(Map<String, dynamic> response) {
    final status = response['status'] ?? 'Unknown error';
    final code = response['code']?.toString();
    final details = response['message'] ?? 'No details provided';

    return MarvelApiException(
      message: status,
      statusCode: response['code'] is int ? response['code'] : null,
      code: code,
      details: details,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('MarvelApiException: $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (code != null) {
      buffer.write(' (Code: $code)');
    }
    if (details != null) {
      buffer.write('\nDetails: $details');
    }
    return buffer.toString();
  }
} 