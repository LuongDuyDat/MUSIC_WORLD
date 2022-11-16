import 'dart:math';

import 'package:hive/hive.dart';
import 'package:music_world_app/repositories/search_repository/models/search.dart';

class SearchRepository {
  final Box<Search> searchBox;

  SearchRepository({
    required this.searchBox,
  });

  void addSearch(String searchContent, String searcherId, DateTime searchAt) {
    var items = searchBox.values.where((element) {
      if (element.searchContent == searchContent) {
        return true;
      }
      return false;
    }).toList();

    if (items.isEmpty) {
      Search s = Search(searchContent: searchContent, searcherId: searcherId, searchAt: searchAt);
      searchBox.add(s);
    } else {
      int number = items.elementAt(0).number + 1;
      Search s = Search(searchContent: searchContent, searcherId: searcherId, searchAt: searchAt, number: number);
      searchBox.delete(items.elementAt(0).key);
      searchBox.add(s);
    }
  }

  Stream<Search> getRecentlySearch(String searcherId) async* {
    var items = searchBox.values.where((element) {
      if (element.searcherId == searcherId) {
        return true;
      }
      return false;
    }).toList();
    items.sort((b, a) => a.searchAt.compareTo(b.searchAt));
    for (int i = 0; i < min(items.length, 3); i++) {
      yield items[i];
    }
  }

  Stream<Search> getTopSearch() async* {
    var items = searchBox.values.toList();
    items.sort((b, a) => a.number.compareTo(b.number));
    for (int i = 0; i < min(items.length, 3); i++) {
      yield items[i];
    }
  }
}