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

/// ViewModel for MainPage (MVVM)
class MainViewModel extends ChangeNotifier {
  // BottomNavigationBar 현재 선택 인덱스
  int currentIndex = 0;

  // 연습 시간 데이터 (예시)
  int practiceHours = 21;
  int practiceMinutes = 37;

  // 주간 인기곡 예시 데이터
  List<PopularSong> weeklySongs = List.generate(
    10,
    (i) => PopularSong(
      rank: i + 1,
      title: '곡 제목 ${i + 1}',
      artist: '아티스트 ${i + 1}',
      thumbnailUrl: 'assets/images/song_${i + 1}.png',
    ),
  );

  // 다음 합주 일정 예시
  Schedule nextSchedule = Schedule(
    name: '정기 합주',
    organizer: '멜렐라 팀',
    location: '학생회관 지하 1층',
    date: '4월 14일 (월)',
    time: '18:00 ~ 19:00',
    daysRemaining: 0,
  );

  /// BottomNavigationBar 탭 변경 핸들러
  void onTabChanged(int index) {
    currentIndex = index;
    // TODO: 페이지 네비게이션 로직 구현
    notifyListeners();
  }
}
