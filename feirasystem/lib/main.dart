import 'package:feirasystem/agendamentoAtividadeFeira/agendamentoAtividadeFeiraWidget.dart';
import 'package:feirasystem/departamento/departamentoWidget.dart';
import 'package:feirasystem/homepage/homePageMonitor.dart';
import 'package:feirasystem/homepage/homePageOrganizador.dart';
import 'package:feirasystem/monitorAtividade/monitorAtividadeWidget.dart';
import 'package:feirasystem/pessoa/loginWidget.dart';
import 'package:feirasystem/pessoa/monitor/perfilMonitorWidget.dart';
import 'package:feirasystem/pessoa/organizador/perfilOrganizadorWidget.dart';
import 'package:feirasystem/pessoa/monitor/monitorWidget.dart';
import 'package:feirasystem/pessoa/organizador/organizadorWidget.dart';
import 'package:feirasystem/pessoa/pessoaWidget.dart';
import 'package:feirasystem/agendamentoFeira/agendamentoFeiraWidget.dart';
import 'package:feirasystem/atividade/atividadeWidget.dart';
import 'package:feirasystem/cadastro/cadastroWidget.dart';
import 'package:feirasystem/feira/feiraWidget.dart';
import 'package:feirasystem/localidade/localidadeWidget.dart';
import 'package:feirasystem/professor/professorWidget.dart';
import 'package:feirasystem/sublocalidade/sublocalidadeWidget.dart';
import 'package:feirasystem/homepage/homePageWidget.dart';
import 'package:feirasystem/core/appRoutes.dart';
import 'package:feirasystem/core/sessionService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restaura a sessão salva antes de abrir a primeira tela.
  await SessionService.instance.carregar();
  runApp(const ExpoUT());
}

class ExpoUT extends StatelessWidget {
  const ExpoUT({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feira de Profissões',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 254, 204, 23),
            primary: const Color.fromARGB(255, 50, 136, 242),
            surface: const Color.fromARGB(255, 236, 239, 243)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 4.0,
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          backgroundColor: Color.fromARGB(255, 254, 204, 23),
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        bottomAppBarTheme: const BottomAppBarThemeData(
          elevation: 4.0,
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          color: Color.fromARGB(255, 254, 204, 23),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 25, 42, 50),
        ),
        cardTheme: const CardThemeData(
          color: Color.fromARGB(255, 255, 245, 218),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 25, 42, 50),
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 254, 204, 23),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 50, 136, 242),
                foregroundColor: Colors.white,
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal))),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          floatingLabelStyle: const TextStyle(
              color: Color.fromARGB(255, 50, 136, 242),
              fontSize: 18,
              fontWeight: FontWeight.bold),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 50, 136, 242), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          errorStyle: const TextStyle(
            height: 0,
            fontSize: 0,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 236, 239, 243),
            ),
          ),
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color.fromARGB(255, 236, 239, 243),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: const DialogThemeData(
            backgroundColor: Color.fromARGB(255, 236, 239, 243)),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      navigatorKey: navigatorKey,
      onGenerateRoute: gerarRotaComAnimacao,
      initialRoute: Rotas.inicio(),
    );
  }
}

/// Devolve a tela da rota [nome], ou `null` se a rota não existe.
Widget? _paginaPara(String nome) {
  switch (nome) {
    case Rotas.boasVindas:
      return const Pessoas();
    case Rotas.homePage:
      return const HomePage();
    case Rotas.organizador:
      return const HomePageOrganizador();
    case Rotas.monitor:
      return const HomePageMonitor();
    case Rotas.cadastro:
      return const Cadastro();
    case 'cadastro/localidade':
      return const Localidades();
    case 'cadastro/sublocalidade':
      return const Sublocalidades();
    case 'cadastro/atividade':
      return const Atividades();
    case 'cadastro/feira':
      return const Feiras();
    case 'cadastro/agendamentofeira':
      return const AgendamentosFeira();
    case 'cadastro/departamento':
      return const Departamentos();
    case 'cadastro/professor':
      return const Professores();
    case 'cadastro/agendamentoAtividadeFeira':
      return const AgendamentosAtividadeFeira();
    case Rotas.login:
      return const Login();
    case Rotas.cadastroOrganizador:
      return const Organizadores();
    case Rotas.cadastroMonitor:
      return const Monitores();
    case Rotas.perfilOrganizador:
      return const PerfilOrganizadores();
    case Rotas.perfilMonitor:
      return const PerfilMonitores();
    case 'monitor/atividades':
      return const MonitorAtividades();
    default:
      return null;
  }
}

Route<dynamic> gerarRotaComAnimacao(RouteSettings settings) {
  var nome = settings.name ?? Rotas.boasVindas;
  var pagina = _paginaPara(nome);

  // Rota inexistente ou sem permissão (não logado / tipo errado): redireciona.
  final destino = pagina == null ? Rotas.inicio() : Rotas.redirecionar(nome);
  if (destino != null) {
    nome = destino;
    pagina = _paginaPara(destino);
  }
  final Widget tela = pagina ?? const Pessoas();

  return PageRouteBuilder(
    settings: RouteSettings(name: nome, arguments: settings.arguments),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => tela,
    transitionsBuilder: (_, animation, __, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      final scaleAnimation =
          Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation);
      final fadeAnimation =
          Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      );
    },
  );
}
