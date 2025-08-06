import 'package:dio/dio.dart';
import 'package:onmitrix/models/investment.dart';
import 'package:onmitrix/models/login_response.dart';
import 'package:onmitrix/services/api/api_client.dart';

class ApiService {
  final Dio _dio = ApiClient().dio;

  // Auth endpoints
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      await _dio.post('/auth/signup', data: {
        'email': email,
        'password': password,
        'name': name,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Investment endpoints
  Future<List<Investment>> getInvestments() async {
    try {
      final response = await _dio.get('/investments');
      return (response.data as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Investment> getInvestment(String id) async {
    try {
      final response = await _dio.get('/investments/$id');
      return Investment.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addInvestment(Investment investment) async {
    try {
      await _dio.post('/investments', data: investment.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateInvestment(Investment investment) async {
    try {
      await _dio.put(
        '/investments/${investment.id}',
        data: investment.toJson(),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteInvestment(String id) async {
    try {
      await _dio.delete('/investments/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? 'Unknown error';
          return Exception('Server error ($statusCode): $message');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('An unexpected error occurred');
  }
}