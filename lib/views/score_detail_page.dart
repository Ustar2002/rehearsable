import 'package:flutter/material.dart';
import 'score_search_page.dart'; // ScoreInfo 정의

class ScoreDetailPage extends StatelessWidget {
  final ScoreInfo info;
  const ScoreDetailPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 더미 악보 옵션
    final options = <_ScoreOption>[
      _ScoreOption('기타', '원키 (Half Down 튜닝)', 'A(가장조)', '7P'),
      _ScoreOption('기타(Tab)', '원키 (Gt.1-2 Half Down, Gt.3 Capo=1 Fret)', 'A(가장조)', '8P'),
      _ScoreOption('베이스', '원키 (Half Down 튜닝)', 'A(가장조)', '5P'),
      _ScoreOption('드럼', '원키', 'Ab(내림 가장조)', '5P'),
      // …더 추가
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: Text(info.title, style: const TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더 카드
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(info.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(info.artist,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text('앨범: ${info.album}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 옵션 리스트
          Text('밴드스코어',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...options.map((o) => _OptionRow(o)).toList(),
        ],
      ),
    );
  }
}

// 악보 옵션 모델
class _ScoreOption {
  final String type, tuning, key, pages;
  _ScoreOption(this.type, this.tuning, this.key, this.pages);
}

// 옵션 행
class _OptionRow extends StatelessWidget {
  final _ScoreOption opt;
  const _OptionRow(this.opt);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(opt.type, style: const TextStyle(color: Colors.white))),
          Expanded(child: Text(opt.tuning, style: const TextStyle(color: Colors.white))),
          Expanded(child: Text(opt.key, style: const TextStyle(color: Colors.white))),
          Text(opt.pages, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
