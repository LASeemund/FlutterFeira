import 'package:dio/dio.dart';
import 'package:feirasystem/core/apiClient.dart';
import 'package:feirasystem/core/sessionService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PessoaException implements Exception {
  final String mensagem;
  PessoaException(this.mensagem);

  @override
  String toString() => mensagem;
}

class PessoaService {
  final Dio _dio;

  PessoaService([Dio? dio]) : _dio = dio ?? ApiClient.dio;

  Future<String> login(String email, String senha) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'senha': senha},
        options: Options(extra: {ApiClient.publica: true}),
      );

      final token = response.data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw PessoaException('Resposta inválida do servidor.');
      }

      final sessao = SessionService.instance;
      await sessao.iniciar(token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      if (sessao.ehOrganizador) {
        try {
          final r = await _dio.get('/pessoas/${sessao.idPessoa}');
          final pessoa = r.data['pessoa'];
          await prefs.setString('nome', pessoa['nome'] ?? '');
          await prefs.setString('celular', pessoa['celular'] ?? '');
        } catch (_) {
          // Não impede o login se não conseguir buscar o nome.
        }
      }

      return sessao.tipoPessoa!;
    } on PessoaException {
      rethrow;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw PessoaException('E-mail ou senha inválidos.');
      }
      throw PessoaException(_mensagemDeErro(e));
    } catch (_) {
      throw PessoaException('Não foi possível fazer login.');
    }
  }

  /// Cadastra uma pessoa (POST /pessoas). 'MONITOR' ou 'ORGANIZADOR'.
  Future<void> cadastrar({
    required String nome,
    required String cpf,
    required String celular,
    required String email,
    required String senha,
    required String tipoPessoa,
  }) async {
    try {
      await _dio.post(
        '/pessoas',
        data: {
          'nome': nome,
          'cpf': cpf.replaceAll(RegExp(r'\D'), ''), // back guarda só dígitos
          'celular': celular,
          'email': email,
          'senha': senha,
          'tipoPessoa': tipoPessoa,
        },
        options: Options(extra: {ApiClient.publica: true}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw PessoaException('CPF ou e-mail já cadastrado.');
      }
      throw PessoaException(_mensagemDeErro(e));
    } catch (_) {
      throw PessoaException('Não foi possível concluir o cadastro.');
    }
  }

  String _mensagemDeErro(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Não foi possível conectar ao servidor.';
      default:
        final data = e.response?.data;
        if (data is Map && data['message'] is String) {
          return data['message'] as String;
        }
        return 'Erro do servidor. Tente novamente.';
    }
  }
}
