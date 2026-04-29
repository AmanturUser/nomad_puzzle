import 'package:injectable/injectable.dart';

import '../models/challenge_model.dart';
import 'challenges_remote_datasource.dart';

@LazySingleton(as: ChallengesRemoteDataSource, env: ['dev'])
class ChallengesFakeDataSource implements ChallengesRemoteDataSource {
  static final _store = <String, ChallengeModel>{
    '1': _build(
      id: 1,
      titleRu: 'Тренировка беркута с беркутчи',
      descRu:
          'Понаблюдай тренировку беркута с настоящим кыргызским охотником-беркутчи в селе Боконбаев. Древняя традиция, передающаяся из поколения в поколение.',
      imageUrl: 'asset:assets/images/challenges/berkut.PNG',
      level: 'traveler',
      difficulty: 1,
      reward: 200,
      days: 1,
      locName: 'с. Боконбаев, Иссык-Куль',
      lat: 42.1383,
      lng: 77.0833,
    ),
    '2': _build(
      id: 2,
      titleRu: 'Трек в Каравшин — Азиатская Патагония',
      descRu:
          'Многодневный поход в Каравшинское ущелье — кыргызскую Патагонию с её отвесными гранитными стенами. Только для подготовленных.',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200',
      level: 'hero',
      difficulty: 5,
      reward: 500,
      days: 3,
      locName: 'Каравшин, Баткен',
      lat: 39.7300,
      lng: 70.4900,
    ),
    '3': _build(
      id: 3,
      titleRu: 'Создать шырдак с кыргызскими женщинами',
      descRu:
          'Войлочный мастер-класс — вместе с местными мастерицами создай свой шырдак, традиционный войлочный ковёр Ат-Башинской области.',
      imageUrl: 'asset:assets/images/challenges/gilem.PNG',
      level: 'traveler',
      difficulty: 3,
      reward: 250,
      days: 1,
      locName: 'Ат-Башы, Нарын',
      lat: 41.1700,
      lng: 75.8000,
    ),
    '4': _build(
      id: 4,
      titleRu: 'Плов из Озгонского риса',
      descRu:
          'Приготовь настоящий ошский плов вместе с местной семьёй. Озгонский рис «дев-зира» — гордость региона.',
      imageUrl: 'asset:assets/images/challenges/plov.PNG',
      level: 'traveler',
      difficulty: 1,
      reward: 180,
      days: 1,
      locName: 'Ошская область',
      lat: 40.7700,
      lng: 73.3000,
    ),
    '5': _build(
      id: 5,
      titleRu: 'Сбор урожая в ореховых лесах Арсланбап',
      descRu:
          'Самые большие реликтовые ореховые леса в мире. В сезон сбора грецкого ореха присоединись к местным.',
      imageUrl: 'asset:assets/images/challenges/arslanbap.PNG',
      level: 'traveler',
      difficulty: 3,
      reward: 220,
      days: 1,
      locName: 'Арсланбап, Жалал-Абад',
      lat: 41.3500,
      lng: 72.9500,
    ),
    '6': _build(
      id: 6,
      titleRu: 'Ночёвка у озера Беш-Таш',
      descRu:
          'Палатка, костёр, тишина горного озера. Ночь под звёздами в Таласском национальном парке.',
      imageUrl:
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=1200',
      level: 'traveler',
      difficulty: 3,
      reward: 230,
      days: 1,
      locName: 'Беш-Таш, Талас',
      lat: 42.3500,
      lng: 72.0833,
    ),
    '7': _build(
      id: 7,
      titleRu: 'Селфи с пиком Ленина (Жел-Айдар)',
      descRu:
          'Перевал Путешественников 4150 м с видом на семитысячник Жел-Айдар. Один из самых эпичных кадров твоей жизни.',
      imageUrl: 'asset:assets/images/challenges/mountain.PNG',
      level: 'hero',
      difficulty: 5,
      reward: 450,
      days: 2,
      locName: 'Алай, Ош',
      lat: 39.6800,
      lng: 73.0000,
    ),
    '8': _build(
      id: 8,
      titleRu: 'Музей ИЗО и истории Кыргызстана',
      descRu:
          'Главный музей Бишкека: от наскальных рисунков и эпоса «Манас» до современного искусства Центральной Азии.',
      imageUrl:
          'https://images.unsplash.com/photo-1565060169187-5284a3a36a02?w=1200',
      level: 'traveler',
      difficulty: 1,
      reward: 100,
      days: 1,
      locName: 'Бишкек',
      lat: 42.8746,
      lng: 74.5698,
    ),
    '9': _build(
      id: 9,
      titleRu: 'Конная прогулка в Чон-Кемине',
      descRu:
          'Прокатись на лошади и поднимись на панораму национального парка Чон-Кемин — одно из самых живописных ущелий Чуйской области.',
      imageUrl:
          'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=1200',
      level: 'traveler',
      difficulty: 3,
      reward: 200,
      days: 1,
      locName: 'Чон-Кемин, Чуйская область',
      lat: 42.7833,
      lng: 76.0500,
    ),
    '10': _build(
      id: 10,
      titleRu: 'Звёздное небо Сон-Куля из юрты',
      descRu:
          'Останься в юрточном лагере на 3000 м и наблюдай Млечный Путь над высокогорным озером. Без светового загрязнения.',
      imageUrl: 'asset:assets/images/challenges/sonkol.PNG',
      level: 'traveler',
      difficulty: 3,
      reward: 280,
      days: 1,
      locName: 'оз. Сон-Куль, Нарын',
      lat: 41.8333,
      lng: 75.1167,
    ),
    '11': _build(
      id: 11,
      titleRu: 'Рыбалка на радужную форель в Токтогуле',
      descRu:
          'Поймай речную радужную форель в Токтогульском водохранилище. Снасть, тишина, и абсолютно спокойный вечер.',
      imageUrl: 'asset:assets/images/challenges/toktogul.PNG',
      level: 'traveler',
      difficulty: 1,
      reward: 160,
      days: 1,
      locName: 'Токтогул, Жалал-Абад',
      lat: 41.8758,
      lng: 72.9442,
    ),
  };

  static ChallengeModel _build({
    required int id,
    required String titleRu,
    required String descRu,
    required String imageUrl,
    required String level,
    required int difficulty,
    required int reward,
    required int days,
    required String locName,
    required double lat,
    required double lng,
  }) {
    return ChallengeModel(
      id: id,
      titleRu: titleRu,
      titleEn: titleRu,
      shortDescriptionRu: descRu,
      shortDescriptionEn: descRu,
      descriptionRu: descRu,
      descriptionEn: descRu,
      mainImageUrl: imageUrl,
      level: level,
      difficulty: difficulty,
      rewardPoints: reward,
      estimatedDays: days,
      estimatedCost: 0,
      currency: 'USD',
      status: 'published',
      locations: [
        ChallengeLocationModel(
          id: id,
          challengeId: id,
          nameRu: locName,
          nameEn: locName,
          latitude: lat,
          longitude: lng,
        ),
      ],
    );
  }

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _store.values.toList();
  }

  @override
  Future<ChallengeModel> getChallenge(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _store[id] ?? _store.values.first;
  }

  @override
  Future<void> completeChallenge(
    String id,
    List<String> photoPaths,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    // Fake mode doesn't actually mutate — visit status stays available, since
    // we now infer "completed" from real submissions on prod. For dev demo,
    // the MapBloc still flips local state to completed via the bloc layer.
  }
}
