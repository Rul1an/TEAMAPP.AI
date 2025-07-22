import 'package:equatable/equatable.dart';

class VideoPlaylist extends Equatable {
  const VideoPlaylist({
    required this.id,
    required this.name,
    required this.videoIds,
    this.description,
  });

  final String id;
  final String name;
  final List<String> videoIds;
  final String? description;

  @override
  List<Object?> get props => [id, name, videoIds, description];
}
