import 'package:acml/changes/bloc/watch_bloc.dart';
import 'package:acml/src/models/watchlist/watchlist_group_model.dart';
import 'package:acml/src/models/watchlist/watchlist_symbols_model.dart';
import 'package:acml/src/ui/screens/base/base_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msil_library/streamer/models/stream_response_model.dart';

import '../../src/constants/app_constants.dart';
import '../../src/data/store/app_helper.dart';
import '../../src/models/common/symbols_model.dart';

class WatchlistTab extends BaseScreen {

  int selectedTabIndex;
  WatchlistGroupModel watchlistGroupModel;
  WatchlistSymbolsModel symbolsModel;
  WatchlistTab({required this.selectedTabIndex, required this.watchlistGroupModel, required this.symbolsModel, super.key});

  @override
  State<WatchlistTab> createState() => _WatchlistTabState();
}

class _WatchlistTabState extends BaseAuthScreenState<WatchlistTab> {

  late WatchBloc _watchBloc;

  @override
  void initState() {

    final List<String> streamingKeys = <String>[
      AppConstants.streamingLtp,
      AppConstants.streamingChng,
      AppConstants.streamingChgnPer,
      AppConstants.streamingHigh,
      AppConstants.high,
      AppConstants.low,
      AppConstants.streamingLow,
    ];

    final streamDetails = AppHelper().streamDetails(widget.symbolsModel.symbols, streamingKeys);

    subscribeLevel1(streamDetails);
    super.initState();

  }

  @override
  String getScreenRoute() {
    // TODO: implement getScreenRoute
    return '${widget.watchlistGroupModel.groups![widget.selectedTabIndex].wId}';  //'${widget.watchlistGroupModel[]}';
  }

  @override
  void dispose() {
    unsubscribeLevel1();
    super.dispose();
  }

  @override
  void quote1responseCallback(ResponseData data) {

     BlocProvider.of<WatchBloc>(context).add(StreamingResponseEvent(data, widget.selectedTabIndex));
  //  _watchBloc.add(NewWatchlistStreamingResponseEvent(data));
    print(data.toJson());
    super.quote1responseCallback(data);
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: widget.symbolsModel.symbols.length,
        shrinkWrap: true,
        // separatorBuilder: (_, index) {
        //   return const Divider();
        // },
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              color: Colors.black,
              child: Column(
                
                children: [
                  ListTile(
                    //tileColor: Colors.blue,
                   // dense: true,
                   // contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -1.75),
                    title: Text('${widget.symbolsModel.symbols[index].dispSym}',
                        style: const TextStyle(color: Colors.white, fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text('${widget.symbolsModel.symbols[index].sym?.exc}',
                            style:
                                const TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                    trailing:
                      
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.symbolsModel.symbols[index].ltp ?? '--',
                                style: getStyle(widget.symbolsModel.symbols[index]), //TextStyle(color: Colors.green, fontSize: 18),
                              ),
                              getIcon(widget.symbolsModel.symbols[index])
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children:
                                getBottomText(widget.symbolsModel.symbols[index]),
                            // children: [
                            //   Text('${element.symbols[index].chng}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                            //   const SizedBox(width: 10),
                            //   Text('(${element.symbols[index].chngPer}%)',style: const TextStyle(color: Colors.white, fontSize: 15)),
                            // ],
                          ),
                        ],
                      ),
                    
                  ),
              //const SizedBox(height: 0,),
                Container(height: 0.5, color: Colors.white,)
                ],
              ),
            ),
          );
        });
    ;
  }

  Text getText(String data) {
    return Text(data,
        style: const TextStyle(color: Colors.white, fontSize: 15));
  }

  List<Widget> getBottomText(Symbols symbols) {
    if (symbols.chng == null) {
      return [];
    }

    if (symbols.chng!.contains('-')) {
      return [
        getText(symbols.chng ?? '--'),
        const SizedBox(width: 10),
        getText('(${symbols.chngPer ?? '--'}%)')
      ];
    } else {
      return [
        getText('+${symbols.chng ?? '--'}'),
        const SizedBox(width: 10),
        getText('(+${symbols.chngPer ?? '--'}%)')

      ];
    }
  }

  TextStyle getStyle(Symbols symbols) {
    if (symbols.chng != null) {
      if (symbols.chng!.contains('-')) {
        return const TextStyle(color: Colors.red, fontSize: 18);
      } else {
        return const TextStyle(color: Colors.green, fontSize: 18);
      }
    } else {
      return const TextStyle(color: Colors.white, fontSize: 18);
    }
  }

  Icon getIcon(Symbols symbols) {
    if (symbols.chng == null) {
      return const Icon(
        Icons.arrow_downward_sharp,
        color: Colors.black,
        size: 30.0,
      );
    }

    if (symbols.chng!.contains('-')) {
      return const Icon(
        Icons.arrow_drop_down,
        color: Colors.red,
        size: 30.0,
      );
    } else {
      return const Icon(
        Icons.arrow_drop_up,
        color: Colors.green,
        size: 30.0,
      );
    }
  }
}
