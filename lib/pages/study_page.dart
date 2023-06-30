import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flash_language/helpers/card_helpers.dart';
import 'package:flash_language/helpers/const.dart';
import 'package:flash_language/helpers/translation_helpers.dart';
import 'package:flash_language/main.dart';
import 'package:flash_language/providers/card_provider.dart';
import 'package:flash_language/providers/metadata_provider.dart';
import 'package:flash_language/widgets/input_widget.dart';
import 'package:flash_language/widgets/langauge_select_widget.dart';
import 'package:flash_language/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:riverpod/riverpod.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  CardList? CardListReader;
  Random random = new Random();
  final LocalStorage storage = LocalStorage('cards.json');
  int selectedCard = -1;
  bool tapped = false;
  List<CardData> filteredCards = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      CardListReader = ref.read(CardListProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    MetadataState metadata = ref.watch(MetaDataProvider);
    List<CardData> cards = ref.watch(CardListProvider);
    setState(() {
      if (filteredCards.isEmpty) {
        selectedCard = -1;
        filteredCards = sortCardsBySelection(
            cards, metadata.inLanguage, metadata.outLanguage);
        filteredCards.shuffle();
        if (filteredCards.isNotEmpty) {
          selectedCard = 0;
        }
      }
    });

    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const LangaugeSelectWidget(),
                Container(
                    child: selectedCard >= 0
                        ? ResultCard(
                            onTap: () {
                              setState(() {
                                tapped = !tapped;
                              });
                            },
                            body: tapped
                                ? filteredCards[selectedCard].header
                                : filteredCards[selectedCard].body,
                            header: tapped
                                ? 'The ${metadata.inLanguage} word for ${filteredCards[selectedCard].body} is'
                                : 'What is the ${metadata.inLanguage} word for:',
                            bodyTextSize: 20,
                            headerTextSize: 15,
                          )
                        : null),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Row(children: [
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              selectedCard =
                                  (selectedCard + 1) % filteredCards.length;
                              tapped = false;
                            });
                          },
                          child: const Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
                              child: Text('Back'))),
                      Expanded(child: Container()),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              selectedCard =
                                  (selectedCard + 1) % filteredCards.length;
                              tapped = false;
                            });
                          },
                          child: const Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
                              child: Text('Next'))),
                    ])),
              ],
            )));
  }
}
