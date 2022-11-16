import 'package:hive/hive.dart';

part 'search.g.dart';

@HiveType(typeId: 4)
class Search extends HiveObject{
  @HiveField(0)
  final String searchContent;
  @HiveField(1)
  final String searcherId;
  @HiveField(2)
  final DateTime searchAt;
  @HiveField(3)
  final int number;

  Search({
    required this.searchContent,
    required this.searcherId,
    required this.searchAt,
    this.number = 0,
  });
}