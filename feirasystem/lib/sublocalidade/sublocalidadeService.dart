import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/sublocalidade/sublocalidadeModel.dart';

class SublocalidadeService {
  final Dio _dio;

  SublocalidadeService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<Sublocalidade>> getSublocalidades() async {
    try {
      final response = await _dio.get('/sublocalidades');
      final List<dynamic> data = response.data;
      return data.map((item) => Sublocalidade.fromJson(item)).toList();
    } catch (e) {
      throw 'Erro ao carregar sublocalidades: ${e.toString()}';
    }
  }

  Future<Sublocalidade> getSublocalidade(int id) async {
    try {
      final response = await _dio.get('/sublocalidades/$id');
      return Sublocalidade.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao carregar sublocalidade: ${e.toString()}';
    }
  }

  Future<Sublocalidade> createSublocalidade(Sublocalidade sublocalidade) async {
    try {
      final response = await _dio.post('/sublocalidades', data: {
        'nome': sublocalidade.nome,
        'descricao': sublocalidade.descricao,
        'idLocalidade': sublocalidade.idLocalidade.toString(),
      });
      return Sublocalidade.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar sublocalidade: ${e.toString()}';
    }
  }

  Future<void> updateSublocalidade(int id, Sublocalidade sublocalidade) async {
    try {
      await _dio.put('/sublocalidades/$id', data: {
        'nome': sublocalidade.nome,
        'descricao': sublocalidade.descricao,
        'idLocalidade': sublocalidade.idLocalidade.toString(),
      });
      return;
    } catch (e) {
      throw 'Erro ao atualizar sublocalidade: ${e.toString()}';
    }
  }

  Future<void> deleteSublocalidade(int id) async {
    try {
      await _dio.delete('/sublocalidades/$id');
    } catch (e) {
      throw 'Erro ao deletar sublocalidade: ${e.toString()}';
    }
  }
}
