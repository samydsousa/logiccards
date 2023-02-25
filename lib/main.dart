import 'dart:ui';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:logiccards/widgets/about_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/card.dart';
import 'models/sentence.dart';
import 'widgets/bottom_sheet_clear.dart';
import 'widgets/card_widget.dart';
import 'widgets/scroll_switcher.dart';
import 'widgets/sentence_widget.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //CardsColors.getColors();
  runApp(const LogicCards());
}

class LogicCards extends StatelessWidget {
  const LogicCards({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logic Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Logic Cards'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Sentence _sentenceTemp = Sentence();
  final _historicSentences = <Sentence>[];
  final ScrollController _listController = ScrollController();
  bool _showDisabledCards = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _actions(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                _historicWidget(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _containerLinearGradientAndBlur(
                    height: 24.0,
                  ),
                ),
              ],
            ),
          ),
          _cardsBar(),
        ],
      ),
    );
  }

  List<Widget>? _actions() {
    return [
      if (_sentenceTemp.cards.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: _undo,
        ),
      PopupMenuButton<PopupMenuAction>(
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: _sentenceTemp.cards.isNotEmpty,
            value: PopupMenuAction.clear,
            child: ListTile(
              leading: const Icon(Icons.clear_all),
              enabled: _sentenceTemp.cards.isNotEmpty,
              title: const Text('Limpar'),
            ),
          ),
          CheckedPopupMenuItem(
            value: PopupMenuAction.showDisabledCards,
            checked: _showDisabledCards,
            child: const Text('Mostrar cartas desativadas'),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: PopupMenuAction.downloadCards,
            child: ListTile(
              leading: Icon(Icons.download),
              title: Text('Baixar cartas'),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: PopupMenuAction.about,
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
            ),
          ),
        ],
        onSelected: (action) {
          switch (action) {
            case PopupMenuAction.clear:
              _clear();
              break;
            case PopupMenuAction.showDisabledCards:
              setState(() {
                _showDisabledCards = !_showDisabledCards;
              });
              break;
            case PopupMenuAction.downloadCards:
              _downloadCards();
              break;
            case PopupMenuAction.about:
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              }();
              break;
          }
        },
      )
    ];
  }

  void _undo() {
    if (_sentenceTemp.cards.isEmpty) return;
    _sentenceTemp.cards.removeLast();
    if (_sentenceTemp.cards.isEmpty) {
      if (_historicSentences.isNotEmpty) {
        _sentenceTemp = _historicSentences.last;
        _historicSentences.removeLast();
      }
    }
    setState(() {
      _sentenceTemp;
      _historicSentences;
    });
  }

  void _clear() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        return BottomSheetClear();
      },
    );
    if (result ?? false) {
      setState(() {
        _sentenceTemp.cards.clear();
        _historicSentences.clear();
      });
    }
  }

  void _downloadCards() async {
    const url =
        'https://github.com/samydsousa/logiccards/tree/main/images/cheap/Logic%20Cards.pdf';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } on FormatException catch (_) {
    } on PlatformException catch (_) {}
  }

  Widget _historicWidget() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 52),
      controller: _listController,
      children: _historicSentences.map((Sentence item) {
        return _buildSentenceWidget(item);
      }).toList()
        ..add(_buildSentenceWidget(_sentenceTemp)),
    );
  }

  Widget _buildSentenceWidget(Sentence sentence) {
    trailing() {
      var value = sentence.getValue();
      if (value != null) {
        return CircleAvatar(
          backgroundColor: Colors.black.withOpacity(.8),
          child: Math.tex(
            value ? 'V' : 'F',
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
        );
      }
      return const CircleAvatar(backgroundColor: Colors.transparent);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: SentenceWidget(sentence),
        trailing: trailing(),
      ),
    );
  }

  Widget _containerLinearGradientAndBlur({
    Widget? child,
    double? height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.01),
            Colors.white,
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: .7, sigmaY: .7),
        child: child,
      ),
    );
  }

  Widget _cardsBar() {
    return Center(
      child: ScrollSwitcher(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            TypesCards.vTrue,
            TypesCards.vFalse,
            TypesCards.negation,
            TypesCards.conjunction,
            TypesCards.inclusiveDisjunction,
            TypesCards.exclusiveDisjunction,
            TypesCards.conditional,
            TypesCards.biconditional,
          ].where((type) {
            return _showDisabledCards ? true : _getEnableCard(type);
          }).map((type) {
            return CardWidget(
              type: type,
              onTap: () => _onTapCard(type),
              enable: _showDisabledCards ? _getEnableCard(type) : true,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onTapCard(TypesCards type) {
    _addCard(type);
  }

  void _addCard(TypesCards type) {
    if (_getEnableCard(type)) {
      var isCompoundProposition = _sentenceTemp.isCompoundProposition();
      var cardValue = _sentenceTemp.getCardValue();

      if (isCompoundProposition && cardValue?.type == type) {
        _historicSentences.add(_sentenceTemp);
        _sentenceTemp = Sentence();
      }

      setState(() {
        _sentenceTemp.cards.add(Card(type));
      });

      if (_listController.hasClients) {
        var position = _listController.position.maxScrollExtent;
        _listController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  bool _getEnableCard(TypesCards type) {
    if (_sentenceTemp.cards.isEmpty) {
      // Início do jogo
      return type.isValue || type.isNegation;
    }

    var typeCardValue = _sentenceTemp.getCardValue()?.type;
    if (_sentenceTemp.isCompoundProposition() && typeCardValue == type) {
      // Uma carta correspondente ao valor da proposição pode ser lançada
      return true;
    }

    var lastType = _sentenceTemp.cards.last.type;
    if (lastType.isNegation) {
      return type.isValue;
    }
    if (lastType.isValue) {
      return type.isConnective;
    }
    if (lastType.isConnective) {
      return type.isValue || type.isNegation;
    }
    throw StateError('O tipo da carta não foi identificado.');
  }
}

enum PopupMenuAction {
  clear,
  showDisabledCards,
  downloadCards,
  about,
}
