// lib/views/reservation_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/main_view_model.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();
    final schedules = vm.schedules;

    return SafeArea(
      child: Column(
        children: [
          // 상단 커스텀 AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_circle, size: 28, color: Colors.white),
                const Text(
                  '모여라!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.group_add, size: 28, color: Colors.white),
                  onPressed: () => _showCreateSheet(context),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.blueAccent, thickness: 2, height: 0),

          // 일정 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              itemBuilder: (context, i) {
                final sched = schedules[i];
                // 날짜 포맷
                final date = DateFormat('M월 d일 (E)', 'ko').format(sched.date);
                // 시간 포맷 (TimeOfDay -> HH:mm)
                final start = sched.startTime;
                final end = sched.endTime;
                final time =
                    '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                    ' ~ '
                    '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // 일정 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sched.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sched.location,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$date  $time',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // D-day
                      Text(
                        'D-${sched.daysRemaining}',
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: const CreateReservationForm(),
      ),
    );
  }
}

class CreateReservationForm extends StatefulWidget {
  const CreateReservationForm({Key? key}) : super(key: key);

  @override
  State<CreateReservationForm> createState() => _CreateReservationFormState();
}

class _CreateReservationFormState extends State<CreateReservationForm> {
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 19, minute: 0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('새 일정 만들기',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 제목
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '제목 (예: 정기 합주)',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          // 장소
          TextField(
            controller: _locationCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '장소 입력',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          // 날짜 선택
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('날짜', style: TextStyle(color: Colors.grey)),
            trailing: Text(
              DateFormat('M월 d일').format(_date),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (_, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: Colors.blueAccent,
                        onPrimary: Colors.white,
                        surface: const Color(0xFF1E1E1E),
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!),
              );
              if (d != null) setState(() => _date = d);
            },
          ),
          // 시간 선택
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('시작', style: TextStyle(color: Colors.grey)),
                  trailing: Text(_start.format(context), style: const TextStyle(color: Colors.white)),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: _start,
                      builder: (_, child) => Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              dialBackgroundColor: const Color(0xFF1E1E1E),
                              hourMinuteTextColor: Colors.white,
                              dayPeriodTextColor: Colors.grey,
                            ),
                          ),
                          child: child!),
                    );
                    if (t != null) setState(() => _start = t);
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('종료', style: TextStyle(color: Colors.grey)),
                  trailing: Text(_end.format(context), style: const TextStyle(color: Colors.white)),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: _end,
                      builder: (_, child) => Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              dialBackgroundColor: const Color(0xFF1E1E1E),
                              hourMinuteTextColor: Colors.white,
                              dayPeriodTextColor: Colors.grey,
                            ),
                          ),
                          child: child!),
                    );
                    if (t != null) setState(() => _end = t);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              context.read<MainViewModel>().addSchedule(
                title: _titleCtrl.text,
                location: _locationCtrl.text,
                date: _date,
                startTime: _start,
                endTime: _end,
              );
              Navigator.of(context).pop();
            },
            child: const Text('일정 생성', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
