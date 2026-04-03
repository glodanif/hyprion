import 'audio_sink.dart';
import 'monitor.dart';

class Profile {
  final String id;
  final String name;
  final List<Monitor> displays;
  final AudioSink? audioSink;

  Profile({
    required this.id,
    required this.name,
    required this.displays,
    this.audioSink,
  });
}
