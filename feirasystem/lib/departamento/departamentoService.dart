import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/departamento/departamentoModel.dart';

class DepartamentoService {
  final Dio _dio;

  DepartamentoService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<Departamento>> getDepartamentos() async {
    try {
      final response = await _dio.get('/departamentos');

      final data = response.data;

      if (data is Map && data['departamentos'] != null) {
        return (data['departamentos'] as List)
            .map((e) => Departamento.fromJson(e))
            .toList();
      }

      if (data is List) {
        return data.map((e) => Departamento.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      throw 'Erro ao carregar departamentos: $e';
    }
  }


  Future<Departamento> getDepartamento(int id) async {
    try {
      final response = await _dio.get('/departamentos/$id');
      return Departamento.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao carregar departamento: ${e.toString()}';
    }
  }

  Future<void> createDepartamento(Departamento departamento) async {
    try {
      final response = await _dio.post(
        '/departamentos',
        data: {
          'nome': departamento.nome,
        },
      );

    } catch (e) {
      throw 'Erro ao criar departamento: $e';
    }
  }

  Future<void> updateDepartamento(int id, Departamento departamento) async {
    try {
      await _dio.put('/departamentos/$id', data: {
        'nome': departamento.nome,
      });
      return;
    } catch (e) {
      throw 'Erro ao atualizar departamento: ${e.toString()}';
    }
  }

  Future<void> deleteDepartamento(int id) async {
    try {
      await _dio.delete('/departamentos/$id');
    } catch (e) {
      throw 'Erro ao deletar departamento: ${e.toString()}';
    }
  }
}
