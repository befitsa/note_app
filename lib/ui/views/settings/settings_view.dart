import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../../shared/enums/note_enums.dart';
import '../../common/app_text_styles.dart';
import '../../components/custom_app_bar.dart';
import '../../components/section_header.dart';
import '../../components/statistics_tile.dart';
import '../../components/theme_switcher.dart';
import '../../common/ui_helpers.dart';
import 'settings_viewmodel.dart';

/// Theme, layout, sort preferences and app "About" info.
class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
      BuildContext context, SettingsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionHeader(title: 'Appearance'),
          const SizedBox(height: AppSpacing.sm),
          ThemeSwitcher(
            currentMode: viewModel.themeMode,
            onChanged: viewModel.setThemeMode,
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsCard(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grid layout',
                      style: AppTextStyles.body.copyWith(color: context.textPrimary)),
                  Switch(
                    value: viewModel.isGridView,
                    activeColor: AppColors.primary,
                    onChanged: viewModel.setGridView,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Sort Notes By'),
          const SizedBox(height: AppSpacing.sm),
          _SettingsCard(
            children: SortOption.values
                .map((option) => RadioListTile<SortOption>(
                      value: option,
                      groupValue: viewModel.sortOption,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text(option.label,
                          style: TextStyle(color: context.textPrimary)),
                      onChanged: (value) {
                        if (value != null) viewModel.setSortOption(value);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'About'),
          const SizedBox(height: AppSpacing.sm),
          _SettingsCard(
            children: [
              StatisticsTile(label: 'App version', value: viewModel.appVersion),
              StatisticsTile(label: 'Developer', value: viewModel.developer),
              StatisticsTile(label: 'Total notes', value: '${viewModel.totalNotes}'),
              StatisticsTile(label: 'Storage used', value: viewModel.storageLabel),
            ],
          ),
        ],
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) => SettingsViewModel();
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}
