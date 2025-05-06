// lib/viewmodels/main_view_model.dart
import 'package:flutter/material.dart';
import '../models/schedule.dart' show Reservation; // 예약용 모델

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

/// Model representing the next rehearsal schedule (대시보드용)
class Schedule {
  final String name;
  final String organizer;
  final String location;
  final String date; // ex: '4월 14일 (월)'
  final String time; // ex: '18:00 ~ 19:00'
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
  final double goalCompletion;   // 0.0 ~ 1.0
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

/// ViewModel for MainPage, StatsPage, ReservationPage, ScoresPage
class MainViewModel extends ChangeNotifier {
  // ─────────────────────────────────────────────────────────────
  // 탭 인덱스
  int currentIndex = 0;

  // ─────────────────────────────────────────────────────────────
  // 대시보드: 연습 시간
  int practiceHours = 21;
  int practiceMinutes = 37;

  // 통계
  PracticeStats stats = PracticeStats(
    totalHours: 21,
    totalMinutes: 37,
    avgDailyHours: 3,
    avgDailyMinutes: 5,
    weekChangePercent: 10.0,
    practicedDays: 6,
    heatmap: [
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

  // 주간 인기곡
  List<PopularSong> weeklySongs = List.generate(
    10,
    (i) => PopularSong(
      rank: i + 1,
      title: '곡 제목 ${i + 1}',
      artist: '아티스트 ${i + 1}',
      thumbnailUrl: 'assets/images/song_${i + 1}.png',
    ),
  );

  // 대시보드: 다음 합주 일정
  Schedule nextSchedule = Schedule(
    name: '정기 합주',
    organizer: '멜렐라 팀',
    location: '학생회관 지하 1층',
    date: '4월 14일 (월)',
    time: '18:00 ~ 19:00',
    daysRemaining: 0,
  );

  // ─────────────────────────────────────────────────────────────
  // 예약 페이지 / Moyeora 탭에서 사용할 예약 스케줄 리스트
  final List<Reservation> _reservations = [];
  List<Reservation> get schedules => List.unmodifiable(_reservations);

  /// 예약 스케줄 추가
  void addSchedule({
    required String title,
    required String location,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) {
    _reservations.add(Reservation(
      title: title,
      location: location,
      date: date,
      startTime: startTime,
      endTime: endTime,
    ));
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────
  /// 탭 변경
  void onTabChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
