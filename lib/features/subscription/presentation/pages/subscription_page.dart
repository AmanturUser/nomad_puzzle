import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/subscription_plans.dart';
import '../../domain/entities/subscription_plan.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // For now there's no backend, so we just store the local "active" plan.
  SubscriptionTier _currentTier = SubscriptionTier.free;
  SubscriptionTier _selectedTier = SubscriptionTier.pro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(currentTier: _currentTier)),
          SliverList.list(
            children: [
              const _SectionTitle('Выбери тариф'),
              const SizedBox(height: 12),
              for (var i = 0; i < SubscriptionPlans.all.length; i++)
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _PlanCard(
                    plan: SubscriptionPlans.all[i],
                    selected: _selectedTier == SubscriptionPlans.all[i].tier,
                    isCurrent:
                        _currentTier == SubscriptionPlans.all[i].tier,
                    onTap: () => setState(() {
                      _selectedTier = SubscriptionPlans.all[i].tier;
                      HapticFeedback.selectionClick();
                    }),
                  ).animate().fadeIn(
                        delay: (80 * i).ms,
                        duration: 320.ms,
                      ).slideY(
                        begin: 0.15,
                        end: 0,
                        delay: (80 * i).ms,
                        duration: 320.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              const SizedBox(height: 16),
              _SubscribeButton(
                currentTier: _currentTier,
                selectedTier: _selectedTier,
                onSubscribe: _subscribe,
              ),
              const SizedBox(height: 24),
              const _LegalNote(),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  void _subscribe() {
    if (_selectedTier == _currentTier) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_selectedTier == SubscriptionTier.free
            ? 'Тариф «Кочевник» активирован'
            : 'Оплата скоро появится — пока активирован пробный режим ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() => _currentTier = _selectedTier);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.currentTier});
  final SubscriptionTier currentTier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        MediaQuery.paddingOf(context).top + 8,
        20,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go('/profile'),
              ),
              Expanded(
                child: Text(
                  'Подписка',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              'Открой больше возможностей и поддержи проект',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _CurrentTierPill(tier: currentTier),
          ),
        ],
      ),
    );
  }
}

class _CurrentTierPill extends StatelessWidget {
  const _CurrentTierPill({required this.tier});
  final SubscriptionTier tier;

  @override
  Widget build(BuildContext context) {
    final plan = SubscriptionPlans.all.firstWhere((p) => p.tier == tier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: plan.isFree
            ? AppColors.surfaceDim
            : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: plan.isFree
              ? Theme.of(context).dividerColor
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            plan.isFree
                ? Icons.workspace_premium_outlined
                : Icons.workspace_premium_rounded,
            size: 16,
            color: plan.isFree
                ? AppColors.textSecondary
                : AppColors.primaryDeep,
          ),
          const SizedBox(width: 6),
          Text(
            'Текущий тариф · ${plan.title}',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: plan.isFree
                  ? AppColors.textSecondary
                  : AppColors.primaryDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.isCurrent,
    required this.onTap,
  });

  final SubscriptionPlan plan;
  final bool selected;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = plan.isFree ? AppColors.textSecondary : AppColors.primary;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Theme.of(context).dividerColor,
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (selected ? AppColors.primary : Colors.black)
                    .withValues(alpha: selected ? 0.18 : 0.05),
                blurRadius: selected ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: plan.isFree
                          ? AppColors.surfaceDim
                          : AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      plan.isFree
                          ? Icons.terrain_rounded
                          : (plan.tier == SubscriptionTier.pro
                              ? Icons.flight_takeoff_rounded
                              : Icons.workspace_premium_rounded),
                      color: accent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (plan.isPopular) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                            if (isCurrent) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'АКТИВЕН',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          plan.tagline,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (plan.priceMonth == 0)
                    const Text(
                      'Бесплатно',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${plan.priceMonth}${plan.currency}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDeep,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          'в месяц',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 14),
              for (final f in plan.features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton({
    required this.currentTier,
    required this.selectedTier,
    required this.onSubscribe,
  });

  final SubscriptionTier currentTier;
  final SubscriptionTier selectedTier;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    final selectedPlan =
        SubscriptionPlans.all.firstWhere((p) => p.tier == selectedTier);
    final isCurrent = currentTier == selectedTier;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isCurrent ? null : AppColors.primaryGradient,
          color: isCurrent ? AppColors.surfaceDim : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isCurrent
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size.fromHeight(58),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          onPressed: isCurrent ? null : onSubscribe,
          icon: Icon(
            isCurrent
                ? Icons.check_circle_rounded
                : (selectedPlan.isFree
                    ? Icons.refresh_rounded
                    : Icons.flash_on_rounded),
            color: isCurrent ? AppColors.textSecondary : Colors.white,
          ),
          label: Text(
            isCurrent
                ? 'Этот тариф уже активен'
                : (selectedPlan.isFree
                    ? 'Перейти на «Кочевник»'
                    : 'Подключить «${selectedPlan.title}» — ${selectedPlan.priceMonth}${selectedPlan.currency}/мес'),
            style: TextStyle(
              color: isCurrent ? AppColors.textSecondary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalNote extends StatelessWidget {
  const _LegalNote();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Подписка пока работает в демо-режиме — оплата появится после '
        'подключения платёжной системы. Можно отменить в любой момент.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
      ),
    );
  }
}
