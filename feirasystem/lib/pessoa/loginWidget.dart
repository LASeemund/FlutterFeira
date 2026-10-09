import 'package:feirasystem/assets/customSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:feirasystem/assets/formFields/passwordField.dart';
import 'package:feirasystem/core/appRoutes.dart';
import 'package:feirasystem/pessoa/pessoaService.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  bool _validarForm() {
    String email = _controladorEmail.text.trim();
    String senha = _controladorSenha.text;

    if (email.isEmpty || senha.isEmpty) {
      showCustomSnackBar(
          context, 'Forneça todos os dados para entrar no sistema.',
          tipo: 'erro');
      return false;
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      showCustomSnackBar(context, 'E-mail inválido.', tipo: 'erro');
      return false;
    }
    return true;
  }

  final PessoaService _service = PessoaService();
  bool _carregando = false;

  bool _avisoExibido = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_avisoExibido) return;
    _avisoExibido = true;
    final aviso = ModalRoute.of(context)?.settings.arguments;
    if (aviso is String) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCustomSnackBar(context, aviso, tipo: 'erro', duracao: 3);
        }
      });
    }
  }

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_carregando || !_validarForm()) return;

    setState(() => _carregando = true);
    try {
      await _service.login(
        _controladorEmail.text.trim(),
        _controladorSenha.text,
      );
      if (!mounted) return;
      showCustomSnackBar(context, 'Autenticado com sucesso!',
          tipo: 'sucesso', duracao: 1);
      Navigator.pushNamedAndRemoveUntil(
        context,
        Rotas.homeDoUsuario(),
        (_) => false,
      );
    } on PessoaException catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, e.mensagem, tipo: 'erro');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feira de Profissões'),
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 243),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Entre no sistema da Feira de Profissões',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: TextFormField(
                      controller: _controladorEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: PasswordField(
                      controller: _controladorSenha,
                      label: 'Senha',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _carregando ? null : _login,
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
