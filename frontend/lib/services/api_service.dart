import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/category.dart' as models;
import '../models/location.dart';
import '../models/cuisine.dart';

class ApiService {
  late final Dio _dio;
  final String baseUrl;

  ApiService()
    : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api' {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(
          milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000'),
        ),
        receiveTimeout: Duration(
          milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000'),
        ),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');
          print('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  // Get all categories
  Future<List<models.Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => models.Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories');
    }
  }

  // Get all countries
  Future<List<Location>> getCountries() async {
    try {
      final response = await _dio.get('/locations/countries');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching countries: $e');
      throw Exception('Failed to load countries');
    }
  }

  // Get states by country
  Future<List<Location>> getStatesByCountry(String countryId) async {
    try {
      final response = await _dio.get('/locations/states/$countryId');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching states: $e');
      throw Exception('Failed to load states');
    }
  }

  // Get cities by state
  Future<List<Location>> getCitiesByState(String stateId) async {
    try {
      final response = await _dio.get('/locations/cities/$stateId');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching cities: $e');
      throw Exception('Failed to load cities');
    }
  }

  // Get event types
  Future<List<String>> getEventTypes() async {
    try {
      final response = await _dio.get('/requests/event-types');
      final List<dynamic> data = response.data['data'];
      return data.cast<String>();
    } catch (e) {
      print('Error fetching event types: $e');
      throw Exception('Failed to load event types');
    }
  }

  // Get cuisines
  Future<List<Cuisine>> getCuisines() async {
    try {
      final response = await _dio.get('/requests/cuisines');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Cuisine.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching cuisines: $e');
      throw Exception('Failed to load cuisines');
    }
  }

  // Submit booking request
  Future<Map<String, dynamic>> submitRequest(
    Map<String, dynamic> requestData,
  ) async {
    try {
      print('Submitting request: $requestData');

      final response = await _dio.post('/requests', data: requestData);
      return response.data;
    } catch (e) {
      print('Error submitting request: $e');
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response!.data;
          throw Exception(errorData['message'] ?? 'Failed to submit request');
        }
      }
      throw Exception('Failed to submit request');
    }
  }

  // Submit request with files
  Future<Map<String, dynamic>> submitRequestWithFiles(
    Map<String, dynamic> requestData,
    List<String> filePaths,
  ) async {
    try {
      FormData formData = FormData();

      // Add text fields
      requestData.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            formData.fields.add(MapEntry(key, value.join(',')));
          } else {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        }
      });

      // Add files
      for (String filePath in filePaths) {
        formData.files.add(
          MapEntry('images', await MultipartFile.fromFile(filePath)),
        );
      }

      final response = await _dio.post('/requests', data: formData);
      return response.data;
    } catch (e) {
      print('Error submitting request with files: $e');
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response!.data;
          throw Exception(errorData['message'] ?? 'Failed to submit request');
        }
      }
      throw Exception('Failed to submit request');
    }
  }
}
