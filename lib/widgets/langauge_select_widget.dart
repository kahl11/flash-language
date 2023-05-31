import 'package:flash_language/helpers/const.dart';
import 'package:flash_language/main.dart';
import 'package:flash_language/widgets/drop_down_language.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';

class LangaugeSelectWidget extends ConsumerStatefulWidget {
  const LangaugeSelectWidget({Key? key}) : super(key: key);

  @override
  _LangaugeSelectWidgetState createState() => _LangaugeSelectWidgetState();
}

class _LangaugeSelectWidgetState extends ConsumerState<LangaugeSelectWidget> {
  final LocalStorage storage = LocalStorage('settings.json');

  @override
  Widget build(BuildContext context) {
    dynamic MetadataReader = ref.read(MetaDataProvider.notifier);
    dynamic MetadataWatcher = ref.watch(MetaDataProvider);
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: DropDownLanguage(
                                key: const Key('inLang'),
                                onSelect: (s) {
                                  storage.setItem('inLanguage', s);
                                  MetadataReader.update('inLanguage', s);
                                },
                                value: MetadataWatcher.inLanguage))),
                    IconButton(
                        onPressed: () async {
                          String inLang = MetadataWatcher.inLanguage;
                          String outLang = MetadataWatcher.outLanguage;
                          await storage.setItem('inLanguage', outLang);
                          MetadataReader.update('inLanguage', outLang);
                          await storage.setItem('outLanguage', inLang);
                          MetadataReader.update('outLanguage', inLang);
                        },
                        icon: const Icon(Icons.swap_horiz)),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: DropDownLanguage(
                                key: const Key('outLang'),
                                onSelect: (s) {
                                  storage.setItem('outLanguage', s);
                                  MetadataReader.update('outLanguage', s);
                                },
                                value: MetadataWatcher.outLanguage)))
                  ]));
        });
  }
}
