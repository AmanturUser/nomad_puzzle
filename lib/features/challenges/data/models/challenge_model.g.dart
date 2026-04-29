// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: (json['id'] as num).toInt(),
      titleRu: json['title_ru'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      shortDescriptionRu: json['short_description_ru'] as String? ?? '',
      shortDescriptionEn: json['short_description_en'] as String? ?? '',
      descriptionRu: json['description_ru'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      mainImageUrl: json['main_image_url'] as String?,
      level: json['level'] as String? ?? 'traveler',
      difficulty: (json['difficulty'] as num?)?.toInt(),
      rewardPoints: (json['reward_points'] as num?)?.toInt() ?? 0,
      estimatedDays: (json['estimated_days'] as num?)?.toInt(),
      estimatedCost: (json['estimated_cost'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      status: json['status'] as String? ?? 'published',
      locations:
          (json['locations'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ChallengeLocationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (e) => ChallengeImageModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      recommendedSeasons: (json['recommended_seasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title_ru': instance.titleRu,
      'title_en': instance.titleEn,
      'short_description_ru': instance.shortDescriptionRu,
      'short_description_en': instance.shortDescriptionEn,
      'description_ru': instance.descriptionRu,
      'description_en': instance.descriptionEn,
      'main_image_url': instance.mainImageUrl,
      'level': instance.level,
      'difficulty': instance.difficulty,
      'reward_points': instance.rewardPoints,
      'estimated_days': instance.estimatedDays,
      'estimated_cost': instance.estimatedCost,
      'currency': instance.currency,
      'status': instance.status,
      'locations': instance.locations.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'interests': instance.interests,
      'recommended_seasons': instance.recommendedSeasons,
    };

ChallengeLocationModel _$ChallengeLocationModelFromJson(
  Map<String, dynamic> json,
) => ChallengeLocationModel(
  id: (json['id'] as num).toInt(),
  challengeId: (json['challenge_id'] as num).toInt(),
  nameRu: json['name_ru'] as String? ?? '',
  nameEn: json['name_en'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
  address: json['address'] as String?,
  descriptionRu: json['description_ru'] as String?,
  descriptionEn: json['description_en'] as String?,
  orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChallengeLocationModelToJson(
  ChallengeLocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'challenge_id': instance.challengeId,
  'name_ru': instance.nameRu,
  'name_en': instance.nameEn,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'description_ru': instance.descriptionRu,
  'description_en': instance.descriptionEn,
  'order_index': instance.orderIndex,
};

ChallengeImageModel _$ChallengeImageModelFromJson(Map<String, dynamic> json) =>
    ChallengeImageModel(
      id: (json['id'] as num).toInt(),
      challengeId: (json['challenge_id'] as num).toInt(),
      url: json['url'] as String,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChallengeImageModelToJson(
  ChallengeImageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'challenge_id': instance.challengeId,
  'url': instance.url,
  'order_index': instance.orderIndex,
};
