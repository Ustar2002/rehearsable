// lib/views/scores_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/main_view_model.dart';
import 'score_request_page.dart';
import 'score_search_page.dart';

class ScoresPage extends StatelessWidget {
  const ScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();
    final popular = vm.weeklySongs;
    final latest = popular.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) 주간 인기 악보
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '주간 인기 악보',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '4월 7일 ~ 4월 13일',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(5, (i) {
                    final left = popular[i];
                    final right = popular[i + 5];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ScoreItem(score: left),
                          _ScoreItem(score: right),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2) 최신 악보
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '최신 악보',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('더보기',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: latest.map((score) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              score.thumbnailUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ScoreSearchPage(
                                          initialQuery: score.title,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    score.title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ScoreSearchPage(
                                          initialQuery: score.artist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    score.artist,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3) 악보 요청/올리기
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '찾는 악보가 없나요?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ScoreRequestPage()),
                          );
                        },
                        child: const Text('악보 요청하기'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // TODO: 악보 올리기 페이지로 이동
                        },
                        child: const Text('악보 올리기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 개별 악보 아이템
class _ScoreItem extends StatelessWidget {
  final PopularSong score;
  const _ScoreItem({required this.score});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              '${score.rank}.',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
            const SizedBox(width: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                score.thumbnailUrl,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScoreSearchPage(
                            initialQuery: score.title,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      score.title,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScoreSearchPage(
                            initialQuery: score.artist,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      score.artist,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
