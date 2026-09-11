import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/badge.dart';
import 'package:hafiz/core/widgets/card.dart';
import 'package:hafiz/core/widgets/empty_state.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/quran/domain/entities/memorization_plan.dart';
import 'package:hafiz/features/quran/domain/repositories/curriculum_provider.dart';

class MemorizationPlanView extends ConsumerWidget {
  const MemorizationPlanView({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(studentPlansProvider(studentId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.memorizationPlans),
      ),
      body: plansAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (plans) {
          if (plans.isEmpty) {
            return AppEmptyState(
              icon: Icons.menu_book_outlined,
              title: context.l.noPlans,
              description: context.l.noPlansMessage,
              primaryActionLabel: context.l.createPlan,
              onPrimaryAction: () {
                // TODO: Navigate to create plan
              },
            );
          }
          return _buildPlanList(plans);
        },
      ),
    );
  }

  Widget _buildPlanList(List<MemorizationPlan> plans) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _PlanCard(plan: plan);
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final MemorizationPlan plan;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${plan.currentSurah} - ${plan.targetSurah}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressIndicator(context),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPriorityBadge(context),
              const Spacer(),
              Text(
                '${plan.sessions.length} ${context.l.sessions}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = switch (plan.status) {
      MemorizationStatus.notStarted => Colors.grey,
      MemorizationStatus.inProgress => Colors.blue,
      MemorizationStatus.paused => Colors.orange,
      MemorizationStatus.completed => Colors.green,
      MemorizationStatus.cancelled => Colors.red,
    };

    return AppBadge(
      label: plan.status.displayNameAr,
      color: color,
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final color = switch (plan.priority) {
      MemorizationPriority.low => Colors.green,
      MemorizationPriority.medium => Colors.orange,
      MemorizationPriority.high => Colors.red,
    };

    return AppBadge(
      label: plan.priority.displayNameAr,
      color: color,
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final totalAyahs = plan.targetAyah - plan.currentAyah;
    final completedAyahs = plan.checkpoints
        .where((c) => c.status == CheckpointStatus.completed)
        .fold(0, (sum, c) => sum + (c.endAyah - c.startAyah + 1));
    final progress = totalAyahs > 0 ? completedAyahs / totalAyahs : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.l.surah} ${plan.currentSurah}:${plan.currentAyah}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${context.l.surah} ${plan.targetSurah}:${plan.targetAyah}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
