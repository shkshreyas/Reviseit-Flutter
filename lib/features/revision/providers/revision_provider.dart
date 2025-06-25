import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviseitai/services/api/gemini_service.dart';

class RevisionState {
  final List<Map<String, dynamic>> revisions;
  final bool isLoading;
  final String? error;

  RevisionState({
    required this.revisions,
    this.isLoading = false,
    this.error,
  });

  RevisionState copyWith({
    List<Map<String, dynamic>>? revisions,
    bool? isLoading,
    String? error,
  }) {
    return RevisionState(
      revisions: revisions ?? this.revisions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RevisionNotifier extends StateNotifier<RevisionState> {
  final GeminiService _geminiService;

  RevisionNotifier(this._geminiService)
      : super(RevisionState(revisions: []));

  Future<void> generateRevisionSchedule(String text) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final schedule = await _geminiService.generateRevisionSchedule(text);
      state = state.copyWith(revisions: schedule, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate revision schedule: $e',
      );
    }
  }

  void markRevisionComplete(int index) {
    final updatedRevisions = List<Map<String, dynamic>>.from(state.revisions);
    updatedRevisions[index] = {
      ...updatedRevisions[index],
      'completed': true,
    };
    state = state.copyWith(revisions: updatedRevisions);
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final revisionProvider =
    StateNotifierProvider<RevisionNotifier, RevisionState>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  return RevisionNotifier(geminiService);
});