import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Guarda a sessão do usuário em memória e no armazenamento local.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const String _chaveToken = 'auth_token';
  static const String _chaveTipo = 'tipoPessoa';
  static const String _chaveId = 'idPessoa';

  static const String monitor = 'MONITOR';
  static const String organizador = 'ORGANIZADOR';

  String? _token;
  String? _tipoPessoa;
  int? _idPessoa;
  DateTime? _expiraEm;

  bool get temSessao =>
      _token != null &&
      _expiraEm != null &&
      DateTime.now().isBefore(_expiraEm!);

  String? get token => temSessao ? _token : null;
  String? get tipoPessoa => temSessao ? _tipoPessoa : null;
  int? get idPessoa => temSessao ? _idPessoa : null;

  bool get ehOrganizador => temSessao && _tipoPessoa == organizador;
  bool get ehMonitor => temSessao && _tipoPessoa == monitor;

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_chaveToken);
    if (token == null) return;

    try {
      _aplicar(token);
    } catch (_) {
      await encerrar();
      return;
    }
    if (!temSessao) {
      await encerrar();
    }
  }

  Future<void> iniciar(String token) async {
    _aplicar(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveToken, token);
    await prefs.setString(_chaveTipo, _tipoPessoa!);
    await prefs.setInt(_chaveId, _idPessoa!);
  }

  Future<void> encerrar() async {
    _token = null;
    _tipoPessoa = null;
    _idPessoa = null;
    _expiraEm = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _aplicar(String token) {
    final partes = token.split('.');
    if (partes.length != 3) {
      throw const FormatException('Token inválido');
    }
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(partes[1]))),
    ) as Map<String, dynamic>;

    final exp = payload['exp'];
    _token = token;
    _tipoPessoa = payload['tipoPessoa'] as String;
    _idPessoa = (payload['id'] as num).toInt();
    // O back sempre envia `exp`; se faltar, assume 1 hora.
    _expiraEm = exp is num
        ? DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000)
        : DateTime.now().add(const Duration(hours: 1));
  }
}
