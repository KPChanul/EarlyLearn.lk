import 'package:flutter/material.dart';

abstract class RewardDay {
  final int day;
  final bool _isCompleted;
  final bool _isCurrent;
  final bool _hasFreeze;

  const RewardDay._({
    required this.day,
    required bool isCompleted,
    required bool isCurrent,
    required bool hasFreeze,
  }) : _isCompleted = isCompleted,
       _isCurrent = isCurrent,
       _hasFreeze = hasFreeze;

  bool get isCompleted => _isCompleted;
  bool get isCurrent => _isCurrent;
  bool get hasFreeze => _hasFreeze;
  String get label => day.toString();
}

class CompletedRewardDay extends RewardDay {
  const CompletedRewardDay(
    int day, {
    bool hasFreeze = false,
    bool isCurrent = false,
  }) : super._(
         day: day,
         isCompleted: true,
         isCurrent: isCurrent,
         hasFreeze: hasFreeze,
       );
}

class CurrentRewardDay extends RewardDay {
  const CurrentRewardDay(int day)
    : super._(day: day, isCompleted: true, isCurrent: true, hasFreeze: false);
}

class FutureRewardDay extends RewardDay {
  const FutureRewardDay(int day)
    : super._(day: day, isCompleted: false, isCurrent: false, hasFreeze: false);
}

class PendingRewardDay extends RewardDay {
  const PendingRewardDay(int day, {bool hasFreeze = false})
    : super._(
        day: day,
        isCompleted: false,
        isCurrent: false,
        hasFreeze: hasFreeze,
      );
}

abstract class RewardDayTile extends StatelessWidget {
  final RewardDay day;

  const RewardDayTile({super.key, required this.day});
}

class RewardTileFactory {
  static RewardDayTile create(RewardDay day) {
    if (day.hasFreeze) {
      return FreezeRewardDayTile(day: day);
    }
    if (day is CurrentRewardDay) {
      return CurrentRewardDayTile(day: day);
    }
    if (day.isCompleted) {
      return CompletedRewardDayTile(day: day);
    }
    return PendingRewardDayTile(day: day);
  }
}

class CompletedRewardDayTile extends RewardDayTile {
  const CompletedRewardDayTile({super.key, required super.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFB8C00), Color(0xFFFDD835)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          day.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CurrentRewardDayTile extends RewardDayTile {
  const CurrentRewardDayTile({super.key, required super.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF263238),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          day.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FreezeRewardDayTile extends RewardDayTile {
  const FreezeRewardDayTile({super.key, required super.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                day.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ac_unit,
                size: 14,
                color: Color(0xFF0277BD),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PendingRewardDayTile extends RewardDayTile {
  const PendingRewardDayTile({super.key, required super.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1E272C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          day.label,
          style: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RewardCalendarData {
  final String _monthLabel;
  final int _streakDays;
  final int _freezesUsed;
  final int _startWeekdayIndex;
  final List<RewardDay> _days;

  const RewardCalendarData._({
    required String monthLabel,
    required int streakDays,
    required int freezesUsed,
    required int startWeekdayIndex,
    required List<RewardDay> days,
  }) : _monthLabel = monthLabel,
       _streakDays = streakDays,
       _freezesUsed = freezesUsed,
       _startWeekdayIndex = startWeekdayIndex,
       _days = days;

  String get monthLabel => _monthLabel;
  int get streakDays => _streakDays;
  int get freezesUsed => _freezesUsed;
  int get startWeekdayIndex => _startWeekdayIndex;
  List<RewardDay> get days => List.unmodifiable(_days);

  static RewardCalendarData sampleMonth() {
    final completed = {1, 2, 3, 4, 5, 6, 11, 17, 21, 22, 23, 24, 25, 26, 27};
    final freezeDays = {11, 17};
    final currentDay = 27;

    List<RewardDay> days = List.generate(30, (index) {
      final dayNumber = index + 1;
      if (completed.contains(dayNumber)) {
        final hasFreeze = freezeDays.contains(dayNumber);
        if (dayNumber == currentDay) {
          return CurrentRewardDay(dayNumber);
        }
        return CompletedRewardDay(dayNumber, hasFreeze: hasFreeze);
      }
      if (dayNumber > 27) {
        return FutureRewardDay(dayNumber);
      }
      return PendingRewardDay(dayNumber);
    });

    return RewardCalendarData._(
      monthLabel: 'June 2026',
      streakDays: 64,
      freezesUsed: 2,
      startWeekdayIndex: 1,
      days: days,
    );
  }
}

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RewardCalendarData calendarData = RewardCalendarData.sampleMonth();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Streak'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStreakCard(calendarData),
              const SizedBox(height: 20),
              _buildMonthHeader(calendarData),
              const SizedBox(height: 16),
              _buildCalendarGrid(calendarData),
              const SizedBox(height: 20),
              _buildProtectionCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(RewardCalendarData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF373B44), Color(0xFF4286f4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perfect Streak',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.streakDays} day streak!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep your perfect streak by doing a lesson every day.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(RewardCalendarData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E272C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.monthLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      '${data.days.where((d) => d.isCompleted).length}',
                      'Days practiced',
                    ),
                    _buildStatItem('${data.freezesUsed}', 'Freezes used'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(RewardCalendarData data) {
    final List<Widget> rows = [];
    rows.add(_buildWeekdayLabels());

    final int totalCells = 42;
    final int offset = data.startWeekdayIndex;
    final List<RewardDay?> gridData = List.generate(totalCells, (index) {
      final dayIndex = index - offset;
      if (dayIndex < 0 || dayIndex >= data.days.length) {
        return null;
      }
      return data.days[dayIndex];
    });

    for (int row = 0; row < 6; row++) {
      final rowCells = gridData.sublist(row * 7, row * 7 + 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: rowCells.map((rewardDay) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: rewardDay == null
                      ? const SizedBox(height: 52)
                      : RewardTileFactory.create(rewardDay),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E272C),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: rows),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return Row(
      children: weekdays.map((weekday) {
        return Expanded(
          child: Center(
            child: Text(
              weekday,
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProtectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E272C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0288D1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shield, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '7-day Streak Shield',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'BUY FOR 3000',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text('BUY'),
          ),
        ],
      ),
    );
  }
}
