import 'dart:convert';

int _hexCharPairToByte(String s, int pos) {
  int byte = 0;
  for (int i = 0; i < 2; i++) {
    var charCode = s.codeUnitAt(pos + i);
    if (0x30 <= charCode && charCode <= 0x39) {
      byte = byte * 16 + charCode - 0x30;
    } else {
      // Check ranges A-F (0x41-0x46) and a-f (0x61-0x66).
      charCode |= 0x20;
      if (0x61 <= charCode && charCode <= 0x66) {
        byte = byte * 16 + charCode - 0x57;
      } else {
        throw ArgumentError("Invalid URL encoding");
      }
    }
  }
  return byte;
}

/// Custom url decoder since the dart one is complaining about non-english chars
String customUriDecode(String text) {
  int start = 0;
  int end = text.length;
  assert(0 <= start);
  assert(start <= end);
  assert(end <= text.length);
  List<int> bytes;
  bytes = <int>[];
  for (int i = start; i < end; i++) {
    var codeUnit = text.codeUnitAt(i);
    if (codeUnit == 0x25) {
      if (i + 3 > text.length) {
        throw ArgumentError('Truncated URI');
      }
      bytes.add(_hexCharPairToByte(text, i + 1));
      i += 2;
    } else {
      bytes.add(codeUnit);
    }
  }
  return String.fromCharCodes(bytes);
}
