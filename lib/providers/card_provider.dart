import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class CardData {
  final String? body;
  final String? header;
  final String inLanguage;
  final String outLanguage;
  CardData(
      {required this.body,
      required this.header,
      required this.inLanguage,
      required this.outLanguage});

  CardData.fromJson(Map<String, String> json)
      : body = json["body"],
        header = json["header"],
        inLanguage = json["inLanguage"] ?? '',
        outLanguage = json["outLanguage"] ?? '';

  Map<String, String> toJson() => {
        'body': body!,
        'header': header!,
        'inLanguage': inLanguage,
        'outLanguage': outLanguage
      };
}

class CardList extends StateNotifier<List<CardData>> {
  CardList([List<CardData>? initialList]) : super(initialList ?? []);

  /// adds a new Card to the end of the list
  void add(String header, String body, String inLanguage, String outLanguage) {
    state = [
      ...state,
      CardData(
          header: header,
          body: body,
          inLanguage: inLanguage,
          outLanguage: outLanguage),
    ];
  }

  void push(CardData card) {
    state = [...state, card];
  }

  int length() {
    return state.length;
  }

  void update(List<CardData> cards) {
    state = cards;
  }

  void removeAtIndex(i) {
    List<CardData> tmp = List.from(state);
    tmp.removeAt(i);
    state = tmp;
  }

  List<CardData> getCards() {
    return state;
  }

  Iterable<Map<String, String>> getSerializedCardList() {
    return state.map((e) => e.toJson()).toList();
  }
}
