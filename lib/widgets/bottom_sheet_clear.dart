import 'package:flutter/material.dart';

/// A Rota retorna `true` se "LIMPAR" for acionado.
class BottomSheetClear extends BottomSheet {
  BottomSheetClear({
    super.key,
    void Function()? onClosing,
  }) : super(
          onClosing: onClosing ?? () {},
          builder: (context) {
            final buttonTextStyle = TextStyle(
              letterSpacing: 1.5,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              color: Colors.black.withOpacity(.8),
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 74.0,
                  child: ListTile(
                    title: Text(
                      'Deseja limpar o histórico?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                const Divider(height: 0),
                TextButton(
                  child: SizedBox(
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'FECHAR',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                const Divider(height: 0),
                TextButton(
                  child: SizedBox(
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'LIMPAR',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            );
          },
        );
}
