import 'package:feirasystem/assets/customSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:feirasystem/assets/formFields/passwordField.dart';
import 'package:feirasystem/assets/formFields/phoneField.dart';
import 'package:feirasystem/assets/formFields/cpfField.dart';
import 'package:feirasystem/pessoa/pessoaService.dart';

class Monitores extends StatefulWidget {
  const Monitores({super.key});
  @override
  _MonitoresState createState() => _MonitoresState();
}

class _MonitoresState extends State<Monitores> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorCelular = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorCpf = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();
  final TextEditingController _controladorCSenha = TextEditingController();

  bool _validarForm() {
    String nome = _controladorNome.text.trim();
    String celular = _controladorCelular.text.trim();
    String email = _controladorEmail.text.trim();
    String cpf = _controladorCpf.text.trim();
    String senha = _controladorSenha.text;
    String csenha = _controladorCSenha.text;

    if (nome.isEmpty ||
        celular.isEmpty ||
        email.isEmpty ||
        cpf.isEmpty ||
        senha.isEmpty ||
        csenha.isEmpty) {
      showCustomSnackBar(context, 'Preencha todos os campos obrigatórios!',
          tipo: 'erro', duracao: 1);
      return false;
    }
    if (!CpfField.cpfValido(cpf)) {
      showCustomSnackBar(context, 'CPF inválido.', tipo: 'erro', duracao: 1);
      return false;
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      showCustomSnackBar(context, 'E-mail inválido.', tipo: 'erro', duracao: 1);
      return false;
    }
    if (senha != csenha) {
      showCustomSnackBar(context, 'Senhas digitadas não correspondem!',
          tipo: 'erro', duracao: 1);
      return false;
    }
    if (senha.length < 8) {
      showCustomSnackBar(context,
          'Senha muito curta! Sua senha deve ter pelo menos 8 dígitos.',
          tipo: 'erro', duracao: 2);
      return false;
    }
    return true;
  }

  final PessoaService _service = PessoaService();
  bool _carregando = false;

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorCpf.dispose();
    _controladorCelular.dispose();
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    _controladorCSenha.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_carregando || !_validarForm()) return;

    setState(() => _carregando = true);
    try {
      await _service.cadastrar(
        nome: _controladorNome.text.trim(),
        cpf: _controladorCpf.text,
        celular: _controladorCelular.text.trim(),
        email: _controladorEmail.text.trim(),
        senha: _controladorSenha.text,
        tipoPessoa: 'MONITOR',
      );
      if (!mounted) return;
      showCustomSnackBar(context, 'Cadastrado com sucesso!',
          tipo: 'sucesso', duracao: 2);
      Navigator.pushReplacementNamed(context, 'usuario/login');
    } on PessoaException catch (e) {
      if (!mounted) return;
      showCustomSnackBar(context, e.mensagem, tipo: 'erro', duracao: 3);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre-se'),
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
                    'Cadastre-se como monitor',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: _controladorNome,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: CpfField(controller: _controladorCpf),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: PhoneField(controller: _controladorCelular),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
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
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      minWidth: 200,
                    ),
                    child: PasswordField(
                      controller: _controladorCSenha,
                      label: 'Confirme sua senha',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _carregando
                        ? null
                        : () {
                            _formKey.currentState!.validate();
                            _cadastrar();
                          },
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Cadastrar'),
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
