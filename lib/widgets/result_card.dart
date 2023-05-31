import 'package:flash_language/main.dart';
import 'package:flash_language/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultCard extends ConsumerStatefulWidget {
  String? header = '';
  String? body = '';
  int? index;
  bool isSelected = false;
  double bodyTextSize = 15;
  double headerTextSize = 20;
  void Function()? onLongPress;
  void Function()? onTap;
  ResultCard({
    Key? key,
    this.header,
    this.body,
    this.onLongPress,
    this.index,
    this.onTap,
    this.isSelected = false,
    this.bodyTextSize = 15,
    this.headerTextSize = 20,
  }) : super(key: key);

  @override
  _ResultCardState createState() => _ResultCardState();
}

class _ResultCardState extends ConsumerState<ResultCard> {
  bool doShake = false;
  bool fingerDown = false;
  @override
  Widget build(BuildContext context) {
    CardList CardListReader = ref.read(CardListProvider.notifier);
    return Container(
        child: GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            onLongPressDown: (details) {
              setState(() {
                fingerDown = true;
              });
            },
            onLongPressUp: () {
              setState(() {
                fingerDown = false;
              });
            },
            onLongPressCancel: () {
              setState(() {
                fingerDown = false;
              });
            },
            onLongPress: () {
              setState(() {
                doShake = true;
              });
              Future.delayed(const Duration(milliseconds: 400), () {
                setState(() {
                  setState(() {
                    doShake = false;
                  });
                });
              });
              if (widget.onLongPress != null) {
                widget.onLongPress!();
              }
            },
            child: ShakeWidget(
                autoPlay: doShake,
                shakeConstant: ShakeLittleConstant1(),
                child: Card(
                    color: fingerDown ? Colors.grey[850] : null,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: Stack(children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color:
                                            Theme.of(context).primaryColor))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            width: double.infinity,
                            child: Text(widget.header!,
                                style: TextStyle(
                                    fontSize: widget.headerTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: double.infinity,
                                  minWidth: double.infinity),
                              child: Text(widget.body!,
                                  style:
                                      TextStyle(fontSize: widget.bodyTextSize)))
                        ],
                      ),
                      if (widget.isSelected)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        size: 30,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: (() => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text(
                                                  'Delete "${widget.header}" card'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    if (widget.index != null) {
                                                      CardListReader
                                                          .removeAtIndex(
                                                              widget.index);
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          ))))
                            ]),
                    ])))));
  }
}
