import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/monitorAtividade/monitorAtividadeModel.dart';

class MonitorAtividadeService {
  final Dio _dio;

  MonitorAtividadeService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<List<MonitorAtividade>> getMonitorAtividadesPorMonitor(
      int idMonitor) async {
    try {
      final response = await _dio.get('/monitores/atividade');

      if (response.statusCode == 200) {
        List<dynamic> listaCompleta = response.data['monitorAtividades'];
        return listaCompleta
            .map((json) => MonitorAtividade.fromJson(json))
            .toList();
      } else {
        throw Exception('Erro ao carregar atividades: ${response.statusCode}');
      }
    } catch (_) {
      throw Exception('Não foi possível conectar ao servidor.');
    }
  }

  Future<bool> trocarStatusDaSala(int idAtividade, String novoStatus) async {
    try {
      final response = await _dio.put(
        '/atividades/$idAtividade',
        data: {'status': novoStatus},
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
