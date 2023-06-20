import 'package:flutter/material.dart';
import '../../src/models/common/symbols_model.dart';
import '../../src/models/watchlist/watchlist_group_model.dart';

class CustomWatchList {
// To get bottom text
  List<Widget> getBottomText(Symbols symbols) {
    if (symbols.chng!.contains('-')) {
      return [
        getText('${symbols.chng}'),
        const SizedBox(width: 10),
        getText('(${symbols.chngPer}%)')
      ];
    } else {
      return [
        getText('+${symbols.chng}'),
        const SizedBox(width: 10),
        getText('(+${symbols.chngPer}%)')

        // Text('+${symbols.chng}', style: const TextStyle(color: Colors.white, fontSize: 15)),
        // const SizedBox(width: 10),
        // Text('(+${symbols.chngPer}%)',style: const TextStyle(color: Colors.white, fontSize: 15))
      ];
    }
  }

  Text getText(String data) {
    return Text(data,
        style: const TextStyle(color: Colors.white, fontSize: 15));
  }

  // To get text style
  TextStyle getStyle(Symbols symbols) {
    if (symbols.chng!.contains('-')) {
      return const TextStyle(color: Colors.green, fontSize: 18);
    } else {
      return const TextStyle(color: Colors.red, fontSize: 18);
    }
  }

// To get updated down & up arrow
  Icon getIcon(Symbols symbols) {
    if (symbols.chng!.contains('-')) {
      return const Icon(
        Icons.arrow_downward_sharp,
        color: Colors.red,
        size: 20.0,
      );
    } else {
      return const Icon(
        Icons.arrow_downward_sharp,
        color: Colors.green,
        size: 20.0,
      );
    }
  }

  // List<Tab> getTabs(WatchlistGroupModel model) {
  //   List<Tab> tabsList = [];

  //   model.groups!.forEach((element) {
  //     tabsList.add(Tab(
  //       text: '${element.wName}',
  //     ));
  //   });
  //   // model.groups!.forEach((element) {
  //   //   tabsList.add(Tab(text: '${element.wName}'));
  //   // });

  //   return tabsList;
  // }
}
