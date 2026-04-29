import '../domain/entities/subscription_plan.dart';

/// Static, in-memory catalogue of plans used by the subscription page until
/// the backend exposes its own endpoints.
class SubscriptionPlans {
  const SubscriptionPlans._();

  static const List<SubscriptionPlan> all = [
    SubscriptionPlan(
      tier: SubscriptionTier.free,
      title: 'Кочевник',
      tagline: 'Базовый доступ',
      priceMonth: 0,
      currency: '₽',
      features: [
        'Карта и зоны Кыргызстана',
        '3 диалога с Жел Айдаром в день',
        'Бронирование туров',
      ],
      isPopular: false,
    ),
    SubscriptionPlan(
      tier: SubscriptionTier.pro,
      title: 'Путник',
      tagline: 'Для активных путешественников',
      priceMonth: 299,
      currency: '₽',
      features: [
        'Безлимитный чат с Жел Айдаром',
        'Голосовое общение и озвучка',
        'Эксклюзивные челленджи',
        'Скидка 5% на туры',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      tier: SubscriptionTier.premium,
      title: 'Хан',
      tagline: 'Максимум приключений',
      priceMonth: 599,
      currency: '₽',
      features: [
        'Всё из тарифа «Путник»',
        'Персональный гид-ИИ',
        'Ранний доступ к новым турам',
        'Кэшбек 10% на туры',
        'Поддержка 24/7',
      ],
      isPopular: false,
    ),
  ];
}
