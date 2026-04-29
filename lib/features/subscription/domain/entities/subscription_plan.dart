import 'package:equatable/equatable.dart';

enum SubscriptionTier { free, pro, premium }

class SubscriptionPlan extends Equatable {
  const SubscriptionPlan({
    required this.tier,
    required this.title,
    required this.tagline,
    required this.priceMonth,
    required this.currency,
    required this.features,
    required this.isPopular,
  });

  final SubscriptionTier tier;
  final String title;
  final String tagline;
  final int priceMonth; // 0 for free
  final String currency;
  final List<String> features;
  final bool isPopular;

  bool get isFree => tier == SubscriptionTier.free;

  @override
  List<Object?> get props =>
      [tier, title, tagline, priceMonth, currency, features, isPopular];
}
