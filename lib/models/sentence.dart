import 'package:flutter/foundation.dart';

import 'card.dart';

class Sentence {
  Sentence({
    List<Card>? cards,
  }) : cards = cards?.toList() ?? <Card>[];

  final List<Card> cards;

  int get numCards => cards.length;

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

  bool isSimpleProposition() {
    return (getValue() != null) && numCards < 3;
  }

  bool isCompoundProposition() {
    return (getValue() != null) && numCards > 2;
  }

  bool? getValue() {
    if (cards.isEmpty) {
      return null;
    }
    try {
      return _getValue(cards);
    } on StateError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  /// A ordem de precedência dos conectivos é (da maior para a menor): ¬, ∧, (∨ ou ⊻), → e ↔
  bool _getValue(List<Card> list) {
    // Como as chamadas são recursivas, elas analisam a expressão da direita para a esquerda e os conectivos na ordem inversa.
    int indexConnective = list.lastIndexWhere((card) => card.isBiconditional);
    if (indexConnective == -1) {
      indexConnective = list.lastIndexWhere((card) => card.isConditional);
    }
    if (indexConnective == -1) {
      indexConnective = list.lastIndexWhere(
        (card) => card.isInclusiveDisjunction || card.isExclusiveDisjunction,
      );
    }
    if (indexConnective == -1) {
      indexConnective = list.lastIndexWhere((card) => card.isConjunction);
    }

    var connective = (indexConnective == -1) ? null : list[indexConnective];
    List<Card> firstSentence =
        (connective == null) ? list.toList() : list.sublist(0, indexConnective);
    List<Card> lastSentence =
        (connective == null) ? [] : list.sublist(indexConnective + 1);

    bool firstSentenceValue;
    if (connective == null) {
      firstSentenceValue = _getSimplePropositionValue(firstSentence);
      return firstSentenceValue;
    } else {
      firstSentenceValue = _getValue(firstSentence);
    }

    var lastSentenceValue = _getValue(lastSentence);

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
        return firstSentenceValue && lastSentenceValue;
      case TypesCards.inclusiveDisjunction:
        return firstSentenceValue || lastSentenceValue;
      case TypesCards.exclusiveDisjunction:
        return xor(firstSentenceValue, lastSentenceValue);
      case TypesCards.conditional:
        return conditional(firstSentenceValue, lastSentenceValue);
      case TypesCards.biconditional:
        return biconditional(firstSentenceValue, lastSentenceValue);
      default:
        throw StateError('Conectivo não identificado.');
    }
  }

  bool _getSimplePropositionValue(List<Card> proposition) {
    if (proposition.isEmpty) {
      throw StateError('A proposição deve ter no mínimo uma carta.');
    }
    if (proposition.length == 1) {
      switch (proposition.single.type) {
        case TypesCards.vTrue:
          return true;
        case TypesCards.vFalse:
          return false;
        default:
      }
    }
    if (proposition.length == 2) {
      if (proposition[0].isNegation) {
        return !_getSimplePropositionValue([proposition[1]]);
      }
    }
    if (proposition.length > 2) {
      throw StateError('A proposição deve ter no máximo duas cartas.');
    }
    throw StateError('Há um erro de sintaxe na proposição.');
  }
}
