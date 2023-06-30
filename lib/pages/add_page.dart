import 'dart:convert';

import 'package:flash_language/helpers/card_helpers.dart';
import 'package:flash_language/helpers/const.dart';
import 'package:flash_language/helpers/translation_helpers.dart';
import 'package:flash_language/helpers/utils.dart';
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

class AddPage extends ConsumerStatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  CardList? CardListReader;
  final LocalStorage storage = LocalStorage('cards.json');
  int selectedCard = -1;

  Future<void> addTranslation(String text) async {
    final LocalStorage storage = LocalStorage('settings.json');
    String? outLanguage = LANGUAGES[storage.getItem('outLanguage')];
    String? inLanguage = LANGUAGES[storage.getItem('inLanguage')];

    Response resp = await getTranslation(text, inLanguage, outLanguage);
    dynamic data = jsonDecode(utf8.decode(resp.bodyBytes));
    if (CardListReader != null) {
      String translated = customUriDecode(data["translations"][0]["text"]);
      CardListReader!.add(text, translated, inLanguage!, outLanguage!);
      dynamic cards = CardListReader!.getSerializedCardList();
      storage.setItem('cards', cards);
    }
  }

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
    List<CardData> filteredCards =
        sortCardsBySelection(cards, metadata.inLanguage, metadata.outLanguage);
    ref.listen(CardListProvider, (previousState, List<CardData> newState) {
      setState(() {
        selectedCard = -1;
      });
    });
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedCard = -1;
          });
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const LangaugeSelectWidget(),
                InputWidget(onSubmit: (s) {
                  addTranslation(s);
                }),
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        width: double.infinity,
                        child: filteredCards.isEmpty
                            ? ResultCard(
                                header: 'Result',
                                body:
                                    'search a term above to get the translation and create a new card')
                            : ListView(
                                shrinkWrap: true,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                    for (var i = filteredCards.length - 1;
                                        i >= 0;
                                        i--) ...[
                                      ResultCard(
                                          index: i,
                                          onLongPress: () {
                                            setState(() {
                                              selectedCard = i;
                                            });
                                          },
                                          isSelected: selectedCard == i,
                                          header: filteredCards[i].header,
                                          body: filteredCards[i].body)
                                    ]
                                  ]))),
              ],
            )));
  }
}
