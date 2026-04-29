import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

enum ChallengeDifficulty { easy, hard }

enum ChallengeStatus { locked, available, inProgress, completed }

class Challenge extends Equatable {
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.status,
    required this.rewardPoints,
    required this.location,
    required this.lat,
    required this.lng,
    this.estimatedMinutes,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final ChallengeDifficulty difficulty;
  final ChallengeStatus status;
  final int rewardPoints;
  final String location;
  final double lat;
  final double lng;
  final int? estimatedMinutes;

  LatLng get latLng => LatLng(lat, lng);

  Challenge copyWith({ChallengeStatus? status}) => Challenge(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        difficulty: difficulty,
        status: status ?? this.status,
        rewardPoints: rewardPoints,
        location: location,
        lat: lat,
        lng: lng,
        estimatedMinutes: estimatedMinutes,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        difficulty,
        status,
        rewardPoints,
        location,
        lat,
        lng,
        estimatedMinutes,
      ];
}
