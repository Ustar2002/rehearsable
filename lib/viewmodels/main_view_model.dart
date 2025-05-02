import 'package:flutter/material.dart';

/// Model representing a popular song
class PopularSong {
  final int rank;
  final String title;
  final String artist;
  final String thumbnailUrl; // 경로 혹은 네트워크 URL

  PopularSong({
    required this.rank,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
  });
}

/// Model representing the next rehearsal schedule
class Schedule {
  final String name;
  final String organizer;
  final String location;
  final String date;
  final String time;
  final int daysRemaining;

  Schedule({
    required this.name,
    required this.organizer,
    required this.location,
    required this.date,
    required this.time,
    required this.daysRemaining,
  });
}
/// Model representing practice statistics
class PracticeStats {
  final int totalHours;
  final int totalMinutes;
  final int avgDailyHours;
  final int avgDailyMinutes;
  final double weekChangePercent;
  final int practicedDays;
  final List<List<int>> heatmap; // 7 days x slots
  final List<int> slotCounts;    // 시간대별 연습 횟수
  final double goalCompletion;    // 0.0 ~ 1.0
  final Map<String, double> categoryDistribution; // 이름: 비율
  final List<String> topSongs;
  final List<String> topTempos;

  PracticeStats({
    required this.totalHours,
    required this.totalMinutes,
    required this.avgDailyHours,
    required this.avgDailyMinutes,
    required this.weekChangePercent,
    required this.practicedDays,
    required this.heatmap,
    required this.slotCounts,
    required this.goalCompletion,
    required this.categoryDistribution,
    required this.topSongs,
    required this.topTempos,
  });
}



/// ViewModel for MainPage and StatsPage
class MainViewModel extends ChangeNotifier {
  int currentIndex = 0;

  // Practice time
  int practiceHours = 21;
  int practiceMinutes = 37;
  PracticeStats stats = PracticeStats(
    totalHours: 21,
    totalMinutes: 37,
    avgDailyHours: 3,
    avgDailyMinutes: 5,
    weekChangePercent: 10.0,
    practicedDays: 6,
    heatmap: [ // 월-일, 7x7 placeholder
      [0,1,2,3,4,5,6],
      [1,0,1,2,3,2,1],
      [2,1,0,1,2,1,0],
      [3,2,1,0,1,2,3],
      [4,3,2,1,0,1,2],
      [5,4,3,2,1,0,1],
      [6,5,4,3,2,1,0],
    ],
    slotCounts: [1,2,3,4,5,6],
    goalCompletion: 0.88,
    categoryDistribution: {'악보': 0.3, '메트로놈': 0.7},
    topSongs: ['사랑으로', 'Love Ya!', 'Drowning'],
    topTempos: ['72 bpm', '80 bpm', '90 bpm'],
  );

  List<PopularSong> weeklySongs = List.generate(
    10,
    (i) => PopularSong(
      rank: i + 1,
      title: '곡 제목 ${i + 1}',
      artist: '아티스트 ${i + 1}',
      thumbnailUrl: 'assets/images/song_${i + 1}.png',
    ),
  );
  Schedule nextSchedule = Schedule(
    name: '정기 합주',
    organizer: '멜렐라 팀',
    location: '학생회관 지하 1층',
    date: '4월 14일 (월)',
    time: '18:00 ~ 19:00',
    daysRemaining: 0,
  );

  void onTabChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
