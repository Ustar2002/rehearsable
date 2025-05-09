// lib/viewmodels/score_request_view_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Spotify 검색 결과를 담을 모델
class Track {
  final String id;
  final String uri;
  final String name;
  final String artists;
  final String albumArtUrl;
  final String? previewUrl;

  Track({
    required this.id,
    required this.uri,
    required this.name,
    required this.artists,
    required this.albumArtUrl,
    this.previewUrl,
  });
}

class ScoreRequestViewModel extends ChangeNotifier {
  final String _token; // 미리 발급해둔 Spotify 토큰
  ScoreRequestViewModel(this._token);

  List<Track> tracks = [];
  bool isLoading = false;
  String? error;

  Future<void> search(String query) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final url = Uri.https('api.spotify.com', '/v1/search', {
      'q': query,
      'type': 'track',
      'limit': '20',
    });

    try {
      final resp = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final items = data['tracks']['items'] as List;
        tracks = items.map((item) {
          return Track(
            id: item['id'],
            uri: item['uri'],
            name: item['name'],
            artists: (item['artists'] as List)
                .map((a) => a['name'])
                .join(', '),
            albumArtUrl: item['album']['images'][0]['url'],
            previewUrl: item['preview_url'],
          );
        }).toList();
      } else {
        error = 'Error ${resp.statusCode}';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
