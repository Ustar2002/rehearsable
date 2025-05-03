// lib/views/main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/main_view_model.dart';
import 'stats_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const Divider(color: Colors.blueAccent, thickness: 2, height: 0),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _WeeklyPopularSection(songs: vm.weeklySongs),
                  const SizedBox(height: 16),
                  _PracticeTimeSection(
                    hours: vm.practiceHours,
                    minutes: vm.practiceMinutes,
                  ),
                  const SizedBox(height: 16),
                  _NextScheduleSection(schedule: vm.nextSchedule),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: vm.currentIndex,
        onTap: vm.onTabChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'M.M'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Moyeora'),
          BottomNavigationBarItem(icon: Icon(Icons.score), label: 'Scores'),
        ],
      ),
    );
  }
}

// AppBar 부분 분리
Widget _buildAppBar() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.account_circle, size: 28, color: Colors.white),
          Text(
            'Rehearsable',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.settings, size: 28, color: Colors.white),
        ],
      ),
    );

// 주간 인기곡 섹션
class _WeeklyPopularSection extends StatelessWidget {
  final List<PopularSong> songs;
  const _WeeklyPopularSection({required this.songs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('주간 인기곡',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text('악보 보러가기',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          // 날짜 범위
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('4월 7일 ~ 4월 13일',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          // 5x2 리스트
          Column(
            children: List.generate(5, (i) {
              final left = songs[i];
              final right = songs[i + 5];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SongItem(song: left),
                    _SongItem(song: right),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// 노래 아이템
class _SongItem extends StatelessWidget {
  final PopularSong song;
  const _SongItem({required this.song});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text('${song.rank}.',
              style: const TextStyle(
                  color: Colors.blueAccent, fontSize: 14)),
          const SizedBox(width: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(song.thumbnailUrl,
                width: 24, height: 24, fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.title,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis),
                Text(song.artist,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 10),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 이번주 연습시간 섹션
class _PracticeTimeSection extends StatelessWidget {
  final int hours;
  final int minutes;
  const _PracticeTimeSection({required this.hours, required this.minutes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const StatsPage()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀 & 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('이번주 연습시간은',
                    style: TextStyle(
                        color: Colors.white, fontSize: 14)),
                Text('자세히 보기',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            // 시간 표시
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('$hours',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Text('h',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20)),
                  const SizedBox(width: 16),
                  Text('$minutes',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Text('m',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 다음 합주 일정 섹션
class _NextScheduleSection extends StatelessWidget {
  final Schedule schedule;
  const _NextScheduleSection({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text('다음 합주 일정은',
                  style: TextStyle(
                      color: Colors.white, fontSize: 14)),
              Text('D-${schedule.daysRemaining}',
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(schedule.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${schedule.organizer} · ${schedule.location}',
              style:
                  const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text('${schedule.date} ${schedule.time}',
              style:
                  const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: const Text('일정 보기',
                style: TextStyle(
                    color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
