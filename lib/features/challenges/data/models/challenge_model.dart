import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/api_constants.dart';
import '../../domain/entities/challenge.dart';

part 'challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeModel {
  const ChallengeModel({
    required this.id,
    this.titleRu = '',
    this.titleEn = '',
    this.shortDescriptionRu = '',
    this.shortDescriptionEn = '',
    this.descriptionRu = '',
    this.descriptionEn = '',
    this.mainImageUrl,
    this.level = 'traveler',
    this.difficulty,
    this.rewardPoints = 0,
    this.estimatedDays,
    this.estimatedCost,
    this.currency,
    this.status = 'published',
    this.locations = const [],
    this.images = const [],
    this.interests = const [],
    this.recommendedSeasons,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);

  final int id;
  @JsonKey(name: 'title_ru', defaultValue: '')
  final String titleRu;
  @JsonKey(name: 'title_en', defaultValue: '')
  final String titleEn;
  @JsonKey(name: 'short_description_ru', defaultValue: '')
  final String shortDescriptionRu;
  @JsonKey(name: 'short_description_en', defaultValue: '')
  final String shortDescriptionEn;
  @JsonKey(name: 'description_ru', defaultValue: '')
  final String descriptionRu;
  @JsonKey(name: 'description_en', defaultValue: '')
  final String descriptionEn;
  @JsonKey(name: 'main_image_url')
  final String? mainImageUrl;
  @JsonKey(defaultValue: 'traveler')
  final String level;
  final int? difficulty;
  @JsonKey(name: 'reward_points', defaultValue: 0)
  final int rewardPoints;
  @JsonKey(name: 'estimated_days')
  final int? estimatedDays;
  @JsonKey(name: 'estimated_cost')
  final int? estimatedCost;
  final String? currency;
  @JsonKey(defaultValue: 'published')
  final String status;
  @JsonKey(defaultValue: <ChallengeLocationModel>[])
  final List<ChallengeLocationModel> locations;
  @JsonKey(defaultValue: <ChallengeImageModel>[])
  final List<ChallengeImageModel> images;
  @JsonKey(defaultValue: <int>[])
  final List<int> interests;
  @JsonKey(name: 'recommended_seasons')
  final List<String>? recommendedSeasons;

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);

  Challenge toEntity() {
    final firstLoc = locations.isNotEmpty ? locations.first : null;
    final raw = mainImageUrl;
    final image = (raw == null || raw.isEmpty)
        ? _fallbackPhoto
        : _rewriteHost(raw);
    final desc = descriptionRu.isNotEmpty
        ? descriptionRu
        : (shortDescriptionRu.isNotEmpty
            ? shortDescriptionRu
            : (descriptionEn.isNotEmpty ? descriptionEn : shortDescriptionEn));
    return Challenge(
      id: id.toString(),
      title: titleRu.isNotEmpty ? titleRu : titleEn,
      description: desc.isNotEmpty ? desc : '—',
      imageUrl: image,
      rewardPoints: rewardPoints,
      location: firstLoc?.nameRu ?? firstLoc?.nameEn ?? '—',
      lat: firstLoc?.latitude ?? 41.3,
      lng: firstLoc?.longitude ?? 74.9,
      estimatedMinutes: (estimatedDays ?? 0) * 24 * 60,
      difficulty: _mapDifficulty(level, difficulty ?? 0),
      status: ChallengeStatus.available,
    );
  }

  static const _fallbackPhoto =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200';

  static String _rewriteHost(String url) {
    // The TKNR backend embeds `http://localhost:8080/...` for uploaded images
    // — that host isn't reachable from a phone. Rewrite to the configured
    // base URL so the device can actually fetch the file.
    if (url.startsWith('http://localhost:8080')) {
      return url.replaceFirst('http://localhost:8080', ApiConstants.baseUrl);
    }
    if (url.startsWith('https://localhost:8080')) {
      return url.replaceFirst('https://localhost:8080', ApiConstants.baseUrl);
    }
    return url;
  }

  static ChallengeDifficulty _mapDifficulty(String level, int rawDifficulty) {
    if (level == 'hero' || rawDifficulty >= 3) {
      return ChallengeDifficulty.hard;
    }
    return ChallengeDifficulty.easy;
  }
}

@JsonSerializable()
class ChallengeLocationModel {
  const ChallengeLocationModel({
    required this.id,
    required this.challengeId,
    this.nameRu = '',
    this.nameEn = '',
    this.latitude = 0,
    this.longitude = 0,
    this.address,
    this.descriptionRu,
    this.descriptionEn,
    this.orderIndex = 0,
  });

  factory ChallengeLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeLocationModelFromJson(json);

  final int id;
  @JsonKey(name: 'challenge_id')
  final int challengeId;
  @JsonKey(name: 'name_ru', defaultValue: '')
  final String nameRu;
  @JsonKey(name: 'name_en', defaultValue: '')
  final String nameEn;
  @JsonKey(defaultValue: 0)
  final double latitude;
  @JsonKey(defaultValue: 0)
  final double longitude;
  final String? address;
  @JsonKey(name: 'description_ru')
  final String? descriptionRu;
  @JsonKey(name: 'description_en')
  final String? descriptionEn;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$ChallengeLocationModelToJson(this);
}

@JsonSerializable()
class ChallengeImageModel {
  const ChallengeImageModel({
    required this.id,
    required this.challengeId,
    required this.url,
    this.orderIndex = 0,
  });

  factory ChallengeImageModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeImageModelFromJson(json);

  final int id;
  @JsonKey(name: 'challenge_id')
  final int challengeId;
  final String url;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$ChallengeImageModelToJson(this);
}
