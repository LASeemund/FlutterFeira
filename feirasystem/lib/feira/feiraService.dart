import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/feira/feiraModel.dart';

class FeiraService {
  final Dio _dio;

  FeiraService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<Feira>> getFeiras() async {
    try {
      final response = await _dio.get('/feiras');
      final List<dynamic> data = response.data;
      return data.map((item) => Feira.fromJson(item)).toList();
    } on DioException catch (e) {
      if (e.response?.data['mensagem'] != null) {
        throw '${e.response?.data['mensagem']}';
      } else {
        throw e.toString();
      }
    }
  }

  Future<Feira> getFeira(int id) async {
    try {
      final response = await _dio.get('/feiras/$id');
      return Feira.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data['mensagem'] != null) {
        throw '${e.response?.data['mensagem']}';
      } else {
        throw e.toString();
      }
    }
  }

  Future<Feira> createFeira(Feira feira) async {
    try {
      final response = await _dio.post('/feiras', data: {
        'nome': feira.nome,
      });
      return Feira.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data['mensagem'] != null) {
        throw '${e.response?.data['mensagem']}';
      } else {
        throw e.toString();
      }
    }
  }

  Future<void> updateFeira(int id, Feira feira) async {
    try {
      await _dio.put('/feiras/$id', data: {
        'nome': feira.nome,
      });
      return;
    } on DioException catch (e) {
      if (e.response?.data['mensagem'] != null) {
        throw '${e.response?.data['mensagem']}';
      } else {
        throw e.toString();
      }
    }
  }

  Future<void> deleteFeira(int id) async {
    try {
      await _dio.delete('/feiras/$id');
    } on DioException catch (e) {
      if (e.response?.data['mensagem'] != null) {
        throw '${e.response?.data['mensagem']}';
      } else {
        throw e.toString();
      }
    }
  }
}
