// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourModel _$TourModelFromJson(Map<String, dynamic> json) => TourModel(
  id: (json['id'] as num).toInt(),
  titleRu: json['title_ru'] as String? ?? '',
  titleEn: json['title_en'] as String? ?? '',
  shortDescriptionRu: json['short_description_ru'] as String? ?? '',
  shortDescriptionEn: json['short_description_en'] as String? ?? '',
  descriptionRu: json['description_ru'] as String? ?? '',
  descriptionEn: json['description_en'] as String? ?? '',
  mainImageUrl: json['main_image_url'] as String?,
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => TourImageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  difficulty: json['difficulty'] as String?,
  durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
  durationNights: (json['duration_nights'] as num?)?.toInt() ?? 0,
  price: (json['price'] as num?)?.toDouble() ?? 0,
  currency: json['currency'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
  region: json['region'] as String?,
  startPointRu: json['start_point_ru'] as String?,
  startPointEn: json['start_point_en'] as String?,
  locations:
      (json['locations'] as List<dynamic>?)
          ?.map((e) => TourLocationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  programDays:
      (json['program_days'] as List<dynamic>?)
          ?.map((e) => TourProgramDayModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  accommodations:
      (json['accommodations'] as List<dynamic>?)
          ?.map(
            (e) => TourAccommodationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  inclusions:
      (json['inclusions'] as List<dynamic>?)
          ?.map((e) => TourFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  exclusions:
      (json['exclusions'] as List<dynamic>?)
          ?.map((e) => TourFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  includesRu: json['includes_ru'] as String?,
  includesEn: json['includes_en'] as String?,
  excludesRu: json['excludes_ru'] as String?,
  excludesEn: json['excludes_en'] as String?,
  seasons:
      (json['seasons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  minGroupSize: (json['min_group_size'] as num?)?.toInt() ?? 0,
  maxGroupSize: (json['max_group_size'] as num?)?.toInt() ?? 0,
  departures:
      (json['departures'] as List<dynamic>?)
          ?.map((e) => TourDepartureModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  videoUrl: json['video_url'] as String?,
  mapEmbed: json['map_embed'] as String?,
);

Map<String, dynamic> _$TourModelToJson(TourModel instance) => <String, dynamic>{
  'id': instance.id,
  'title_ru': instance.titleRu,
  'title_en': instance.titleEn,
  'short_description_ru': instance.shortDescriptionRu,
  'short_description_en': instance.shortDescriptionEn,
  'description_ru': instance.descriptionRu,
  'description_en': instance.descriptionEn,
  'main_image_url': instance.mainImageUrl,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'difficulty': instance.difficulty,
  'duration_days': instance.durationDays,
  'duration_nights': instance.durationNights,
  'price': instance.price,
  'currency': instance.currency,
  'rating': instance.rating,
  'reviews_count': instance.reviewsCount,
  'region': instance.region,
  'start_point_ru': instance.startPointRu,
  'start_point_en': instance.startPointEn,
  'locations': instance.locations.map((e) => e.toJson()).toList(),
  'program_days': instance.programDays.map((e) => e.toJson()).toList(),
  'accommodations': instance.accommodations.map((e) => e.toJson()).toList(),
  'inclusions': instance.inclusions.map((e) => e.toJson()).toList(),
  'exclusions': instance.exclusions.map((e) => e.toJson()).toList(),
  'includes_ru': instance.includesRu,
  'includes_en': instance.includesEn,
  'excludes_ru': instance.excludesRu,
  'excludes_en': instance.excludesEn,
  'seasons': instance.seasons,
  'languages': instance.languages,
  'min_group_size': instance.minGroupSize,
  'max_group_size': instance.maxGroupSize,
  'departures': instance.departures.map((e) => e.toJson()).toList(),
  'video_url': instance.videoUrl,
  'map_embed': instance.mapEmbed,
};

TourImageModel _$TourImageModelFromJson(Map<String, dynamic> json) =>
    TourImageModel(
      id: (json['id'] as num).toInt(),
      tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
      url: json['url'] as String? ?? '',
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TourImageModelToJson(TourImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tour_id': instance.tourId,
      'url': instance.url,
      'order_index': instance.orderIndex,
    };

TourLocationModel _$TourLocationModelFromJson(Map<String, dynamic> json) =>
    TourLocationModel(
      id: (json['id'] as num).toInt(),
      tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
      nameRu: json['name_ru'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      dayNumber: (json['day_number'] as num?)?.toInt() ?? 0,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TourLocationModelToJson(TourLocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tour_id': instance.tourId,
      'name_ru': instance.nameRu,
      'name_en': instance.nameEn,
      'description_ru': instance.descriptionRu,
      'description_en': instance.descriptionEn,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'day_number': instance.dayNumber,
      'order_index': instance.orderIndex,
    };

TourProgramDayModel _$TourProgramDayModelFromJson(Map<String, dynamic> json) =>
    TourProgramDayModel(
      id: (json['id'] as num).toInt(),
      tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
      dayNumber: (json['day_number'] as num?)?.toInt() ?? 0,
      titleRu: json['title_ru'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      bodyRu: json['body_ru'] as String? ?? '',
      bodyEn: json['body_en'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TourProgramDayModelToJson(
  TourProgramDayModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tour_id': instance.tourId,
  'day_number': instance.dayNumber,
  'title_ru': instance.titleRu,
  'title_en': instance.titleEn,
  'body_ru': instance.bodyRu,
  'body_en': instance.bodyEn,
  'image_url': instance.imageUrl,
  'order_index': instance.orderIndex,
};

TourAccommodationModel _$TourAccommodationModelFromJson(
  Map<String, dynamic> json,
) => TourAccommodationModel(
  id: (json['id'] as num).toInt(),
  tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
  nameRu: json['name_ru'] as String? ?? '',
  nameEn: json['name_en'] as String? ?? '',
  locationRu: json['location_ru'] as String? ?? '',
  locationEn: json['location_en'] as String? ?? '',
  imageUrl: json['image_url'] as String?,
  nights: (json['nights'] as num?)?.toInt() ?? 0,
  orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TourAccommodationModelToJson(
  TourAccommodationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tour_id': instance.tourId,
  'name_ru': instance.nameRu,
  'name_en': instance.nameEn,
  'location_ru': instance.locationRu,
  'location_en': instance.locationEn,
  'image_url': instance.imageUrl,
  'nights': instance.nights,
  'order_index': instance.orderIndex,
};

TourFeatureModel _$TourFeatureModelFromJson(Map<String, dynamic> json) =>
    TourFeatureModel(
      id: (json['id'] as num).toInt(),
      tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
      titleRu: json['title_ru'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TourFeatureModelToJson(TourFeatureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tour_id': instance.tourId,
      'title_ru': instance.titleRu,
      'title_en': instance.titleEn,
      'order_index': instance.orderIndex,
    };

TourDepartureModel _$TourDepartureModelFromJson(Map<String, dynamic> json) =>
    TourDepartureModel(
      id: (json['id'] as num).toInt(),
      tourId: (json['tour_id'] as num?)?.toInt() ?? 0,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String?,
      seatsTotal: (json['seats_total'] as num?)?.toInt() ?? 0,
      seatsTaken: (json['seats_taken'] as num?)?.toInt() ?? 0,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TourDepartureModelToJson(TourDepartureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tour_id': instance.tourId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'price': instance.price,
      'currency': instance.currency,
      'seats_total': instance.seatsTotal,
      'seats_taken': instance.seatsTaken,
      'status': instance.status,
      'notes': instance.notes,
    };
