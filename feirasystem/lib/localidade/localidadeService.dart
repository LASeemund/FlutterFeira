import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/localidade/localidadeModel.dart';

class LocalidadeService {
  final Dio _dio;

  LocalidadeService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<Localidade>> getLocalidades() async {
    try {
      final response = await _dio.get('/localidades');
      final List<dynamic> data = response.data;
      return data.map((item) => Localidade.fromJson(item)).toList();
    } catch (e) {
      throw 'Erro ao carregar localidades: ${e.toString()}';
    }
  }

  Future<Localidade> getLocalidade(int id) async {
    try {
      final response = await _dio.get('/localidades/$id');
      return Localidade.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao carregar localidade: ${e.toString()}';
    }
  }

  Future<Localidade> createLocalidade(Localidade localidade) async {
    try {
      final response = await _dio.post('/localidades', data: {
        'nome': localidade.nome,
        'descricao': localidade.descricao,
        'quantidadeSalas': localidade.quantidadeSalas.toString(),
      });
      return Localidade.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar localidade: ${e.toString()}';
    }
  }

  Future<void> updateLocalidade(int id, Localidade localidade) async {
    try {
      await _dio.put('/localidades/$id', data: {
        'nome': localidade.nome,
        'descricao': localidade.descricao,
        'quantidadeSalas': localidade.quantidadeSalas.toString(),
      });
      return;
    } catch (e) {
      throw 'Erro ao atualizar localidade: ${e.toString()}';
    }
  }

  Future<void> deleteLocalidade(int id) async {
    try {
      await _dio.delete('/localidades/$id');
    } catch (e) {
      throw 'Erro ao deletar localidade: ${e.toString()}';
    }
  }
}
