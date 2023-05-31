import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class MetadataState {
  final String? inLanguage;
  final String? outLanguage;
  MetadataState({
    required this.inLanguage,
    required this.outLanguage,
  });

  MetadataState.fromJson(Map<String, String> json)
      : inLanguage = json["inLanguage"],
        outLanguage = json["outLanguage"];

  Map<String, String> toJson() => {
        'inLanguage': inLanguage!,
        'outLanguage': outLanguage!,
      };
}

class Metadata extends StateNotifier<MetadataState> {
  Metadata(MetadataState? initialList) : super(initialList!);
  void update(String parameter, dynamic value) {
    switch (parameter) {
      case 'inLanguage':
        state =
            MetadataState(inLanguage: value, outLanguage: state.outLanguage);
        break;
      case 'outLanguage':
        state = MetadataState(inLanguage: state.inLanguage, outLanguage: value);
    }
  }

  String? getInLanguage() {
    return state.inLanguage;
  }

  String? getOutLanguage() {
    return state.outLanguage;
  }
}
