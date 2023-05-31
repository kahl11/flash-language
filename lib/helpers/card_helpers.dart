import 'dart:ffi';

import 'package:flash_language/helpers/const.dart';
import 'package:flash_language/providers/card_provider.dart';

bool matchesLangOptions(CardData card, String inLanguage, String outLanguage) {
  return card.inLanguage == LANGUAGES[inLanguage] &&
      card.outLanguage == LANGUAGES[outLanguage];
}

List<CardData> sortCardsBySelection(
    List<CardData> cardList, inLanguage, outLanguage) {
  List<CardData> copy = List.from(cardList);
  copy.retainWhere((c) {
    return matchesLangOptions(c, inLanguage, outLanguage);
  });
  return copy;
}
