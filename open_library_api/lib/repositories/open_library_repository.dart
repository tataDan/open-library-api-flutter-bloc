import '../exceptions/open_library_exception.dart';
import '../models/custom_error.dart';
import '../models/open_library_response.dart';
import '../services/open_library_api_services.dart';

class OpenLibraryRepository {
  const OpenLibraryRepository({
    required this.openLibraryApiServices,
  });

  final OpenLibraryApiServices openLibraryApiServices;

  Future<OpenLibrary> fetchOpenLibrary(
      Map<String, String> searchValues, int page) async {
    try {
      final OpenLibrary openLibrary = await openLibraryApiServices
          .getOpenLibraryResponse(searchValues, page);

      return openLibrary;
    } on OpenLibraryException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
