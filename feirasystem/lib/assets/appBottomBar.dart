import 'package:feirasystem/assets/customSnackBar.dart';
import 'package:flutter/material.dart';

/// apenas mostra o aviso "Em breve!".
class ItemBarra {
  final IconData icone;
  final String tooltip;
  final String? rota;

  const ItemBarra({required this.icone, required this.tooltip, this.rota});
}

class AppBottomBar extends StatelessWidget {
  final List<ItemBarra> itens;

  const AppBottomBar({super.key, required this.itens});

  @override
  Widget build(BuildContext context) {
    final atual = ModalRoute.of(context)?.settings.name ?? '';
    final botoes = <Widget>[];
    for (int i = 0; i < itens.length; i++) {
      if (i > 0) botoes.add(const SizedBox(width: 32));
      botoes.add(_botao(context, itens[i], atual));
    }
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: botoes,
      ),
    );
  }

  Widget _botao(BuildContext context, ItemBarra item, String atual) {
    final rota = item.rota;
    final ativo = rota != null && (atual == rota || atual.startsWith('$rota/'));

    return Container(
      decoration: BoxDecoration(
        color: ativo ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        tooltip: item.tooltip,
        icon: Icon(item.icone, color: ativo ? Colors.white : null),
        iconSize: 32,
        onPressed: () => _aoTocar(context, item, atual),
      ),
    );
  }

  void _aoTocar(BuildContext context, ItemBarra item, String atual) {
    final rota = item.rota;
    if (rota == null) {
      showCustomSnackBar(context, 'Em breve!', duracao: 1);
      return;
    }
    if (rota == atual) return;
    Navigator.pushNamedAndRemoveUntil(context, rota, (_) => false);
  }
}
