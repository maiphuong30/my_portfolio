import 'dart:async';
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
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool _isPlaying = false;
  bool _isMuted = true; // mặc định muted
  bool _isExpanded = false;
  double _volume = 0.3;

  late final AnimationController _rotateController;
  late final AnimationController _scaleController;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration?>? _durSub;

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

    _stateSub = _player.playerStateStream.listen((state) {
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

    _posSub = _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _durSub = _player.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(_musicUrl);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(_isMuted ? 0.0 : _volume);
    } catch (e) {
      debugPrint("Error loading music: $e");
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _stateSub?.cancel();
    _durSub?.cancel();
    _rotateController.dispose();
    _scaleController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.setVolume(_isMuted ? 0.0 : _volume);
      await _player.play();
    }
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _player.setVolume(_isMuted ? 0.0 : _volume);
  }

  void _setVolume(double v) {
    setState(() {
      _volume = v;
      if (_isMuted) _isMuted = false;
    });
    _player.setVolume(v);
  }

  Future<void> _seek(double t) async {
    final ms = (_duration.inMilliseconds * t).round();
    await _player.seek(Duration(milliseconds: ms));
  }

  Future<void> _jumpSeconds(int sec) async {
    final newPos = _position + Duration(seconds: sec);
    final target = newPos < Duration.zero ? Duration.zero : (newPos > _duration ? _duration : newPos);
    await _player.seek(target);
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${d.inHours > 0 ? '${d.inHours}:' : ''}$mm:$ss";
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          SizedBox(
            width: 300,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // header: title + (giữ tinh gọn)
                    Row(
                      children: [
                        RotationTransition(
                          turns: _rotateController,
                          child: ScaleTransition(
                            scale: _scaleController,
                            child: Icon(Icons.music_note, color: _isPlaying ? Colors.pink : Colors.pink[200]),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Chill Vibes', style: TextStyle(fontWeight: FontWeight.w600))),
                        IconButton(
                          tooltip: _isPlaying ? 'Pause' : 'Play',
                          onPressed: () async => await _togglePlay(),
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ],
                    ),

                    // progress + times
                    Row(
                      children: [
                        Text(_fmt(_position), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 1,
                            value: progress,
                            onChanged: (v) => setState(() => _position = Duration(milliseconds: (_duration.inMilliseconds * v).round())),
                            onChangeEnd: (v) => _seek(v),
                            activeColor: Colors.pink,
                            inactiveColor: Colors.pink.shade50,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_fmt(_duration), style: const TextStyle(fontSize: 12)),
                      ],
                    ),

                    // controls: skip, play/pause, skip
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      IconButton(onPressed: () => _jumpSeconds(-10), icon: const Icon(Icons.replay_10)),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () async => await _togglePlay(),
                        iconSize: 32,
                        icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: () => _jumpSeconds(10), icon: const Icon(Icons.forward_10)),
                    ]),

                    const SizedBox(height: 8),

                    // GỘP: mute + volume nằm cùng 1 hàng
                    Row(
                      children: [
                        IconButton(
                          tooltip: _isMuted ? 'Unmute' : 'Mute',
                          onPressed: _toggleMute,
                          icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                        ),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            min: 0,
                            max: 1,
                            divisions: 10,
                            onChanged: (v) => _setVolume(v),
                            activeColor: Colors.pink,
                            inactiveColor: Colors.pink.shade50,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${(_volume * 100).round()}%', style: const TextStyle(fontSize: 12)),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(_isPlaying ? "🎵 Playing" : "🎵 Paused", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        // collapsed toggle button (gọn)
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ]),
            child: RotationTransition(
              turns: _rotateController,
              child: ScaleTransition(
                scale: _scaleController,
                child: Icon(Icons.music_note, color: _isPlaying ? Colors.pink : Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
