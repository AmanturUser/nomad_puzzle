import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/api_constants.dart';
import '../../domain/entities/tour.dart';

part 'tour_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TourModel {
  const TourModel({
    required this.id,
    this.titleRu = '',
    this.titleEn = '',
    this.shortDescriptionRu = '',
    this.shortDescriptionEn = '',
    this.descriptionRu = '',
    this.descriptionEn = '',
    this.mainImageUrl,
    this.images = const [],
    this.difficulty,
    this.durationDays = 0,
    this.durationNights = 0,
    this.price = 0,
    this.currency,
    this.rating = 0,
    this.reviewsCount = 0,
    this.region,
    this.startPointRu,
    this.startPointEn,
    this.locations = const [],
    this.programDays = const [],
    this.accommodations = const [],
    this.inclusions = const [],
    this.exclusions = const [],
    this.includesRu,
    this.includesEn,
    this.excludesRu,
    this.excludesEn,
    this.seasons = const [],
    this.languages = const [],
    this.minGroupSize = 0,
    this.maxGroupSize = 0,
    this.departures = const [],
    this.videoUrl,
    this.mapEmbed,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) =>
      _$TourModelFromJson(json);

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
  @JsonKey(defaultValue: <TourImageModel>[])
  final List<TourImageModel> images;
  final String? difficulty;
  @JsonKey(name: 'duration_days', defaultValue: 0)
  final int durationDays;
  @JsonKey(name: 'duration_nights', defaultValue: 0)
  final int durationNights;
  @JsonKey(defaultValue: 0)
  final double price;
  final String? currency;
  @JsonKey(defaultValue: 0)
  final double rating;
  @JsonKey(name: 'reviews_count', defaultValue: 0)
  final int reviewsCount;
  final String? region;
  @JsonKey(name: 'start_point_ru')
  final String? startPointRu;
  @JsonKey(name: 'start_point_en')
  final String? startPointEn;
  @JsonKey(defaultValue: <TourLocationModel>[])
  final List<TourLocationModel> locations;
  @JsonKey(name: 'program_days', defaultValue: <TourProgramDayModel>[])
  final List<TourProgramDayModel> programDays;
  @JsonKey(defaultValue: <TourAccommodationModel>[])
  final List<TourAccommodationModel> accommodations;
  @JsonKey(defaultValue: <TourFeatureModel>[])
  final List<TourFeatureModel> inclusions;
  @JsonKey(defaultValue: <TourFeatureModel>[])
  final List<TourFeatureModel> exclusions;
  @JsonKey(name: 'includes_ru')
  final String? includesRu;
  @JsonKey(name: 'includes_en')
  final String? includesEn;
  @JsonKey(name: 'excludes_ru')
  final String? excludesRu;
  @JsonKey(name: 'excludes_en')
  final String? excludesEn;
  @JsonKey(defaultValue: <String>[])
  final List<String> seasons;
  @JsonKey(defaultValue: <String>[])
  final List<String> languages;
  @JsonKey(name: 'min_group_size', defaultValue: 0)
  final int minGroupSize;
  @JsonKey(name: 'max_group_size', defaultValue: 0)
  final int maxGroupSize;
  @JsonKey(defaultValue: <TourDepartureModel>[])
  final List<TourDepartureModel> departures;
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @JsonKey(name: 'map_embed')
  final String? mapEmbed;

  Map<String, dynamic> toJson() => _$TourModelToJson(this);

  Tour toEntity() {
    final mainImage = _rewriteHost(mainImageUrl ?? '');
    final orderedImages = [...images]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final imageUrls = [
      for (final i in orderedImages)
        if (i.url.isNotEmpty) _rewriteHost(i.url),
    ];
    final orderedLocations = [...locations]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final orderedProgram = [...programDays]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final orderedAccommodations = [...accommodations]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final orderedInclusions = [...inclusions]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final orderedExclusions = [...exclusions]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return Tour(
      id: id.toString(),
      titleRu: titleRu,
      titleEn: titleEn,
      shortDescriptionRu: shortDescriptionRu,
      shortDescriptionEn: shortDescriptionEn,
      descriptionRu: descriptionRu,
      descriptionEn: descriptionEn,
      mainImageUrl: mainImage,
      imageUrls: imageUrls,
      difficulty: _mapDifficulty(difficulty),
      durationDays: durationDays,
      durationNights: durationNights,
      price: price,
      currency: currency ?? 'USD',
      rating: rating,
      reviewsCount: reviewsCount,
      region: region ?? '',
      startPointRu: startPointRu ?? '',
      startPointEn: startPointEn ?? '',
      locations: orderedLocations.map((m) => m.toEntity()).toList(),
      programDays: orderedProgram.map((m) => m.toEntity()).toList(),
      accommodations:
          orderedAccommodations.map((m) => m.toEntity()).toList(),
      inclusions: orderedInclusions.map((m) => m.toEntity()).toList(),
      exclusions: orderedExclusions.map((m) => m.toEntity()).toList(),
      includesText: includesRu?.isNotEmpty == true
          ? includesRu!
          : (includesEn ?? ''),
      excludesText: excludesRu?.isNotEmpty == true
          ? excludesRu!
          : (excludesEn ?? ''),
      seasons: seasons,
      languages: languages,
      minGroupSize: minGroupSize,
      maxGroupSize: maxGroupSize,
      departures: departures.map((m) => m.toEntity()).toList(),
      videoUrl: videoUrl ?? '',
      mapEmbed: mapEmbed ?? '',
    );
  }

  static TourDifficulty _mapDifficulty(String? raw) {
    return switch (raw) {
      'easy' => TourDifficulty.easy,
      'moderate' => TourDifficulty.moderate,
      'hard' => TourDifficulty.hard,
      'extreme' => TourDifficulty.extreme,
      _ => TourDifficulty.moderate,
    };
  }

  static String _rewriteHost(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('/')) {
      return '${ApiConstants.baseUrl}$url';
    }
    if (url.startsWith('http://localhost:8080')) {
      return url.replaceFirst('http://localhost:8080', ApiConstants.baseUrl);
    }
    if (url.startsWith('https://localhost:8080')) {
      return url.replaceFirst('https://localhost:8080', ApiConstants.baseUrl);
    }
    return url;
  }
}

@JsonSerializable()
class TourImageModel {
  const TourImageModel({
    required this.id,
    this.tourId = 0,
    this.url = '',
    this.orderIndex = 0,
  });

  factory TourImageModel.fromJson(Map<String, dynamic> json) =>
      _$TourImageModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(defaultValue: '')
  final String url;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TourImageModelToJson(this);
}

@JsonSerializable()
class TourLocationModel {
  const TourLocationModel({
    required this.id,
    this.tourId = 0,
    this.nameRu = '',
    this.nameEn = '',
    this.descriptionRu,
    this.descriptionEn,
    this.address,
    this.latitude = 0,
    this.longitude = 0,
    this.dayNumber = 0,
    this.orderIndex = 0,
  });

  factory TourLocationModel.fromJson(Map<String, dynamic> json) =>
      _$TourLocationModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(name: 'name_ru', defaultValue: '')
  final String nameRu;
  @JsonKey(name: 'name_en', defaultValue: '')
  final String nameEn;
  @JsonKey(name: 'description_ru')
  final String? descriptionRu;
  @JsonKey(name: 'description_en')
  final String? descriptionEn;
  final String? address;
  @JsonKey(defaultValue: 0)
  final double latitude;
  @JsonKey(defaultValue: 0)
  final double longitude;
  @JsonKey(name: 'day_number', defaultValue: 0)
  final int dayNumber;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TourLocationModelToJson(this);

  TourLocation toEntity() => TourLocation(
        id: id,
        nameRu: nameRu,
        nameEn: nameEn,
        descriptionRu: descriptionRu ?? '',
        descriptionEn: descriptionEn ?? '',
        address: address ?? '',
        latitude: latitude,
        longitude: longitude,
        dayNumber: dayNumber,
        orderIndex: orderIndex,
      );
}

@JsonSerializable()
class TourProgramDayModel {
  const TourProgramDayModel({
    required this.id,
    this.tourId = 0,
    this.dayNumber = 0,
    this.titleRu = '',
    this.titleEn = '',
    this.bodyRu = '',
    this.bodyEn = '',
    this.imageUrl,
    this.orderIndex = 0,
  });

  factory TourProgramDayModel.fromJson(Map<String, dynamic> json) =>
      _$TourProgramDayModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(name: 'day_number', defaultValue: 0)
  final int dayNumber;
  @JsonKey(name: 'title_ru', defaultValue: '')
  final String titleRu;
  @JsonKey(name: 'title_en', defaultValue: '')
  final String titleEn;
  @JsonKey(name: 'body_ru', defaultValue: '')
  final String bodyRu;
  @JsonKey(name: 'body_en', defaultValue: '')
  final String bodyEn;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TourProgramDayModelToJson(this);

  TourProgramDay toEntity() => TourProgramDay(
        id: id,
        dayNumber: dayNumber,
        titleRu: titleRu,
        titleEn: titleEn,
        bodyRu: bodyRu,
        bodyEn: bodyEn,
        imageUrl: TourModel._rewriteHost(imageUrl ?? ''),
      );
}

@JsonSerializable()
class TourAccommodationModel {
  const TourAccommodationModel({
    required this.id,
    this.tourId = 0,
    this.nameRu = '',
    this.nameEn = '',
    this.locationRu = '',
    this.locationEn = '',
    this.imageUrl,
    this.nights = 0,
    this.orderIndex = 0,
  });

  factory TourAccommodationModel.fromJson(Map<String, dynamic> json) =>
      _$TourAccommodationModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(name: 'name_ru', defaultValue: '')
  final String nameRu;
  @JsonKey(name: 'name_en', defaultValue: '')
  final String nameEn;
  @JsonKey(name: 'location_ru', defaultValue: '')
  final String locationRu;
  @JsonKey(name: 'location_en', defaultValue: '')
  final String locationEn;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(defaultValue: 0)
  final int nights;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TourAccommodationModelToJson(this);

  TourAccommodation toEntity() => TourAccommodation(
        id: id,
        nameRu: nameRu,
        nameEn: nameEn,
        locationRu: locationRu,
        locationEn: locationEn,
        imageUrl: TourModel._rewriteHost(imageUrl ?? ''),
        nights: nights,
        orderIndex: orderIndex,
      );
}

@JsonSerializable()
class TourFeatureModel {
  const TourFeatureModel({
    required this.id,
    this.tourId = 0,
    this.titleRu = '',
    this.titleEn = '',
    this.orderIndex = 0,
  });

  factory TourFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$TourFeatureModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(name: 'title_ru', defaultValue: '')
  final String titleRu;
  @JsonKey(name: 'title_en', defaultValue: '')
  final String titleEn;
  @JsonKey(name: 'order_index', defaultValue: 0)
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TourFeatureModelToJson(this);

  TourFeature toEntity() => TourFeature(
        id: id,
        titleRu: titleRu,
        titleEn: titleEn,
        orderIndex: orderIndex,
      );
}

@JsonSerializable()
class TourDepartureModel {
  const TourDepartureModel({
    required this.id,
    this.tourId = 0,
    this.startDate,
    this.endDate,
    this.price = 0,
    this.currency,
    this.seatsTotal = 0,
    this.seatsTaken = 0,
    this.status,
    this.notes,
  });

  factory TourDepartureModel.fromJson(Map<String, dynamic> json) =>
      _$TourDepartureModelFromJson(json);

  final int id;
  @JsonKey(name: 'tour_id', defaultValue: 0)
  final int tourId;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(defaultValue: 0)
  final double price;
  final String? currency;
  @JsonKey(name: 'seats_total', defaultValue: 0)
  final int seatsTotal;
  @JsonKey(name: 'seats_taken', defaultValue: 0)
  final int seatsTaken;
  final String? status;
  final String? notes;

  Map<String, dynamic> toJson() => _$TourDepartureModelToJson(this);

  TourDeparture toEntity() {
    final start = DateTime.tryParse(startDate ?? '') ?? DateTime.now();
    final end = DateTime.tryParse(endDate ?? '') ?? start;
    return TourDeparture(
      id: id,
      tourId: tourId,
      startDate: start,
      endDate: end,
      price: price,
      currency: currency ?? 'USD',
      seatsTotal: seatsTotal,
      seatsTaken: seatsTaken,
      status: _mapStatus(status),
      notes: notes ?? '',
    );
  }

  static DepartureStatus _mapStatus(String? raw) {
    return switch (raw) {
      'open' => DepartureStatus.open,
      'full' => DepartureStatus.full,
      'cancelled' => DepartureStatus.cancelled,
      'completed' => DepartureStatus.completed,
      _ => DepartureStatus.unknown,
    };
  }
}

