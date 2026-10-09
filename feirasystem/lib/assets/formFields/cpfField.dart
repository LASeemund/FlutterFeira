import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CpfField extends StatelessWidget {
  final TextEditingController controller;

  const CpfField({super.key, required this.controller});

  /// Valida o CPF (11 dígitos + dígitos verificadores).
  static bool cpfValido(String valor) {
    final cpf = valor.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return false;
    }
    int digito(int tamanho) {
      int soma = 0;
      for (int i = 0; i < tamanho; i++) {
        soma += int.parse(cpf[i]) * (tamanho + 1 - i);
      }
      final resto = (soma * 10) % 11;
      return resto == 10 ? 0 : resto;
    }

    return digito(9) == int.parse(cpf[9]) && digito(10) == int.parse(cpf[10]);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskedInputFormatter('000.000.000-00'),
      ],
      decoration: const InputDecoration(
        labelText: 'CPF',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
    );
  }
}
