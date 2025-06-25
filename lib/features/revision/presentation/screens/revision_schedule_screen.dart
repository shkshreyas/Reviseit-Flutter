import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/core/widgets/glass_container.dart';
import 'package:table_calendar/table_calendar.dart';

class RevisionScheduleScreen extends StatefulWidget {
  const RevisionScheduleScreen({super.key});

  @override
  State<RevisionScheduleScreen> createState() => _RevisionScheduleScreenState();
}

class _RevisionScheduleScreenState extends State<RevisionScheduleScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  
  // Sample revision data - in a real app, this would come from your database
  final Map<DateTime, List<RevisionItem>> _revisions = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    
    // Initialize sample data
    _initSampleData();
  }

  void _initSampleData() {
    final now = DateTime.now();
    
    // Today
    final today = DateTime(now.year, now.month, now.day);
    _revisions[today] = [
      RevisionItem(
        title: 'Machine Learning Fundamentals',
        dueTime: '09:00 AM',
        progress: 0.8,
        isCompleted: false,
      ),
      RevisionItem(
        title: 'Flutter State Management',
        dueTime: '02:30 PM',
        progress: 0.6,
        isCompleted: true,
      ),
    ];
    
    // Tomorrow
    final tomorrow = today.add(const Duration(days: 1));
    _revisions[tomorrow] = [
      RevisionItem(
        title: 'Quantum Computing Basics',
        dueTime: '10:00 AM',
        progress: 0.4,
        isCompleted: false,
      ),
    ];
    
    // Day after tomorrow
    final dayAfterTomorrow = today.add(const Duration(days: 2));
    _revisions[dayAfterTomorrow] = [
      RevisionItem(
        title: 'Neural Networks',
        dueTime: '11:00 AM',
        progress: 0.3,
        isCompleted: false,
      ),
      RevisionItem(
        title: 'Data Structures',
        dueTime: '03:00 PM',
        progress: 0.7,
        isCompleted: false,
      ),
    ];
  }

  List<RevisionItem> _getRevisionsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _revisions[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF121212),
              Color(0xFF1E1E30),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildCalendar(),
              const SizedBox(height: 16),
              _buildRevisionsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new revision
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ).animate().scale(
        duration: 600.ms,
        delay: 300.ms,
        curve: Curves.elasticOut,
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Revision Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return GlassContainer(
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: (day) => _getRevisionsForDay(day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.grey),
          outsideTextStyle: TextStyle(color: Colors.grey),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRevisionsList() {
    final revisions = _getRevisionsForDay(_selectedDay);
    
    return Expanded(
      child: revisions.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: revisions.length,
              itemBuilder: (context, index) {
                return _buildRevisionItem(revisions[index], index)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 300.ms,
                      delay: (50 * index).ms,
                      curve: Curves.easeOutQuad,
                    );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No revisions scheduled for this day',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Add new revision
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Schedule Revision'),
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionItem(RevisionItem item, int index) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: item.progress,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    item.progress > 0.7
                        ? Colors.green
                        : item.progress > 0.4
                            ? Colors.orange
                            : Colors.red,
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: item.isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : Text(
                          '${(item.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${item.dueTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.isCompleted
                        ? Colors.grey
                        : AppTheme.subtleTextColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              item.isCompleted ? Icons.refresh : Icons.play_circle_outline,
              color: item.isCompleted ? Colors.grey : Colors.white,
            ),
            onPressed: () {
              // Start revision or mark as completed/incomplete
              setState(() {
                item.isCompleted = !item.isCompleted;
              });
            },
          ),
        ],
      ),
    );
  }
}

class RevisionItem {
  final String title;
  final String dueTime;
  final double progress;
  bool isCompleted;

  RevisionItem({
    required this.title,
    required this.dueTime,
    required this.progress,
    required this.isCompleted,
  });
}