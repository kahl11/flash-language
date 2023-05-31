import 'dart:convert';

import 'package:flash_language/helpers/const.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

Future<http.Response> getTranslation(String text, inLanguage, outLanguage) {
  String encodedText = Uri.encodeFull(text);
  var params = new Map<String, dynamic>();
  params["text"] = encodedText;
  params["target_lang"] = outLanguage;
  params["source_lang"] = inLanguage;
  return http.post(Uri.parse('https://api-free.deepl.com/v2/translate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'DeepL-Auth-Key 24b38963-0e27-bdc3-942a-82698f325033:fx'
      },
      body: params);
}
