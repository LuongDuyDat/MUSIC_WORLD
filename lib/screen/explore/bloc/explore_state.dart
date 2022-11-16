import 'package:equatable/equatable.dart';

import '../../../repositories/song_repository/models/song.dart';

enum ExploreStatus {initial, loading, success, failure}

class ExploreState extends Equatable {
  const ExploreState({
    this.songChart = const[],
    this.songChartStatus = ExploreStatus.initial,
    this.hasMoreSongChart = true,
  });

  final List<Song> songChart;
  final ExploreStatus songChartStatus;
  final bool hasMoreSongChart;

  ExploreState copyWith({
    ExploreStatus Function()? songChartStatus,
    List<Song> Function()? songChart,
    bool Function()? hasMoreSongChart,
  }) {
    return ExploreState(
      songChartStatus: songChartStatus != null ? songChartStatus() : this.songChartStatus,
      songChart: songChart != null ? songChart() : this.songChart,
      hasMoreSongChart: hasMoreSongChart != null ? hasMoreSongChart() : this.hasMoreSongChart,
    );
  }

  @override
  List<Object?> get props => [
    songChart,
    songChartStatus,
    hasMoreSongChart,
  ];

}