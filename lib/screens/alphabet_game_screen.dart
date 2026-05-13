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
} 
 */
import 'package:flutter/material.dart';
import '../models/alphabet_game_logic.dart';
import '../services/audio_manager.dart';

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen>
    with SingleTickerProviderStateMixin {
  // ── Composition (OOP: has-a relationship) ──────────────────────────────────
  final AlphabetGameLogic _game = AlphabetGameLogic();
  final AudioManager _audioManager = AudioManager();

  // ── State ──────────────────────────────────────────────────────────────────
  String _feedbackMessage = "";
  bool _isProcessing = false;
  FeedbackState _feedbackState = FeedbackState.neutral;

  // ── Card entrance animation ────────────────────────────────────────────────
  late AnimationController _cardAnimController;
  late Animation<double> _cardScaleAnim;

  // ── Design tokens ─────────────────────────────────────────────────────────
  static const _gradientStart = Color(0xFFFFF3E0);
  static const _gradientEnd   = Color(0xFFE8F5E9);
  static const _cardWhite     = Colors.white;
  static const _shadowColor   = Color(0x33000000);
  static const _answerColors  = [
    Color(0xFFFF7043),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
  ];

  @override
  void initState() {
    super.initState();
    _game.startGame();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cardScaleAnim = CurvedAnimation(
      parent: _cardAnimController,
      curve: Curves.elasticOut,
    );
    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _audioManager.dispose();
    _cardAnimController.dispose();
    super.dispose();
  }

  void _animateCardIn() {
    _cardAnimController.reset();
    _cardAnimController.forward();
  }

  Future<void> _handleAnswer(String selected) async {
    if (_isProcessing) return;

    final currentQ = _game.getCurrentQuestion()!;
    final isCorrect = _game.checkAnswer(selected, currentQ.correctAnswer);
    _audioManager.playSfx(isCorrect);

    if (isCorrect) {
      setState(() {
        _feedbackMessage = "Correct! 🎉";
        _feedbackState   = FeedbackState.correct;
        _isProcessing    = true;
      });

      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _game.nextQuestion();
        _isProcessing = false;

        if (_game.getCurrentQuestion() == null) {
          _feedbackMessage = "Game Over! You scored ${_game.score} 🌟";
          _feedbackState   = FeedbackState.gameOver;
          _game.endGame();
        } else {
          _feedbackMessage = "";
          _feedbackState   = FeedbackState.neutral;
          _animateCardIn();
        }
      });
    } else {
      setState(() {
        _feedbackMessage = "Oops, try again! ❌";
        _feedbackState   = FeedbackState.wrong;
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final currentQ = _game.getCurrentQuestion();

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: currentQ == null
              ? _buildGameOverScreen()
              : _buildGameBody(currentQ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: _shadowColor, blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_stories, color: Colors.white, size: 26),
              SizedBox(width: 8),
              Text(
                "EarlyLearn.lk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
    );
  }

  // ── Game Body ──────────────────────────────────────────────────────────────

  Widget _buildGameBody(currentQ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 18),

        // Score badge
        _buildScoreBadge(),
        const SizedBox(height: 18),

        // ── Question Text Box ─────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4FC3F7),
                Color(0xFF1976D2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x331976D2),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 12),

              Expanded(
                child: Text(
                  "රූපයට අදාළ පළමු අකුර තෝරන්න",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Image Card ───────────────────────────────────
        Expanded(
          child: ScaleTransition(
            scale: _cardScaleAnim,
            child: _buildQuestionCard(currentQ),
          ),
        ),

        const SizedBox(height: 20),

        // Answer buttons
        _buildAnswerButtons(currentQ),

        const SizedBox(height: 12),

        // Feedback banner
        if (_feedbackMessage.isNotEmpty) _buildFeedbackBanner(),

        const SizedBox(height: 40),
      ],
    ),
  );
}
  // ── Score Badge ────────────────────────────────────────────────────────────

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: _shadowColor, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFDD835), size: 26),
          const SizedBox(width: 8),
          Text(
            "Score: ${_game.score}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF37474F),
            ),
          ),
        ],
      ),
    );
  }

  // ── Question Card ──────────────────────────────────────────────────────────

  Widget _buildQuestionCard(currentQ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: _shadowColor, blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          // Image fills the entire card
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  currentQ.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // Small audio button pinned to bottom-right corner
          Positioned(
            bottom: 14,
            right: 14,
            child: _buildAudioButton(currentQ.audioPath),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioButton(String audioPath) {
    return GestureDetector(
      onTap: () => _audioManager.playWord(audioPath),
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1565C0),
          boxShadow: const [
            BoxShadow(
                color: Color(0x441565C0),
                blurRadius: 10,
                offset: Offset(0, 4)),
          ],
        ),
        child: const Icon(Icons.volume_up_rounded,
            color: Colors.white, size: 26),
      ),
    );
  }

  // ── Answer Buttons ─────────────────────────────────────────────────────────

  Widget _buildAnswerButtons(currentQ) {
    final options = currentQ.options as List<String>;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (index) {
        final color = _answerColors[index % _answerColors.length];
        return _AnswerButton(
          label: options[index],
          color: color,
          onTap: _isProcessing ? null : () => _handleAnswer(options[index]),
        );
      }),
    );
  }

  // ── Feedback Banner ────────────────────────────────────────────────────────

  Widget _buildFeedbackBanner() {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (_feedbackState) {
      case FeedbackState.correct:
        bgColor   = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        icon      = Icons.check_circle_rounded;
        break;
      case FeedbackState.wrong:
        bgColor   = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        icon      = Icons.cancel_rounded;
        break;
      case FeedbackState.gameOver:
        bgColor   = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFE65100);
        icon      = Icons.emoji_events_rounded;
        break;
      case FeedbackState.neutral:
        bgColor   = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        icon      = Icons.hearing_rounded;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: _shadowColor, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Game Over Screen ───────────────────────────────────────────────────────

  Widget _buildGameOverScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: _cardWhite,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                  color: _shadowColor, blurRadius: 24, offset: Offset(0, 10))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🌟", style: TextStyle(fontSize: 72)),
              const SizedBox(height: 16),
              const Text(
                "Well Done!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Final Score: ${_game.score}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF37474F),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _game.startGame();
                    _feedbackMessage = "";
                    _feedbackState   = FeedbackState.neutral;
                    _animateCardIn();
                  });
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text("Play Again",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  shadowColor: const Color(0x6643A047),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Feedback state enum ───────────────────────────────────────────────────────
enum FeedbackState { neutral, correct, wrong, gameOver }

// ── Reusable answer button widget ─────────────────────────────────────────────
class _AnswerButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _AnswerButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(_pressCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _pressCtrl.forward(),
      onTapUp: isDisabled
          ? null
          : (_) {
              _pressCtrl.reverse();
              widget.onTap?.call();
            },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.55 : 1.0,
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 38,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 2))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}