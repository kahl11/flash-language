import 'package:flash_language/helpers/card_helpers.dart';
import 'package:flash_language/pages/add_page.dart';
import 'package:flash_language/pages/study_page.dart';
import 'package:flash_language/providers/card_provider.dart';
import 'package:flash_language/providers/metadata_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';

final CardListProvider = StateNotifierProvider<CardList, List<CardData>>((ref) {
  return CardList([]);
});

final MetaDataProvider = StateNotifierProvider<Metadata, MetadataState>((ref) {
  return Metadata(MetadataState(inLanguage: 'English', outLanguage: 'German'));
});

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flash Language';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});
  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      final LocalStorage settings = LocalStorage('settings.json');
      await settings.ready;
      String? inLang = settings.getItem('inLanguage');
      String? outLang = settings.getItem('outLanguage');
      if (inLang == null) {
        settings.setItem('inLanguage', 'English');
        inLang = 'English';
      }
      if (outLang == null) {
        settings.setItem('outLanguage', 'German');
        outLang = 'German';
      }

      ref.read(MetaDataProvider.notifier).update('inLanguage', inLang);
      ref.read(MetaDataProvider.notifier).update('outLanguage', outLang);

      final LocalStorage cardStorage = LocalStorage('cards.json');
      await cardStorage.ready;
      List<dynamic>? data = cardStorage.getItem('cards');
      if (data != null) {
        for (var e in data) {
          CardData card = CardData(
              header: e["header"],
              body: e["body"],
              inLanguage: e['inLanguage'],
              outLanguage: e['outLanguage']);
          ref.read(CardListProvider.notifier).push(card);
        }
      }
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    AddPage(),
    StudyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flash Language',
        theme: ThemeData(
          filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))))),
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple[200],
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.dark,
              primary: Colors.deepPurple[200],
              secondary: Colors.deepPurple[800]),
        ),
        home: Scaffold(
          body: SafeArea(
              child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey[800],
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_rounded),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Study',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple[200],
            onTap: _onItemTapped,
          ),
        ));
  }
}
