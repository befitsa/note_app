import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../components/custom_app_bar.dart';
import '../../components/dashboard_card.dart';
import '../../components/section_header.dart';
import '../../components/statistics_tile.dart';
import '../../common/ui_helpers.dart';
import 'dashboard_viewmodel.dart';

/// Full-screen dashboard with animated statistic cards and a storage
/// breakdown, reached from the chart icon on Home.
class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
      BuildContext context, DashboardViewModel viewModel, Widget? child) {
    final stats = viewModel.statistics;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CustomAppBar(title: 'Dashboard'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.05,
            children: [
              DashboardCard(
                label: 'Total Notes',
                value: stats.totalNotes,
                icon: Icons.description_rounded,
                color: AppColors.primary,
              ),
              DashboardCard(
                label: 'Pinned',
                value: stats.pinnedNotes,
                icon: Icons.push_pin_rounded,
                color: AppColors.secondary,
              ),
              DashboardCard(
                label: 'Archived',
                value: stats.archivedNotes,
                icon: Icons.archive_rounded,
                color: AppColors.accent,
              ),
              DashboardCard(
                label: 'Favorites',
                value: stats.favoriteNotes,
                icon: Icons.favorite_rounded,
                color: AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Storage Statistics'),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                StatisticsTile(
                  label: 'Estimated storage used',
                  value: stats.storageLabel,
                  icon: Icons.sd_storage_rounded,
                ),
                StatisticsTile(
                  label: 'Total characters',
                  value: '${stats.totalCharacters}',
                  icon: Icons.text_fields_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}