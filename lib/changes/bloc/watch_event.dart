part of 'watch_bloc.dart';

@immutable
abstract class WatchEvent {}

class LoadWatchEvent extends WatchEvent {

  @override
  List<Object?> get props => [];
}

class StreamingResponseEvent extends WatchEvent {
  
  final int selectedTabIndex;
  ResponseData data;
  StreamingResponseEvent(this.data, this.selectedTabIndex);
}

class SearchEvent extends WatchEvent {

  String searchText;
  final int selectedTabIndex;

  SearchEvent({required this.searchText, required this.selectedTabIndex});
}


class SortEvent extends WatchEvent {
  // SortingType enumSortType;
   final int selectedTabIndex;
   final String sortType;

   SortEvent({required this.selectedTabIndex, required this.sortType});

}


