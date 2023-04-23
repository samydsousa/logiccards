import 'dart:collection';

import 'card.dart';

abstract class _Proposition {
  _Proposition(this.cards);

  final List<Card> cards;

  int get numCards => cards.length;

  bool get value;
}

class _SimpleProposition extends _Proposition {
  _SimpleProposition._(super.cards);
  factory _SimpleProposition(List<Card> cards) {
    if (valideCards(cards)) {
      return _SimpleProposition._(cards);
    } else {
      throw StateError('Há um erro de sintaxe na proposição.');
    }
  }

  @override
  bool get value {
    final value = _getValue(cards);

    if (value == null) {
      throw StateError('Há um erro de sintaxe na proposição.');
    } else {
      return value;
    }
  }

  static bool? _getValue(List<Card> cards) {
    if (cards.isEmpty) {
      return null;
    }

    getValue(Card card) {
      switch (card.type) {
        case TypesCards.vTrue:
          return true;
        case TypesCards.vFalse:
          return false;
        default:
          return null;
      }
    }

    if (cards.length == 1) {
      return getValue(cards.single);
    }

    final countNegation = cards.where((card) => card.isNegation).length;
    final lastCardValue = getValue(cards.last);

    if (lastCardValue == null || (cards.length != countNegation + 1)) {
      return null;
    }

    if (countNegation % 2 == 0) {
      return lastCardValue;
    } else {
      return !lastCardValue;
    }
  }

  /// Retorna `TRUE` se for possível criar um [_SimpleProposition] com [cards].
  static bool valideCards(List<Card> cards) {
    return !(_getValue(cards) == null);
  }

  @override
  String toString() {
    return cards.map((card) => card.latexCode).join(' ');
  }
}

class _CompoundProposition extends _Proposition {
  _CompoundProposition(
    this.firstProposition,
    this.connective,
    this.lastProposition,
  ) : super([
          ...firstProposition.cards,
          connective,
          ...lastProposition.cards,
        ]);

  final _Proposition firstProposition;
  final Card connective;
  final _SimpleProposition lastProposition;

  @override
  bool get value => _getValue();

  bool _getValue() {
    bool xor(bool firstValue, bool lastValue) {
      return (firstValue && !lastValue) || (!firstValue && lastValue);
    }

    bool conditional(bool firstValue, bool lastValue) {
      return !firstValue || lastValue;
    }

    bool biconditional(bool firstValue, bool lastValue) {
      return conditional(firstValue, lastValue) &&
          conditional(lastValue, firstValue);
    }

    switch (connective.type) {
      case TypesCards.conjunction:
        return firstProposition.value && lastProposition.value;
      case TypesCards.inclusiveDisjunction:
        return firstProposition.value || lastProposition.value;
      case TypesCards.exclusiveDisjunction:
        return xor(firstProposition.value, lastProposition.value);
      case TypesCards.conditional:
        return conditional(firstProposition.value, lastProposition.value);
      case TypesCards.biconditional:
        return biconditional(firstProposition.value, lastProposition.value);
      default:
        throw StateError('Conectivo não identificado.');
    }
  }

  @override
  String toString() {
    displayParentheses() {
      if (connective.isConjunction || connective.isInclusiveDisjunction) {
        // Verifica se há conectivos diferentes nesta sentença.
        final assortedConnectives = firstProposition.cards
            .where((card) => card.isConnective)
            .any((connective) => connective.type != this.connective.type);
        return assortedConnectives;
      }
      return true;
    }

    return [
      if (firstProposition is _SimpleProposition) firstProposition.toString(),
      if (firstProposition is _CompoundProposition)
        displayParentheses()
            ? '(${firstProposition.toString()})'
            : firstProposition.toString(),
      connective.latexCode,
      lastProposition.toString(),
    ].join(' ');
  }
}

class Sentence {
  _Proposition? _proposition;

  /// O conectivo que juntamente com [_cardsNewSimpleProposition] será usado para substituir [_proposition].
  Card? _currentConnective;

  /// O último conectivo usado nesta sentença.
  /// Retorna `NULL` se o conectivo não for encontrado.
  Card? get currentConnective => _currentConnective;

  /// Os [Card] que juntamente com [currentConnective]
  final List<Card> _cardsNewSimpleProposition = <Card>[];

  /// Esta lista não deve ser alterada, caso contrário lançará um [UnsupportedError].
  UnmodifiableListView<Card> get _cards => UnmodifiableListView([
        ...(_proposition?.cards ?? []),
        if (currentConnective != null) currentConnective!,
        ..._cardsNewSimpleProposition,
      ]);

  bool get isEmpty => _cards.isEmpty;

  bool get isNotEmpty => _cards.isNotEmpty;

  /// Adiciona [card] ao final da sentença. Retorna `TRUE` se a operação for bem sucedida.
  bool addCard(Card card) {
    if (canAddCard(card)) {
      if (card.isConnective) {
        _currentConnective = card;
      } else if (card.isNegation) {
        _cardsNewSimpleProposition.add(card);
      } else {
        final cards = [..._cardsNewSimpleProposition, card];
        if (_proposition == null) {
          _proposition = _SimpleProposition(cards);
        } else {
          _proposition = _CompoundProposition(
            _proposition!,
            _currentConnective!,
            _SimpleProposition(cards),
          );
          _currentConnective = null;
        }
        _cardsNewSimpleProposition.clear();
      }
      return true;
    }
    return false;
  }

  /// Retorna `TRUE` se [card] puder ser adicionado ao final da sentença sem inviabilizar a construção de uma sentença bem formada.
  bool canAddCard(Card card) {
    if (card.isConnective) {
      // Não se inicia uma proposição com um conectivo.
      // Nem se pode lançar dois conectivos consecutivos.
      // Sempre que uma nova carta for lançada e der origem a uma nova proposição, [_proposition] será substituída e [_cardsNewSimpleProposition] será esvaziada. Veja o código de [addCard].
      return _proposition != null &&
          _currentConnective == null &&
          _cardsNewSimpleProposition.isEmpty;
    } else {
      if (_proposition != null && _currentConnective == null) {
        // Em uma sentença bem formada, após uma proposição deve vir um conectivo.
        return false;
      }
      if (card.isNegation) {
        // Uma sequência de negações é permitida.
        return _cardsNewSimpleProposition
            .where((card) => !card.isNegation)
            .isEmpty;
      } else {
        final cards = [..._cardsNewSimpleProposition, card];
        return _SimpleProposition.valideCards(cards);
      }
    }
  }

  /// Remove o último [Card] adicionado.
  bool removeCard() {
    if (isEmpty) {
      return false;
    }
    if (_cardsNewSimpleProposition.isNotEmpty) {
      _cardsNewSimpleProposition.removeLast();
      return true;
    }
    if (_currentConnective != null) {
      _currentConnective = null;
      return true;
    }
    if (_proposition is _SimpleProposition) {
      final proposition = _proposition as _SimpleProposition;
      _cardsNewSimpleProposition
        ..addAll(proposition.cards)
        ..removeLast();
      _proposition = null;
      return true;
    }
    if (_proposition is _CompoundProposition) {
      final proposition = _proposition as _CompoundProposition;
      _cardsNewSimpleProposition
        ..addAll(proposition.lastProposition.cards)
        ..removeLast();
      _currentConnective = proposition.connective;
      _proposition = proposition.firstProposition;
      return true;
    }
    return false;
  }

  /// Retorna `TRUE` se esta sentença estiver bem formada.
  bool isWellFormedFormula() {
    return _proposition != null &&
        currentConnective == null &&
        _cardsNewSimpleProposition.isEmpty;
  }

  bool isCompoundProposition() {
    return isWellFormedFormula() && _proposition is _CompoundProposition;
  }

  bool isSimpleProposition() {
    return isWellFormedFormula() && _proposition is _SimpleProposition;
  }

  /// Se esta sentença estiver bem formada, retorna seu valor, caso contrário retorna NULL``.
  bool? getValue() {
    if (isWellFormedFormula()) {
      return _proposition!.value;
    } else {
      return null;
    }
  }

  /// Se esta sentença estiver bem formada ([isWellFormedFormula] for `TRUE`), retorna um [Card] correspondente ao seu valor.
  /// Caso contrário, retorna `NULL`.
  Card? getCardValue() {
    var value = getValue();
    if (value != null) {
      switch (value) {
        case true:
          return Card(TypesCards.vTrue);
        case false:
          return Card(TypesCards.vFalse);
      }
    }
    return null;
  }

  clear() {
    _proposition = null;
    _currentConnective = null;
    _cardsNewSimpleProposition.clear();
  }

  @override
  String toString() {
    displayParentheses() {
      if (currentConnective != null) {
        final currentConnective = this.currentConnective!;
        if (currentConnective.isConjunction ||
            currentConnective.isInclusiveDisjunction) {
          if (_proposition is _CompoundProposition) {
            // Verifica se há conectivos diferentes nesta sentença.
            final assortedConnectives = _proposition!.cards
                .where((card) => card.isConnective)
                .any((connective) => connective.type != currentConnective.type);
            return assortedConnectives;
          }
        }
      }
      return _proposition is _CompoundProposition;
    }

    final isProposition = isWellFormedFormula();
    return [
      if (isProposition) _proposition.toString(),
      if (!isProposition && _proposition != null)
        displayParentheses()
            ? '(${_proposition.toString()})'
            : _proposition.toString(),
      if (currentConnective != null) currentConnective!.latexCode,
      ..._cardsNewSimpleProposition.map((e) => e.latexCode),
    ].join(' ');
  }
}
