abstract class HomeEvent {}

class HomeLoadEvent extends HomeEvent {}

class SearchEvent extends HomeEvent {
  SearchEvent(this.query);
  final String query;
}
