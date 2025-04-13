import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../models/cat_model.dart';

class CatService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ),
  );

  Future<Cat> fetchCatImage() async {
    try {
      final response = await _dio.get(
        'https://api.thecatapi.com/v1/images/search?has_breeds=true',
      );
      if (response.data != null && response.data.isNotEmpty) {
        return Cat.fromJson(response.data[0]);
      } else {
        throw ErrorDescription("Error while gaining cat data");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ErrorDescription("Network error: time limit exceeded");
      }
      throw ErrorDescription("Error while gaining cat image: $e");
    } catch (e) {
      throw ErrorDescription("Error while gaining cat image: $e");
    }
  }

  Future<Cat> fetchRandomCat() async {
    try {
      final cat = await fetchCatImage();
      final breedResponse = await _dio.get(
        'https://api.thecatapi.com/v1/images/${cat.id}/breeds',
      );
      if (breedResponse.data != null && breedResponse.data.isNotEmpty) {
        final breedData = breedResponse.data[0];
        cat.breed = breedData['name'] ?? 'Unknown';
        cat.temperament = breedData['temperament'] ?? 'Unknown';
        cat.origin = breedData['origin'] ?? 'Unknown';
        cat.description =
            breedData['description'] ?? 'No description available';
        cat.lifeSpan = breedData['life_span'] ?? 'Unknown';
      } else {
        cat.breed = 'Unknown';
        cat.temperament = 'Unknown';
        cat.origin = 'Unknown';
        cat.description = 'No description available';
        cat.lifeSpan = 'Unknown';
      }
      return cat;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ErrorDescription("Network error: time limit exceeded");
      }
      throw ErrorDescription("Error while gaining cat data: $e");
    } catch (e) {
      throw ErrorDescription("Error while gaining cat data: $e");
    }
  }
}
