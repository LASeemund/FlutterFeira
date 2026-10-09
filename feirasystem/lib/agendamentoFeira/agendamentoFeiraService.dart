import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/agendamentoFeira/agendamentoFeiraModel.dart'; // Importando o modelo AgendamentoFeira

class AgendamentoFeiraService {
  final Dio _dio;

  AgendamentoFeiraService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<AgendamentoFeira>> getAgendamentos() async {
    try {
      // final response = await _dio.get('/agendamentoFeiras');
      // final List<dynamic> data = response.data;
      // return data.map((item) => AgendamentoFeira.fromJson(item)).toList();
      final List<AgendamentoFeira> agendamentos = [
          AgendamentoFeira(id: 1, idFeira: 1, data:DateTime.now(), turno: Turno.MANHA),
          AgendamentoFeira(id: 2, idFeira: 1, data:DateTime.now(), turno: Turno.TARDE),
          AgendamentoFeira(id: 3, idFeira: 1, data:DateTime.now(), turno: Turno.NOITE),
          AgendamentoFeira(id: 4, idFeira: 2, data:DateTime.now(), turno: Turno.MANHA),
          AgendamentoFeira(id: 5, idFeira: 2, data:DateTime.now(), turno: Turno.TARDE),
          AgendamentoFeira(id: 6, idFeira: 2, data:DateTime.now(), turno: Turno.NOITE),
      ];
      return agendamentos;
    } catch (e) {
      throw 'Erro ao carregar agendamentos: ${e.toString()}';
    }
  }

  // Future<List<AgendamentoFeira>> getAgendamentosFeira(int idFeira) async {
    // TO DO
  // }

  Future<AgendamentoFeira> getAgendamento(int id) async {
    try {
      final response = await _dio.get('/agendamentoFeiras/$id');
      return AgendamentoFeira.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao carregar agendamento: ${e.toString()}';
    }
  }

  Future<AgendamentoFeira> createAgendamento(
      AgendamentoFeira agendamento) async {
    try {
      final response = await _dio.post('/agendamentoFeiras', data: {
        'data': agendamento.data.toIso8601String(),
        'turno': agendamento.turno.descricao,
        'idFeira': agendamento.idFeira.toString(),
      });
      return AgendamentoFeira.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar agendamento: ${e.toString()}';
    }
  }

  Future<void> updateAgendamento(int id, AgendamentoFeira agendamento) async {
    try {
      await _dio.put('/agendamentoFeiras/$id', data: {
        'data': agendamento.data.toIso8601String(),
        'turno': agendamento.turno.descricao,
        'idFeira': agendamento.idFeira.toString(),
      });
      return;
    } catch (e) {
      throw 'Erro ao atualizar agendamento: ${e.toString()}';
    }
  }

  Future<void> deleteAgendamento(int id) async {
    try {
      await _dio.delete('/agendamentoFeiras/$id');
    } catch (e) {
      throw 'Erro ao deletar agendamento: ${e.toString()}';
    }
  }
}
