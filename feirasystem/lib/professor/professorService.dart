import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/professor/professorModel.dart';

class ProfessorService {
  final Dio _dio;

  ProfessorService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<Professor>> getProfessores() async {
    try {
      final response = await _dio.get('/professores');
      final List<dynamic> data = response.data;
      return data.map((item) => Professor.fromJson(item)).toList();
    } catch (e) {
      throw 'Erro ao carregar professores: ${e.toString()}';
    }
  }

  Future<Professor> getProfessor(int id) async {
    try {
      final response = await _dio.get('/professores/$id');
      return Professor.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao carregar professor: ${e.toString()}';
    }
  }

  Future<Professor> createProfessor(Professor professor) async {
    try {
      final response = await _dio.post('/professores', data: {
        'nome': professor.nome,
        'idDepartamento': professor.idDepartamento.toString(),
      });
      return Professor.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar professor: ${e.toString()}';
    }
  }

  Future<void> updateProfessor(int id, Professor professor) async {
    try {
      await _dio.put('/professores/$id', data: {
        'nome': professor.nome,
        'idDepartamento': professor.idDepartamento.toString(),
      });
      return;
    } catch (e) {
      throw 'Erro ao atualizar professor: ${e.toString()}';
    }
  }

  Future<void> deleteProfessor(int id) async {
    try {
      await _dio.delete('/professores/$id');
    } catch (e) {
      throw 'Erro ao deletar professor: ${e.toString()}';
    }
  }
}
