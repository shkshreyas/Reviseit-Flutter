import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/core/widgets/glass_container.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showAnswer = false;
  
  // Sample flashcards data - in a real app, this would come from your Gemini API
  final List<Map<String, dynamic>> _flashcards = [
    {
      'question': 'What is spaced repetition?',
      'answer': 'A learning technique that involves increasing intervals of time between subsequent review of previously learned material to exploit the psychological spacing effect.',
      'confidence': 0.0,
    },
    {
      'question': 'What is active recall?',
      'answer': 'A learning principle which involves actively stimulating memory during the learning process. It contrasts with passive review, where the learning material is processed passively.',
      'confidence': 0.0,
    },
    {
      'question': 'How does the forgetting curve work?',
      'answer': 'The forgetting curve illustrates the decline of memory retention over time. The curve shows how information is lost when there is no attempt to retain it.',
      'confidence': 0.0,
    },
    {
      'question': 'What is the optimal interval for reviewing material?',
      'answer': 'The optimal interval varies based on difficulty and previous recall success, but generally follows an exponential pattern (1 day, 3 days, 7 days, etc.).',
      'confidence': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _showAnswer = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _rateConfidence(double value) {
    setState(() {
      _flashcards[_currentIndex]['confidence'] = value;
    });
    
    // In a real app, you would save this to your database
    Future.delayed(const Duration(milliseconds: 300), _nextCard);
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
              const SizedBox(height: 16),
              _buildProgress(),
              Expanded(
                child: _buildFlashcards(),
              ),
              _buildControls(),
            ],
          ),
        ),
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
              'Flashcards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Card ${_currentIndex + 1} of ${_flashcards.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.subtleTextColor,
                ),
              ),
              const Spacer(),
              Text(
                'Machine Learning Fundamentals',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _flashcards.length,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcards() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _flashcards.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          _showAnswer = false;
        });
      },
      itemBuilder: (context, index) {
        final isCurrentPage = index == _currentIndex;
        return AnimatedScale(
          scale: isCurrentPage ? 1.0 : 0.9,
          duration: const Duration(milliseconds: 300),
          child: _buildFlashcard(_flashcards[index]),
        );
      },
    );
  }

  Widget _buildFlashcard(Map<String, dynamic> flashcard) {
    return GestureDetector(
      onTap: _toggleAnswer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: GlassContainer(
          borderRadius: 24,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showAnswer ? 'Answer:' : 'Question:',
                        style: TextStyle(
                          fontSize: 16,
                          color: _showAnswer 
                              ? AppTheme.accentColor 
                              : AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _showAnswer ? flashcard['answer'] : flashcard['question'],
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_showAnswer) ...[  
                        const SizedBox(height: 32),
                        const Text(
                          'How well did you know this?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildConfidenceRating(),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: IconButton(
                  icon: Icon(
                    _showAnswer ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: _toggleAnswer,
                ),
              ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildConfidenceRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRatingButton('Hard', Colors.red.shade300, 0.0),
        _buildRatingButton('Medium', Colors.amber.shade300, 0.5),
        _buildRatingButton('Easy', Colors.green.shade300, 1.0),
      ],
    );
  }

  Widget _buildRatingButton(String label, Color color, double value) {
    return ElevatedButton(
      onPressed: () => _rateConfidence(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: color.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton.filled(
            onPressed: _currentIndex > 0 ? _previousCard : null,
            icon: const Icon(Icons.arrow_back_ios),
            style: IconButton.styleFrom(
              backgroundColor: _currentIndex > 0 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.05),
              foregroundColor: _currentIndex > 0 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          GlassContainer(
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _showAnswer ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
              ],
            ),
          ).animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
          IconButton.filled(
            onPressed: _currentIndex < _flashcards.length - 1 ? _nextCard : null,
            icon: const Icon(Icons.arrow_forward_ios),
            style: IconButton.styleFrom(
              backgroundColor: _currentIndex < _flashcards.length - 1 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.05),
              foregroundColor: _currentIndex < _flashcards.length - 1 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}