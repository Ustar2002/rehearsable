// lib/views/score_request_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/score_request_view_model.dart';
import 'upload_score_page.dart';

class ScoreRequestPage extends StatefulWidget {
  const ScoreRequestPage({Key? key}) : super(key: key);

  @override
  State<ScoreRequestPage> createState() => _ScoreRequestPageState();
}

class _ScoreRequestPageState extends State<ScoreRequestPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 실제로는 안전하게 토큰을 보관하고 주입하세요
      create: (_) => ScoreRequestViewModel('YOUR_SPOTIFY_TOKEN_HERE'),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text('곡 검색'),
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '곡명 또는 가수 입력',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      final q = _controller.text.trim();
                      if (q.isNotEmpty) {
                        context.read<ScoreRequestViewModel>().search(q);
                      }
                    },
                  ),
                ),
                onSubmitted: (q) {
                  if (q.trim().isNotEmpty) {
                    context.read<ScoreRequestViewModel>().search(q.trim());
                  }
                },
              ),
            ),

            // 결과 표시
            Expanded(
              child: Consumer<ScoreRequestViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.error != null) {
                    return Center(
                      child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  if (vm.tracks.isEmpty) {
                    return const Center(
                      child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.separated(
                    itemCount: vm.tracks.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.grey),
                    itemBuilder: (context, i) {
                      final t = vm.tracks[i];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(t.albumArtUrl, width: 48, height: 48, fit: BoxFit.cover),
                        ),
                        title: Text(t.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(t.artists, style: const TextStyle(color: Colors.grey)),
                        trailing: t.previewUrl != null
                            ? IconButton(
                                icon: const Icon(Icons.play_arrow, color: Colors.white),
                                onPressed: () {
                                  // TODO: previewUrl 재생 구현
                                },
                              )
                            : null,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UploadScorePage(track: t),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
