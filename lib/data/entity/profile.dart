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

  Profile copyWith({
    String? id,
    String? name,
    List<Monitor>? displays,
    AudioSink? audioSink,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      displays: displays ?? this.displays,
      audioSink: audioSink ?? this.audioSink,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, displays: $displays, audioSink: $audioSink)';
  }
}
