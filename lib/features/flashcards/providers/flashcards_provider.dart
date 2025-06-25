import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviseitai/services/api/gemini_service.dart';

class FlashcardsState {
  final List<Map<String, dynamic>> flashcards;
  final bool isLoading;
  final String? error;

  FlashcardsState({
    required this.flashcards,
    this.isLoading = false,
    this.error,
  });

  FlashcardsState copyWith({
    List<Map<String, dynamic>>? flashcards,
    bool? isLoading,
    String? error,
  }) {
    return FlashcardsState(
      flashcards: flashcards ?? this.flashcards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FlashcardsNotifier extends StateNotifier<FlashcardsState> {
  final GeminiService _geminiService;

  FlashcardsNotifier(this._geminiService)
      : super(FlashcardsState(flashcards: []));

  Future<void> generateFlashcards(String text) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final flashcards = await _geminiService.generateFlashcards(text);
      state = state.copyWith(flashcards: flashcards, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate flashcards: $e',
      );
    }
  }

  void updateFlashcardConfidence(int index, double confidence) {
    final updatedFlashcards = List<Map<String, dynamic>>.from(state.flashcards);
    updatedFlashcards[index] = {
      ...updatedFlashcards[index],
      'confidence': confidence,
    };
    state = state.copyWith(flashcards: updatedFlashcards);
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final flashcardsProvider =
    StateNotifierProvider<FlashcardsNotifier, FlashcardsState>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  return FlashcardsNotifier(geminiService);
});