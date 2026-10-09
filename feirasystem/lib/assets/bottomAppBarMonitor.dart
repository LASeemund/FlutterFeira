import 'package:feirasystem/assets/appBottomBar.dart';
import 'package:feirasystem/core/appRoutes.dart';
import 'package:flutter/material.dart';

class BottomAppBarMonitor extends StatelessWidget {
  const BottomAppBarMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBottomBar(
      itens: [
        ItemBarra(icone: Icons.home, tooltip: 'Início', rota: Rotas.monitor),
        ItemBarra(icone: Icons.chat, tooltip: 'Chat'),
        ItemBarra(
          icone: Icons.account_circle,
          tooltip: 'Perfil',
          rota: Rotas.perfilMonitor,
        ),
      ],
    );
  }
}
