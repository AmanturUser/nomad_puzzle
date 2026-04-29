import 'package:equatable/equatable.dart';

enum TourDifficulty { easy, moderate, hard, extreme }

class Tour extends Equatable {
  const Tour({
    required this.id,
    required this.titleRu,
    required this.titleEn,
    required this.shortDescriptionRu,
    required this.shortDescriptionEn,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.mainImageUrl,
    required this.imageUrls,
    required this.difficulty,
    required this.durationDays,
    required this.durationNights,
    required this.price,
    required this.currency,
    required this.rating,
    required this.reviewsCount,
    required this.region,
    required this.startPointRu,
    required this.startPointEn,
    required this.locations,
    required this.programDays,
    required this.accommodations,
    required this.inclusions,
    required this.exclusions,
    required this.includesText,
    required this.excludesText,
    required this.seasons,
    required this.languages,
    required this.minGroupSize,
    required this.maxGroupSize,
    required this.departures,
    required this.videoUrl,
    required this.mapEmbed,
  });

  final String id;
  final String titleRu;
  final String titleEn;
  final String shortDescriptionRu;
  final String shortDescriptionEn;
  final String descriptionRu;
  final String descriptionEn;
  final String mainImageUrl;
  final List<String> imageUrls;
  final TourDifficulty difficulty;
  final int durationDays;
  final int durationNights;
  final double price;
  final String currency;
  final double rating;
  final int reviewsCount;
  final String region;
  final String startPointRu;
  final String startPointEn;
  final List<TourLocation> locations;
  final List<TourProgramDay> programDays;
  final List<TourAccommodation> accommodations;
  final List<TourFeature> inclusions;
  final List<TourFeature> exclusions;
  final String includesText;
  final String excludesText;
  final List<String> seasons;
  final List<String> languages;
  final int minGroupSize;
  final int maxGroupSize;
  final List<TourDeparture> departures;
  final String videoUrl;
  final String mapEmbed;

  String get title => titleRu.isNotEmpty ? titleRu : titleEn;
  String get shortDescription =>
      shortDescriptionRu.isNotEmpty ? shortDescriptionRu : shortDescriptionEn;
  String get description {
    if (descriptionRu.isNotEmpty) return descriptionRu;
    if (descriptionEn.isNotEmpty) return descriptionEn;
    return shortDescription;
  }

  String get startPoint =>
      startPointRu.isNotEmpty ? startPointRu : startPointEn;

  String get heroImageUrl {
    if (mainImageUrl.isNotEmpty) return mainImageUrl;
    if (imageUrls.isNotEmpty) return imageUrls.first;
    return '';
  }

  String get displayLocation {
    if (region.isNotEmpty) return region;
    if (startPoint.isNotEmpty) return startPoint;
    return '—';
  }

  Tour copyWith({List<TourDeparture>? departures}) => Tour(
        id: id,
        titleRu: titleRu,
        titleEn: titleEn,
        shortDescriptionRu: shortDescriptionRu,
        shortDescriptionEn: shortDescriptionEn,
        descriptionRu: descriptionRu,
        descriptionEn: descriptionEn,
        mainImageUrl: mainImageUrl,
        imageUrls: imageUrls,
        difficulty: difficulty,
        durationDays: durationDays,
        durationNights: durationNights,
        price: price,
        currency: currency,
        rating: rating,
        reviewsCount: reviewsCount,
        region: region,
        startPointRu: startPointRu,
        startPointEn: startPointEn,
        locations: locations,
        programDays: programDays,
        accommodations: accommodations,
        inclusions: inclusions,
        exclusions: exclusions,
        includesText: includesText,
        excludesText: excludesText,
        seasons: seasons,
        languages: languages,
        minGroupSize: minGroupSize,
        maxGroupSize: maxGroupSize,
        departures: departures ?? this.departures,
        videoUrl: videoUrl,
        mapEmbed: mapEmbed,
      );

  @override
  List<Object?> get props => [
        id,
        titleRu,
        titleEn,
        descriptionRu,
        mainImageUrl,
        imageUrls,
        difficulty,
        durationDays,
        price,
        currency,
        rating,
        region,
        departures,
      ];
}

class TourLocation extends Equatable {
  const TourLocation({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.dayNumber,
    required this.orderIndex,
  });

  final int id;
  final String nameRu;
  final String nameEn;
  final String descriptionRu;
  final String descriptionEn;
  final String address;
  final double latitude;
  final double longitude;
  final int dayNumber;
  final int orderIndex;

  String get name => nameRu.isNotEmpty ? nameRu : nameEn;
  String get description =>
      descriptionRu.isNotEmpty ? descriptionRu : descriptionEn;

  @override
  List<Object?> get props => [id, name, latitude, longitude, dayNumber];
}

class TourProgramDay extends Equatable {
  const TourProgramDay({
    required this.id,
    required this.dayNumber,
    required this.titleRu,
    required this.titleEn,
    required this.bodyRu,
    required this.bodyEn,
    required this.imageUrl,
  });

  final int id;
  final int dayNumber;
  final String titleRu;
  final String titleEn;
  final String bodyRu;
  final String bodyEn;
  final String imageUrl;

  String get title => titleRu.isNotEmpty ? titleRu : titleEn;
  String get body => bodyRu.isNotEmpty ? bodyRu : bodyEn;

  @override
  List<Object?> get props => [id, dayNumber, title, body, imageUrl];
}

class TourAccommodation extends Equatable {
  const TourAccommodation({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.locationRu,
    required this.locationEn,
    required this.imageUrl,
    required this.nights,
    required this.orderIndex,
  });

  final int id;
  final String nameRu;
  final String nameEn;
  final String locationRu;
  final String locationEn;
  final String imageUrl;
  final int nights;
  final int orderIndex;

  String get name => nameRu.isNotEmpty ? nameRu : nameEn;
  String get location => locationRu.isNotEmpty ? locationRu : locationEn;

  @override
  List<Object?> get props => [id, name, location, nights];
}

class TourFeature extends Equatable {
  const TourFeature({
    required this.id,
    required this.titleRu,
    required this.titleEn,
    required this.orderIndex,
  });

  final int id;
  final String titleRu;
  final String titleEn;
  final int orderIndex;

  String get title => titleRu.isNotEmpty ? titleRu : titleEn;

  @override
  List<Object?> get props => [id, title];
}

enum DepartureStatus { open, full, cancelled, completed, unknown }

class TourDeparture extends Equatable {
  const TourDeparture({
    required this.id,
    required this.tourId,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.currency,
    required this.seatsTotal,
    required this.seatsTaken,
    required this.status,
    required this.notes,
  });

  final int id;
  final int tourId;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String currency;
  final int seatsTotal;
  final int seatsTaken;
  final DepartureStatus status;
  final String notes;

  int get seatsLeft => (seatsTotal - seatsTaken).clamp(0, seatsTotal);
  bool get isOpen =>
      status == DepartureStatus.open && seatsLeft > 0;

  @override
  List<Object?> get props =>
      [id, tourId, startDate, endDate, price, status, seatsTaken, seatsTotal];
}
