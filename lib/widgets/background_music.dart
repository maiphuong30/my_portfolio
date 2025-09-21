import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundMusic extends StatefulWidget {
  const BackgroundMusic({super.key});

  @override
  State<BackgroundMusic> createState() => _BackgroundMusicState();
}

class _BackgroundMusicState extends State<BackgroundMusic>
    with TickerProviderStateMixin {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isMuted = false; // sửa: để false để nghe được
  bool _isExpanded = false;
  double _volume = 0.3;

  late final AnimationController _rotateController;
  late final AnimationController _scaleController;

  final String _musicUrl =
      "https://www.bensound.com/bensound-music/bensound-slowmotion.mp3"; // Chill lofi track

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _initPlayer();

    _rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 1.0,
      upperBound: 1.15,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scaleController.forward();
      }
    });

    _player.playerStateStream.listen((state) {
      final playing = state.playing;
      setState(() => _isPlaying = playing);
      if (playing) {
        _rotateController.repeat();
        _scaleController.forward();
      } else {
        _rotateController.stop();
        _scaleController.reset();
      }
    });
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(_musicUrl);
      await _player.setLoopMode(LoopMode.one);
      _player.setVolume(_isMuted ? 0.0 : _volume);
    } catch (e) {
      debugPrint("Error loading music: $e");
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _scaleController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      _player.setVolume(_isMuted ? 0.0 : _volume);
      await _player.play();
    }
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _player.setVolume(_isMuted ? 0.0 : _volume);
  }

  void _setVolume(double v) {
    setState(() => _volume = v);
    if (!_isMuted) _player.setVolume(v);
  }

  @override
  Widget build(BuildContext context) {
    // bỏ Positioned ở đây, để trong main.dart
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded) _buildExpandedCard(context),
        const SizedBox(height: 8),
        _buildToggleButton(),
      ],
    );
  }

  Widget _buildExpandedCard(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.95),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                RotationTransition(
                  turns: _rotateController,
                  child: ScaleTransition(
                    scale: _scaleController,
                    child: Icon(Icons.music_note,
                        color: _isPlaying ? Colors.pink : Colors.pink[200]),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("Chill Vibes",
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: _togglePlay,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                ),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: _setVolume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    activeColor: Colors.pink,
                    inactiveColor: Colors.pink.shade50,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _isPlaying ? "🎵 Playing soft lofi beats" : "🎵 Paused",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
        ),
        child: RotationTransition(
          turns: _rotateController,
          child: ScaleTransition(
            scale: _scaleController,
            child: Icon(
              Icons.music_note,
              color: _isPlaying ? Colors.pink : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
