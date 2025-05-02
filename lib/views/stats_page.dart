// lib/views/stats_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/main_view_model.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = context.read<MainViewModel>().stats;

    // 히트맵 레벨 전체를 꺼내 최댓값 계산
    final levels = stats.heatmap.expand((week) => week).toList();
    final maxLevel = levels.isNotEmpty ? levels.reduce(max) : 1;

    // 화면 가로 여백(16*2)과 셀 간격(4*6)을 제외한 셀 크기
    final totalPadding = 16.0 * 2;
    const spacing = 4.0;
    final cellSize =
        (MediaQuery.of(context).size.width - totalPadding - spacing * 6) / 7;

//FIXME: 글씨 크기 때문에 한칸 내려가는것 고치기기

    return Scaffold(
      appBar: AppBar(
        title: const Text('연습 통계'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        children: [
          // 요약 카드 3개
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: '하루 평균',
                  value: '${stats.avgDailyHours}h ${stats.avgDailyMinutes}m',
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  label: '주간 변동',
                  value: '${stats.weekChangePercent.toStringAsFixed(0)}%',
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  label: '연습 일수',
                  value: '${stats.practicedDays}일',
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 요일별 연습 히트맵
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '요일별 연습 히트맵',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: levels.map((level) {
                      // 최댓값으로 정규화하고 0.2~1.0 범위로 매핑
                      final normalized = maxLevel > 0
                          ? level / maxLevel
                          : 0.0;
                      final opacity = (0.2 + normalized * 0.8)
                          .clamp(0.0, 1.0);
                      return Container(
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color:
                              Colors.blueAccent.withOpacity(opacity),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 시간대별 연습 횟수 (플레이스홀더)
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '시간대별 연습 횟수',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Bar Chart Placeholder',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 목표 달성률
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '목표 달성률',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: stats.goalCompletion,
                    backgroundColor: Colors.grey[800],
                    color: Colors.blueAccent,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(stats.goalCompletion * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 연습 카테고리 분포 (플레이스홀더)
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '연습 카테고리 분포',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Pie Chart Placeholder',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...stats.categoryDistribution.entries.map((e) {
                    final pct = e.value.clamp(0.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.blueAccent.withOpacity(pct),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${e.key} ${(pct * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 최다 연습 곡 / 템포 목록
          _ListCard(title: '가장 많이 연습한 곡', items: stats.topSongs),
          const SizedBox(height: 16),
          _ListCard(title: '가장 많이 연습한 템포', items: stats.topTempos),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ListCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${e.key + 1}. ${e.value}',
                    style: const TextStyle(color: Colors.white)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
