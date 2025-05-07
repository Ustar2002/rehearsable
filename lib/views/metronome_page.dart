// lib/views/metronome_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/metronome_view_model.dart';

class MetronomePage extends StatelessWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MetronomeViewModel(),
      child: Consumer<MetronomeViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 전체화면 버튼
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FullScreenMetronomePage(),
                        ),
                      );
                    },
                  ),
                ),

                // 비트 인디케이터
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(vm.beatCount, (i) {
                    final isActive = i == vm.currentBeat;
                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.blueAccent
                            : Colors.blueAccent.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // 컨트롤러 카드: 템포 변경 / 타이머
                Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // 템포 변경
                        Expanded(
                          child: Column(
                            children: [
                              const Text('템포 변경',
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.white),
                                    onPressed: vm.decreaseBpm,
                                  ),
                                  Text('${vm.bpm}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.add, color: Colors.white),
                                    onPressed: vm.increaseBpm,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 타이머
                        Expanded(
                          child: Column(
                            children: [
                              const Text('타이머',
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(
                                _formatDuration(vm.timerDuration),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 모드 선택
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  fillColor: Colors.blueAccent,
                  selectedBorderColor: Colors.blueAccent,
                  children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('PolyRhythm')),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('CoachMode')),
                  ],
                  isSelected: [
                    vm.mode == MetronomeMode.polyRhythm,
                    vm.mode == MetronomeMode.coach,
                  ],
                  onPressed: (idx) {
                    vm.toggleMode(idx == 0
                        ? MetronomeMode.polyRhythm
                        : MetronomeMode.coach);
                  },
                ),
                const SizedBox(height: 24),

                // BPM 표시 & 박자 표시
                Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.music_note,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              '${vm.bpm}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Text('BPM',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.filter_1,
                                    color: Colors.white),
                                onPressed: () => vm.changeBeatCount(1)),
                            IconButton(
                                icon: const Icon(Icons.filter_2,
                                    color: Colors.white),
                                onPressed: () => vm.changeBeatCount(2)),
                            IconButton(
                                icon: const Icon(Icons.filter_3,
                                    color: Colors.white),
                                onPressed: () => vm.changeBeatCount(3)),
                            IconButton(
                                icon: const Icon(Icons.filter_4,
                                    color: Colors.white),
                                onPressed: () => vm.changeBeatCount(4)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Play / Stop 버튼
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (vm.isRunning) {
                        vm.stop();
                      } else {
                        vm.start();
                      }
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        vm.isRunning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

/// 전체화면 전용 페이지
class FullScreenMetronomePage extends StatefulWidget {
  const FullScreenMetronomePage({Key? key}) : super(key: key);
  @override
  _FullScreenMetronomePageState createState() =>
      _FullScreenMetronomePageState();
}

class _FullScreenMetronomePageState extends State<FullScreenMetronomePage> {
  @override
  void initState() {
    super.initState();
     // 시스템 UI 모두 숨기고(immersive), 가로 고정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 원래 상태(상태바/네비바 보이기)로 복원
    SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => MetronomeViewModel(),
          child: Consumer<MetronomeViewModel>(
            builder: (context, vm, _) {
              // 풀스크린에 맞춰 UI 간결화
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 대형 비트 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(vm.beatCount, (i) {
                      final isActive = i == vm.currentBeat;
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.blueAccent
                              : Colors.blueAccent.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // 대형 BPM
                  Text(
                    '${vm.bpm}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  // 대형 Play/Stop 버튼
                  GestureDetector(
                    onTap: () {
                      if (vm.isRunning) vm.stop();
                      else vm.start();
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[800], shape: BoxShape.circle),
                      child: Icon(
                        vm.isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
