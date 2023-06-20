part of 'watch_bloc.dart';

@immutable
abstract class WatchState {}

// data loading state
class WatchLoadingState extends WatchState {
}

// data loaded state
class WatchLoadedState extends WatchState {

  WatchlistGroupModel?          watchlistGroupModel;
  List<WatchlistSymbolsModel>?      symbolsModelList;
  //SortingType? enumSortType;
 // List<WatchlistSymbolsModel>?  tempSymbolsModelList;
  
 // WatchLoadedState(this.watchlistGroupModel, this.symbolsModelList); 
}

class GroupsLoadedState extends WatchState {
  WatchlistGroupModel?  watchlistGroupModel;
}

class WatchChangeState extends WatchState {}

// data loading error state
class WatchErrorState extends WatchState {

  final String error;
  WatchErrorState(this.error);   // Constructor
  
  @override
  List<Object?> get props => [error];
}

