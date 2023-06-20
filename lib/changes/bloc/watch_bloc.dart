import 'package:acml/src/data/repository/watchlist/watchlist_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:msil_library/models/base/base_request.dart';
import 'package:msil_library/streamer/models/stream_response_model.dart';

import '../../src/data/store/app_utils.dart';
import '../../src/models/common/symbols_model.dart';
import '../../src/models/watchlist/watchlist_group_model.dart';
import '../../src/models/watchlist/watchlist_symbols_model.dart';
import '../repository/watch_repository.dart';
import '../widgets/filter_bottomsheet.dart';

part 'watch_event.dart';
part 'watch_state.dart';

class WatchBloc extends Bloc<WatchEvent, WatchState> {

  WatchLoadedState watchLoadedState = WatchLoadedState();


  List<WatchlistSymbolsModel> unChangedArr = [];

  WatchBloc() : super(WatchLoadingState()) {
    on<LoadWatchEvent>((event, emit) async {
      emit(WatchLoadingState());

      try {
        final BaseRequest request = BaseRequest();
        final WatchlistGroupModel groupModel = await WatchRepository().getWatchlistGroupsRequest(request);

        var symbols          = await _handleWatchlistGetSymbolsEvent(groupModel);
        var unChangedSymbols = await _handleWatchlistGetSymbolsEvent(groupModel);

        watchLoadedState.watchlistGroupModel = groupModel; 
        watchLoadedState.symbolsModelList = symbols;
        unChangedArr = unChangedSymbols;

        emit(watchLoadedState);
        // emit(WatchLoadedState(groupModel, symbolsModelList));
      } catch (e) {
        emit(WatchErrorState(e.toString()));
      }
    });

    on<StreamingResponseEvent>((event, emit) {
      responseCallback(event.data, event.selectedTabIndex, emit);
    });

    on<SearchEvent>((event, emit) {
      searchCallback(event.searchText, event.selectedTabIndex, emit);

      // emit(watchLoadedState);
    });

    on<SortEvent>((event, emit) {
      sortUsers(event.sortType, event.selectedTabIndex, emit);

      //watchLoadedState.enumSortType = event.enumSortType;
      emit(WatchChangeState());
      emit(watchLoadedState);
    });

   
  }

  void sortUsers(String sortType, int selectedTabIndex, Emitter<WatchState> emit) {
//double.parse(AppUtils().decimalValue(b.ltp));

 List<Symbols> symbols = watchLoadedState.symbolsModelList![selectedTabIndex].symbols;

    if (sortType.toLowerCase() == 'Low to High'.toLowerCase()) { // numeric ascending
     
      symbols.sort((a, b) {
        return num.parse(a.chngPer ?? '0')
            .compareTo(num.parse(b.chngPer ?? '0'));
      });

    } else if (sortType.toLowerCase() == 'High to Low'.toLowerCase()) {  // numeric descending
     
      symbols.sort((b, a) => num.parse(a.chngPer ?? '0').compareTo(num.parse(b.chngPer ?? '0')));
    
    } else if (sortType.toLowerCase() == 'A to Z'.toLowerCase()) {// alpha ascending

      symbols.sort((a, b) => a.dispSym!.compareTo(b.dispSym!));
   
    } else if (sortType.toLowerCase() == 'Z to A'.toLowerCase()) { // alpha descending
     
      symbols.sort((b, a) => a.dispSym!.compareTo(b.dispSym!));
    }

    watchLoadedState.symbolsModelList![selectedTabIndex].symbols = symbols;
  }

  Future<void> searchCallback(
      String searchText, int selectedTabIndex, Emitter<WatchState> emit) async {
    // if (watchLoadedState.symbolsModelList != null) {

    List<Symbols> symbols = unChangedArr[selectedTabIndex].symbols;

    watchLoadedState.symbolsModelList![selectedTabIndex].symbols =
        List<Symbols>.from(symbols).where((element) {
      return element.dispSym!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    if (searchText == "") {
      watchLoadedState.symbolsModelList![selectedTabIndex].symbols = symbols;
    }

    emit(WatchChangeState());
    emit(watchLoadedState);

    //  }
  }

  Future<void> responseCallback(ResponseData streamData, int selectedTabIndex,
      Emitter<WatchState> emit) async {
    if (watchLoadedState.symbolsModelList != null) {
      final List<Symbols> symbols =
          watchLoadedState.symbolsModelList![selectedTabIndex].symbols;

      final int index = symbols.indexWhere((Symbols element) {
        return element.sym!.streamSym == streamData.symbol;
      });

      if (index != -1) {
        symbols[index] = updateStreamData(symbols[index], streamData);
        watchLoadedState.symbolsModelList![selectedTabIndex].symbols[index] =
            symbols[index];

        emit(WatchChangeState());
        emit(watchLoadedState);

        // emit(WatchLoadedState(groupModel, existingSymbolsModel));
        //   emit(WatchChangeState(groupModel, existingSymbolsModel));
      }
    }
  }

  Symbols updateStreamData(Symbols symbol, ResponseData streamData) {
    symbol.close = streamData.close ?? symbol.close;
    symbol.ltp = streamData.ltp ?? symbol.ltp;
    symbol.chng = streamData.chng ?? symbol.chng;
    symbol.chngPer = streamData.chngPer ?? symbol.chng;
    symbol.yhigh = streamData.yHigh ?? symbol.yhigh;
    symbol.ylow = streamData.yLow ?? symbol.ylow;
    symbol.high = streamData.high ?? symbol.high;
    symbol.low = streamData.low ?? symbol.low;

    return symbol;
  }

  Future<List<WatchlistSymbolsModel>> _handleWatchlistGetSymbolsEvent(WatchlistGroupModel model) async {

    List<WatchlistSymbolsModel> symbolsModelList = [];
    WatchlistSymbolsModel? symbolModel;

    model.groups?.forEach((element) async {
      Groups group = Groups();

      group.wName = element.wName;
      group.wId = element.wId;
      group.editable = element.editable;
      group.defaultMarketWatch = element.defaultMarketWatch;

      try {
        final BaseRequest request = BaseRequest(data: group.toJson());

        symbolModel = await WatchRepository().getWatchlistSymbolsRequest(request, wId: group.wId!);
        if (symbolModel != null) {
           symbolsModelList.add(symbolModel!);
        }else {
          print(symbolModel);
        }
       
      } catch (e) {
        emit(WatchErrorState(e.toString()));
      }
    });

    return symbolsModelList;
  }
}
