import 'package:flutter/material.dart';
import 'package:logiccards/colors.dart';

enum TypesCards {
  vTrue,
  vFalse,
  conjunction,
  inclusiveDisjunction,
  exclusiveDisjunction,
  conditional,
  biconditional,
  negation;

  String get latexCode {
    switch (this) {
      case TypesCards.vTrue:
        return 'V';
      case TypesCards.vFalse:
        return 'F';
      case TypesCards.conjunction:
        return r'\wedge';
      case TypesCards.inclusiveDisjunction:
        return r'\vee';
      case TypesCards.exclusiveDisjunction:
        return r'\veebar';
      case TypesCards.conditional:
        return r'\rightarrow';
      case TypesCards.biconditional:
        return r'\leftrightarrow';
      case TypesCards.negation:
        return r'\lnot';
      default:
        return '';
    }
  }

  String get imagePath {
    const parent = 'images/colorful/';
    switch (this) {
      case TypesCards.vTrue:
        return '${parent}verdadeiro.png';
      case TypesCards.vFalse:
        return '${parent}falso.png';
      case TypesCards.conjunction:
        return '${parent}conjuncao.png';
      case TypesCards.inclusiveDisjunction:
        return '${parent}disjuncao_inclusiva.png';
      case TypesCards.exclusiveDisjunction:
        return '${parent}disjuncao_exclusiva.png';
      case TypesCards.conditional:
        return '${parent}condicional.png';
      case TypesCards.biconditional:
        return '${parent}bicondicional.png';
      case TypesCards.negation:
        return '${parent}negacao.png';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case TypesCards.vTrue:
        return CardsColors.vTrue;
      case TypesCards.vFalse:
        return CardsColors.vFalse;
      case TypesCards.conjunction:
        return CardsColors.conjunction;
      case TypesCards.inclusiveDisjunction:
        return CardsColors.inclusiveDisjunction;
      case TypesCards.exclusiveDisjunction:
        return CardsColors.exclusiveDisjunction;
      case TypesCards.conditional:
        return CardsColors.conditional;
      case TypesCards.biconditional:
        return CardsColors.biconditional;
      case TypesCards.negation:
        return CardsColors.negation;
    }
  }

  bool get isConnective {
    return [
      TypesCards.biconditional,
      TypesCards.conditional,
      TypesCards.conjunction,
      TypesCards.exclusiveDisjunction,
      TypesCards.inclusiveDisjunction,
    ].contains(this);
  }

  bool get isValue {
    return [
      TypesCards.vTrue,
      TypesCards.vFalse,
    ].contains(this);
  }

  bool get isNegation => this == TypesCards.negation;

  bool get isTrue => this == TypesCards.vTrue;

  bool get isFalse => this == TypesCards.vFalse;

  bool get isConjunction => this == TypesCards.conjunction;

  bool get isExclusiveDisjunction => this == TypesCards.exclusiveDisjunction;

  bool get isInclusiveDisjunction => this == TypesCards.inclusiveDisjunction;

  bool get isConditional => this == TypesCards.conditional;

  bool get isBiconditional => this == TypesCards.biconditional;
}


class Card {
  Card(this.type);

  final TypesCards type;

  String get latexCode => type.latexCode;

  bool get isConnective => type.isConnective;

  bool get isValue => type.isValue;

  bool get isNegation => type.isNegation;

  bool get isTrue => type.isTrue;

  bool get isFalse => type.isFalse;

  bool get isConjunction => type.isConjunction;

  bool get isExclusiveDisjunction => type.isExclusiveDisjunction;

  bool get isInclusiveDisjunction => type.isInclusiveDisjunction;

  bool get isConditional => type.isConditional;

  bool get isBiconditional => type.isBiconditional;

}
