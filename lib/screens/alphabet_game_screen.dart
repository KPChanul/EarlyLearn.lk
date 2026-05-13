/* import 'package:flutter/material.dart';
import '../models/alphabet_game_logic.dart';
import '../services/audio_manager.dart';

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> {
  final AlphabetGameLogic _game = AlphabetGameLogic();
  final AudioManager _audioManager = AudioManager();
  
  String _feedbackMessage = "Listen to the word and choose the letter!";
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    _game.startGame();
  }

  @override
  void dispose() {
    _audioManager.dispose(); // Clean up audio memory
    super.dispose();
  }

  Future<void> _handleAnswer(String selected) async {
    // If the game is already waiting to move to the next question, ignore taps
    if (_isProcessing) return; 

    var currentQ = _game.getCurrentQuestion()!;
    bool isCorrect = _game.checkAnswer(selected, currentQ.correctAnswer);

    _audioManager.playSfx(isCorrect);

    if (isCorrect) {
      // Step 1: Show "Correct" and lock the buttons
      setState(() {
        _feedbackMessage = "Correct! 🎉";
        _isProcessing = true; 
      });

      // Step 2: Wait for 1.5 seconds so the child can enjoy the success sound
      await Future.delayed(const Duration(milliseconds: 1500));

      // Step 3: Move to the next question and reset the screen
      setState(() {
        _game.nextQuestion();
        _isProcessing = false; // Unlock the buttons
        
        if (_game.getCurrentQuestion() == null) {
          _feedbackMessage = "Game Over! You scored ${_game.score}";
          _game.endGame();
        } else {
          // Reset the message for the new question!
          _feedbackMessage = "Listen to the word and choose the letter!";
        }
      });
      
    } else {
      // If wrong, just show the try again message immediately
      setState(() {
        _feedbackMessage = "Oops, try again! ❌";
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    var currentQ = _game.getCurrentQuestion();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(_game.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: currentQ == null
            ? Text(_feedbackMessage, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Score: ${_game.score}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 30),
                  
                  // Image and Audio Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                        ),
                        clipBehavior: Clip.antiAlias,
                        // Make sure you have these images in your assets folder!
                        child: Image.asset(currentQ.imagePath, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Text("Image Missing")),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          color: Colors.white,
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => _audioManager.playWord(currentQ.audioPath),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Answer Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: currentQ.options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          onPressed: () => _handleAnswer(option),
                          child: Text(option, style: const TextStyle(fontSize: 40, color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  Text(
                    _feedbackMessage,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _feedbackMessage.contains("Correct") ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} */
import 'package:flutter/material.dart';
import '../models/alphabet_game_logic.dart';
import '../models/alphabet_questions.dart';
import '../services/audio_manager.dart';
import '../main.dart'; // AppTheme

// ─── AlphabetGameScreen ───────────────────────────────────────────────────────
// Main game screen. Handles UI state machine: playing → result.
// All game logic is delegated to AlphabetGameLogic (separation of concerns).

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen>
    with TickerProviderStateMixin {

  // ── Dependencies ──────────────────────────────────────────────────────────
  final AlphabetGameLogic _game  = AlphabetGameLogic();
  final AudioManager _audio       = AudioManager();

  // ── UI state ──────────────────────────────────────────────────────────────
  bool   _isProcessing = false;
  String _feedbackMessage = '';
  bool   _isCorrect = true;
  String _hintText = '';
  bool   _showHint = false;

  // ── Animation controllers ─────────────────────────────────────────────────
  late AnimationController _questionSlideCtrl;
  late AnimationController _feedbackCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;

  late Animation<Offset> _questionSlide;
  late Animation<double>  _feedbackFade;
  late Animation<double>  _shakeTween;
  late Animation<double>  _bounceAnim;

  // ── Button state map: letter → colour override ────────────────────────────
  final Map<String, Color?> _buttonColors = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _game.startGame();
    _playCurrentWord();
  }

  void _setupAnimations() {
    _questionSlideCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
    _questionSlide = Tween<Offset>(
      begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _questionSlideCtrl, curve: Curves.easeOutCubic));
    _questionSlideCtrl.forward();

    _feedbackCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
    _feedbackFade = CurvedAnimation(parent: _feedbackCtrl, curve: Curves.easeIn);

    _shakeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _shakeTween = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));

    _bounceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));
    _bounceAnim = Tween<double>(begin: 1, end: 1.2)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _questionSlideCtrl.dispose();
    _feedbackCtrl.dispose();
    _shakeCtrl.dispose();
    _bounceCtrl.dispose();
    _audio.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _playCurrentWord() {
    final q = _game.getCurrentQuestion();
    if (q != null) _audio.playWord(q.audioPath);
  }

  Future<void> _handleAnswer(String selected) async {
    if (_isProcessing) return;

    final currentQ = _game.getCurrentQuestion()!;
    final isCorrect = _game.checkAnswer(selected, currentQ.correctAnswer);

    await _audio.playAnswerSfx(isCorrect);

    if (isCorrect) {
      setState(() {
        _feedbackMessage = _streakMessage();
        _isCorrect = true;
        _isProcessing = true;
        _buttonColors[selected] = AppTheme.primary;
        _showHint = false;
        _hintText = '';
      });
      _bounceCtrl.forward(from: 0);
      _feedbackCtrl.forward(from: 0);

      await Future.delayed(AlphabetGameLogic.autoAdvance);

      setState(() {
        _buttonColors.clear();
        _game.nextQuestion();
        _isProcessing = false;

        if (_game.isGameOver) {
          _game.endGame();
        } else {
          _feedbackMessage = '';
          _showHint = false;
        }
      });

      if (!_game.isGameOver) {
        _questionSlideCtrl.forward(from: 0);
        _playCurrentWord();
      }

    } else {
      setState(() {
        _feedbackMessage = _game.lives == 0
            ? 'No more lives! 💔'
            : 'Oops, try again! ❌';
        _isCorrect = false;
        _buttonColors[selected] = AppTheme.danger;
        _showHint = true;
      });
      _feedbackCtrl.forward(from: 0);
      _shakeCtrl.forward(from: 0);

      if (_game.isOutOfLives) {
        await Future.delayed(const Duration(milliseconds: 800));
        setState(() { _game.endGame(); });
      }
    }
  }

  String _streakMessage() {
    if (_game.streak >= 5) return 'ON FIRE! 🔥 +${AlphabetGameLogic.baseScorePerQ + 20}';
    if (_game.streak >= 3) return 'Great streak! ⚡ +${AlphabetGameLogic.baseScorePerQ + 10}';
    return 'Correct! 🎉 +${AlphabetGameLogic.baseScorePerQ}';
  }

  void _showHintText() {
    final hint = _game.useHint();
    setState(() {
      _hintText = hint.isEmpty ? 'No hint available.' : hint;
    });
  }

  void _restartGame() {
    setState(() {
      _game.startGame();
      _feedbackMessage = '';
      _isProcessing = false;
      _buttonColors.clear();
      _showHint = false;
      _hintText = '';
    });
    _questionSlideCtrl.forward(from: 0);
    _playCurrentWord();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_game.isGameOver) return _buildResultScreen();

    final currentQ = _game.getCurrentQuestion();
    if (currentQ == null) return _buildResultScreen();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFFFF8F0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: SlideTransition(
                  position: _questionSlide,
                  child: _buildQuestionBody(currentQ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header bar ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Score pill
          _Pill(
            icon: Icons.star_rounded,
            iconColor: AppTheme.secondary,
            label: '${_game.score}',
            bgColor: Colors.white,
          ),
          const SizedBox(width: 10),
          // Streak pill
          _Pill(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
            label: '×${_game.streak}',
            bgColor: Colors.white,
          ),
          const Spacer(),
          // Lives
          ..._buildLivesRow(),
          const SizedBox(width: 10),
          // Mute button
          GestureDetector(
            onTap: () => setState(() => _audio.toggleMute()),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Icon(
                _audio.isMuted ? Icons.volume_off : Icons.volume_up,
                color: AppTheme.accent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLivesRow() {
    return List.generate(AlphabetGameLogic.maxLives, (i) {
      final filled = i < _game.lives;
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(filled),
            color: filled ? AppTheme.danger : Colors.grey.shade300,
            size: 26,
          ),
        ),
      );
    });
  }

  // ── Progress bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${_game.currentQuestionIndex + 1} / ${_game.totalQuestions}',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _game.progressPercent),
              duration: const Duration(milliseconds: 500),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(AppTheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Question body ─────────────────────────────────────────────────────────
  Widget _buildQuestionBody(AlphabetQuestion currentQ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Instruction text
          Text(
            'What letter does this word start with?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // Image card + audio button
          _buildImageCard(currentQ),
          const SizedBox(height: 16),

          // Word label
          Text(
            currentQ.wordLabel,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: 1,
            ),
          ),

          // Difficulty badge
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Color(currentQ.difficultyColorValue).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              currentQ.difficultyLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(currentQ.difficultyColorValue),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Answer options
          _buildOptionButtons(currentQ),
          const SizedBox(height: 20),

          // Feedback area
          _buildFeedbackArea(currentQ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Image card ────────────────────────────────────────────────────────────
  Widget _buildImageCard(AlphabetQuestion q) {
    return ScaleTransition(
      scale: _bounceAnim,
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.asset(
                q.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      size: 60, color: Colors.grey.shade300),
                ),
              ),
            ),
            // Audio play button overlay
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _audio.playWord(q.audioPath),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.accent.withOpacity(0.4),
                          blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Option buttons ────────────────────────────────────────────────────────
  Widget _buildOptionButtons(AlphabetQuestion q) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: q.options.map((option) {
        final overrideColor = _buttonColors[option];
        final isSelected = _buttonColors.containsKey(option);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: overrideColor ?? AppTheme.secondary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: overrideColor ?? AppTheme.secondary.withOpacity(0.6),
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              elevation: isSelected ? 0 : 6,
              shadowColor: AppTheme.secondary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: isSelected
                    ? BorderSide(color: Colors.white.withOpacity(0.6), width: 2)
                    : BorderSide.none,
              ),
            ),
            onPressed: _isProcessing ? null : () => _handleAnswer(option),
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Feedback area ─────────────────────────────────────────────────────────
  Widget _buildFeedbackArea(AlphabetQuestion q) {
    return Column(
      children: [
        // Main feedback message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _feedbackMessage.isEmpty
              ? const SizedBox(height: 40)
              : FadeTransition(
                  opacity: _feedbackFade,
                  child: Container(
                    key: ValueKey(_feedbackMessage),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: (_isCorrect ? AppTheme.primary : AppTheme.danger)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (_isCorrect ? AppTheme.primary : AppTheme.danger)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _feedbackMessage,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _isCorrect ? AppTheme.primary : AppTheme.danger,
                      ),
                    ),
                  ),
                ),
        ),

        // Hint section
        if (_showHint) ...[
          const SizedBox(height: 12),
          if (_hintText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _hintText,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          else
            TextButton.icon(
              onPressed: _showHintText,
              icon: const Text('💡'),
              label: const Text('Show Hint'),
              style: TextButton.styleFrom(foregroundColor: Colors.amber.shade700),
            ),
        ],
      ],
    );
  }

  // ── Result screen ──────────────────────────────────────────────────────────
  Widget _buildResultScreen() {
    final summary = _game.getSummary();
    final accuracy = double.tryParse(summary['accuracy'] as String) ?? 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71), Color(0xFF1ABC9C)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Trophy / grade badge
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        summary['gradeEmoji'] as String,
                        style: const TextStyle(fontSize: 54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Game Over!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Grade ${summary['grade']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Stats card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _StatRow(
                            icon: Icons.star_rounded,
                            iconColor: AppTheme.secondary,
                            label: 'Score',
                            value: '${summary['score']}'),
                        _StatDivider(),
                        _StatRow(
                            icon: Icons.check_circle_rounded,
                            iconColor: AppTheme.primary,
                            label: 'Correct',
                            value: '${summary['correct']} / ${summary['totalQ']}'),
                        _StatDivider(),
                        _StatRow(
                            icon: Icons.percent_rounded,
                            iconColor: AppTheme.accent,
                            label: 'Accuracy',
                            value: '${accuracy.toStringAsFixed(0)}%'),
                        _StatDivider(),
                        _StatRow(
                            icon: Icons.local_fire_department_rounded,
                            iconColor: Colors.orange,
                            label: 'Best Streak',
                            value: '${summary['bestStreak']}'),
                        _StatDivider(),
                        _StatRow(
                            icon: Icons.favorite_rounded,
                            iconColor: AppTheme.danger,
                            label: 'Lives Left',
                            value: '${summary['livesLeft']}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Play again
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _restartGame,
                      icon: const Icon(Icons.replay_rounded, size: 22),
                      label: const Text(
                        'Play Again!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Small reusable widgets ────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color bgColor;

  const _Pill({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: Colors.grey.shade100);
}