import 'package:flutter/material.dart';
import 'package:feirasystem/core/sessionService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Rotas {
  Rotas._();

  static const String boasVindas = '';
  static const String login = 'usuario/login';
  static const String cadastroMonitor = 'usuario/monitor';

  static const String homePage = 'homePage';
  static const String organizador = 'organizador';
  static const String monitor = 'monitor';
  static const String cadastro = 'cadastro';
  static const String cadastroOrganizador = 'usuario/organizador';
  static const String perfilOrganizador = 'usuario/perfil/organizador';
  static const String perfilMonitor = 'usuario/perfil/monitor';

  /// Telas acessíveis sem estar logado.
  static const Set<String> _publicas = {boasVindas, login, cadastroMonitor};

  /// Home de acordo com o tipo do usuário logado.
  static String homeDoUsuario() {
    return SessionService.instance.ehOrganizador ? organizador : monitor;
  }

  /// Rota inicial do app: home se houver sessão válida, boas-vindas se não.
  static String inicio() {
    return SessionService.instance.temSessao ? homeDoUsuario() : boasVindas;
  }

  static bool _soOrganizador(String nome) {
    return nome == homePage ||
        nome == organizador ||
        nome == cadastroOrganizador ||
        nome == perfilOrganizador ||
        nome == cadastro ||
        nome.startsWith('$cadastro/');
  }

  static bool _soMonitor(String nome) {
    return nome == monitor || nome == perfilMonitor;
  }

  static String? redirecionar(String nome) {
    final sessao = SessionService.instance;

    if (_publicas.contains(nome)) {
      // Quem já está logado não precisa ver login/cadastro/boas-vindas.
      return sessao.temSessao ? homeDoUsuario() : null;
    }
    if (!sessao.temSessao) return login;
    if (_soOrganizador(nome) && !sessao.ehOrganizador) return homeDoUsuario();
    if (_soMonitor(nome) && !sessao.ehMonitor) return homeDoUsuario();
    return null;
  }
}
