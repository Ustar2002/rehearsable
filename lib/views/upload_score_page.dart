// lib/views/upload_score_page.dart
import 'package:flutter/material.dart';
import '../viewmodels/score_request_view_model.dart';

class UploadScorePage extends StatelessWidget {
  final Track track;
  const UploadScorePage({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('악보 업로드'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 트랙 정보
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(track.albumArtUrl, width: 64, height: 64, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(track.artists, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 업로드 폼 예시
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '악보 파일 URL 또는 업로드',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: 업로드 로직 호출
              },
              child: const Text('업로드 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
