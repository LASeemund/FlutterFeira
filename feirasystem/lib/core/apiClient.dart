import 'package:dio/dio.dart';
import 'package:feirasystem/core/appRoutes.dart';
import 'package:feirasystem/core/sessionService.dart';

class AppConfig {
  AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );
}

class ApiClient {
  ApiClient._();

  static const String publica = 'publica';

  static final Dio dio = _criar();

  static bool _tratandoExpiracao = false;

  static Dio _criar() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SessionService.instance.token;
        if (token != null && options.extra[publica] != true) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 &&
            e.requestOptions.extra[publica] != true) {
          await _sessaoExpirada();
        }
        handler.next(e);
      },
    ));

    return dio;
  }

  static Future<void> _sessaoExpirada() async {
    if (_tratandoExpiracao) return;
    _tratandoExpiracao = true;
    try {
      await SessionService.instance.encerrar();

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Rotas.login,
        (_) => false,
        arguments: 'Sua sessão expirou. Entre novamente.',
      );
    } finally {
      _tratandoExpiracao = false;
    }
  }
}
