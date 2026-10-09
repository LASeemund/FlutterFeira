import 'package:feirasystem/assets/appBottomBar.dart';
import 'package:feirasystem/core/appRoutes.dart';
import 'package:flutter/material.dart';

class BottomAppBarOrganizador extends StatelessWidget {
  const BottomAppBarOrganizador({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBottomBar(
      itens: [
        ItemBarra(
            icone: Icons.add, tooltip: 'Cadastros', rota: Rotas.cadastro),
        ItemBarra(
            icone: Icons.home, tooltip: 'Início', rota: Rotas.organizador),
        ItemBarra(icone: Icons.chat, tooltip: 'Chat'),
        ItemBarra(
          icone: Icons.account_circle,
          tooltip: 'Perfil',
          rota: Rotas.perfilOrganizador,
        ),
      ],
    );
  }
}
