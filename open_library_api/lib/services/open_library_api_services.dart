import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../exceptions/open_library_exception.dart';
import '../models/open_library_response.dart';
import 'http_error_handler.dart';

class OpenLibraryApiServices {
  const OpenLibraryApiServices({
    required this.httpClient,
  });

  final http.Client httpClient;

  Future<OpenLibrary> getOpenLibraryResponse(
      Map<String, String> searchValues, int page) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/search.json',
      queryParameters: {
        ...searchValues,
        'page': page.toString(),
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw OpenLibraryException('No Documents Were Found');
      }

      final openLibrary = OpenLibrary.fromJson(responseBody);

      return openLibrary;
    } catch (e) {
      rethrow;
    }
  }
}
