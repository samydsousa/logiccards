import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Esta classe foi criada com base em "katex_flutter.dart" do pacote "katex_flutter: ^4.0.2+26"
class KaTeX extends StatelessWidget {
  /// a Text used for the rendered code as well as for the style
  final String laTeXCode;

  /// The delimiter to be used for inline LaTeX
  final String delimiter;

  /// The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  ////////////////ALTERADO/////////////////
  /// Estilo do texto.
  final TextStyle? style;

  final List<InlineSpan> _blocosDoTexto = <InlineSpan>[];

  /// Se `true`, indica que [laTeXCode] contém texto LaTex.
  late final bool _temLaTex;

  /// Uma lista com as partes de [laTeXCode].
  List<InlineSpan> get blocosDoTexto => _blocosDoTexto;

  /// Se `true`, indica que [laTeXCode] contém texto LaTex.
  bool get temLaTex => _temLaTex;
  ////////////////ALTERADO/////////////////

  KaTeX({
    super.key,
    required this.laTeXCode,
    this.delimiter = r'$',
    this.displayDelimiter = r'$$',
    this.style,
  }) {
    // Building [RegExp] to find any Math part of the LaTeX code by looking for the specified delimiters
    final String delimiter = this.delimiter.replaceAll(r'$', r'\$');
    final String displayDelimiter =
        this.displayDelimiter.replaceAll(r'$', r'\$');

    // (?<!R) exclui os casos em que o delimitador "$" é precedido por "R".
    // Isso evita a identificação incorreta de Latex quando o texto contém duas ocorrências de "R$".
    final String rawRegExp =
        '((?<!R)($delimiter)([^$delimiter]*[^\\\\\\$delimiter])($delimiter)|($displayDelimiter)([^$displayDelimiter]*[^\\\\\\$displayDelimiter])($displayDelimiter))';
    List<RegExpMatch> matches =
        RegExp(rawRegExp, dotAll: true).allMatches(laTeXCode).toList();

    // Registrar se há alguma codificação LaTex
    _temLaTex = matches.isNotEmpty;

    int lastTextEnd = 0;

    for (var laTeXMatch in matches) {
      // If there is an offset between the lat match (beginning of the [String] in first case), first adding the found [Text]
      // Se houver um deslocamento entre a última correspondência (início de [String] no primeiro caso), primeiro adicionando o [Texto] encontrado
      if (laTeXMatch.start > lastTextEnd) {
        _blocosDoTexto.add(
            TextSpan(text: laTeXCode.substring(lastTextEnd, laTeXMatch.start)));
      }
      // Adding the [CaTeX] widget to the children
      if (laTeXMatch.group(3) != null) {
        _blocosDoTexto.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(laTeXMatch.group(3)!.trim())));
      } else if (laTeXMatch.group(6) != null) {
        _blocosDoTexto.addAll([
          const TextSpan(text: '\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: DefaultTextStyle.merge(
                child: Math.tex(laTeXMatch.group(6)!.trim())),
            style: style,
          ),
          const TextSpan(text: '\n')
        ]);
      }
      lastTextEnd = laTeXMatch.end;
    }

    // If there is any text left after the end of the last match, adding it to children
    if (lastTextEnd < laTeXCode.length) {
      _blocosDoTexto.add(TextSpan(text: laTeXCode.substring(lastTextEnd)));
    }
  }

  Text _montar(List<InlineSpan> blocosDoTexto, {TextStyle? style}) => Text.rich(
        TextSpan(children: blocosDoTexto),
        style: style,
      );

  @override
  Widget build(BuildContext context) => _montar(blocosDoTexto, style: style);
}
