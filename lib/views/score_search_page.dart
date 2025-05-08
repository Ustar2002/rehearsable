import 'package:flutter/material.dart';
import '../viewmodels/main_view_model.dart';
import 'score_detail_page.dart';

/// 더미 모델
class ScoreInfo {
  final String title;
  final String artist;
  final String album;
  final String thumbnailUrl;
  final int viewCount;
  ScoreInfo({
    required this.title,
    required this.artist,
    required this.album,
    required this.thumbnailUrl,
    required this.viewCount,
  });
}

class ScoreSearchPage extends StatefulWidget {
  /// 탭에서 넘겨주는 초기 쿼리 (제목 or 아티스트)
  final String initialQuery;

  const ScoreSearchPage({Key? key, this.initialQuery = ''}) : super(key: key);

  @override
  State<ScoreSearchPage> createState() => _ScoreSearchPageState();
}

class _ScoreSearchPageState extends State<ScoreSearchPage> {
  late TextEditingController _ctrl;
  List<ScoreInfo> _all = [];
  List<ScoreInfo> _results = [];

  @override
  void initState() {
    super.initState();
    // 더미 데이터
    _all = [
      ScoreInfo(
        title: 'AMNESIA',
        artist: 'WOODZ(우즈)',
        album: 'AMNESIA',
        thumbnailUrl: 'assets/images/song_8.png',
        viewCount: 1327,
      ),
      ScoreInfo(
        title: 'Journey',
        artist: 'WOODZ(우즈)',
        album: 'OO-LI',
        thumbnailUrl: 'assets/images/song_2.png',
        viewCount: 2034,
      ),
      ScoreInfo(
        title: 'Drowning',
        artist: 'WOODZ(우즈)',
        album: 'OO-LI',
        thumbnailUrl: 'assets/images/song_1.png',
        viewCount: 7578,
      ),
      // ... 추가
    ];
    _ctrl = TextEditingController(text: widget.initialQuery);
    _search(widget.initialQuery);
  }

  void _search(String q) {
    setState(() {
      _results = _all.where((s) {
        final low = q.toLowerCase();
        return s.title.toLowerCase().contains(low)
            || s.artist.toLowerCase().contains(low);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '곡명 또는 아티스트',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _search,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => _search(_ctrl.text.trim()),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // 필터 태그 (예시)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                _TagChip('밴드스코어'),
                SizedBox(width: 8),
                _TagChip('피아노'),
                SizedBox(width: 8),
                _TagChip('멜로디'),
                SizedBox(width: 8),
                _TagChip('독주악기'),
                SizedBox(width: 8),
                _TagChip('관현악 & 실내악'),
                SizedBox(width: 8),
                _TagChip('합창'),
                SizedBox(width: 8),
                _TagChip('MR'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 검색 결과
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = _results[i];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ScoreDetailPage(info: s),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 썸네일 + 타이틀/아티스트/앨범
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                s.thumbnailUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    s.artist,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    '앨범: ${s.album}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 아이콘 행 + 조회수
                        Row(
                          children: [
                            // B, P, M, S, O, C, MR 등 아이콘들은 임의로 텍스트로 표시
                            const Text('Ⓑ', style: TextStyle(color: Colors.blueAccent)),
                            const SizedBox(width: 4),
                            const Text('Ⓟ', style: TextStyle(color: Colors.blueAccent)),
                            const SizedBox(width: 4),
                            const Text('Ⓜ', style: TextStyle(color: Colors.blueAccent)),
                            const SizedBox(width: 4),
                            const Text('Ⓢ', style: TextStyle(color: Colors.blueAccent)),
                            const SizedBox(width: 8),
                            const Text('MR', style: TextStyle(color: Colors.blueAccent)),
                            const Spacer(),
                            // 조회수
                            const Icon(Icons.ondemand_video, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('${s.viewCount}만회', style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: const Color(0xFF2A2A2A),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
