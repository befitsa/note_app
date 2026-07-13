import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../common/app_strings.dart';
import '../../common/app_text_styles.dart';
import '../../../models/note_model.dart';
import '../../../shared/enums/note_enums.dart';
import '../../common/ui_helpers.dart';
import '../../components/note_card.dart';
import 'home_viewmodel.dart';

// A small helper class describing one bottom-nav tab.
class _NavTabInfo {
  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;

  const _NavTabInfo(this.outlineIcon, this.filledIcon, this.label);
}

const List<_NavTabInfo> _navTabs = [
  _NavTabInfo(Icons.home_outlined, Icons.home_rounded, 'Home'),
  _NavTabInfo(Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorites'),
  _NavTabInfo(Icons.archive_outlined, Icons.archive_rounded, 'Archive'),
  _NavTabInfo(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
];

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.bgColor,
      floatingActionButton: _buildAddNoteButton(viewModel),
      bottomNavigationBar: _buildBottomBar(context, viewModel),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context, viewModel)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 100),
                sliver: _buildBody(context, viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
  }

  Widget? _buildAddNoteButton(HomeViewModel viewModel) {
    if (viewModel.multiSelectMode) {
      return null; // hidden while multi-selecting
    }
    return FloatingActionButton.extended(
      onPressed: viewModel.openAddNote,
      backgroundColor: AppColors.primary,
      label: const Text(
        'Add Note',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.multiSelectMode) {
      return _buildMultiSelectBar(context, viewModel);
    }
    return _buildBottomNav(context, viewModel);
  }

  Widget _buildBottomNav(BuildContext context, HomeViewModel viewModel) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(context.isDark ? 0.35 : 0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < _navTabs.length; i++)
                _buildNavTab(context, viewModel, _navTabs[i], i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context,
    HomeViewModel viewModel,
    _NavTabInfo tab,
    int index,
  ) {
    final bool isSelected = index == viewModel.bottomNavIndex;
    final IconData icon = isSelected ? tab.filledIcon : tab.outlineIcon;
    final Color color = isSelected ? AppColors.primary : context.textSecondary;

    return GestureDetector(
      onTap: () => viewModel.setBottomNavIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectBar(BuildContext context, HomeViewModel viewModel) {
    final int selectedCount = viewModel.selectedIds.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close_rounded, color: context.textPrimary),
              onPressed: viewModel.cancelMultiSelect,
            ),
            Flexible(
              child: Text(
                '$selectedCount selected',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.textPrimary),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.archive_outlined, color: AppColors.secondary),
              onPressed: viewModel.archiveSelected,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              onPressed: viewModel.deleteSelectedPermanently,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDark ? AppColors.gradientHeaderDark : AppColors.gradientHeaderLight,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    greetingForNow(),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.appNameHome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: viewModel.openDashboard,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSearchBarTrigger(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildSearchBarTrigger(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.openSearch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              AppStrings.searchHint,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (!viewModel.hasAnyNotes) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(
          context,
          icon: Icons.note_add_rounded,
          title: AppStrings.emptyNotesTitle,
          subtitle: AppStrings.emptyNotesSubtitle,
        ),
      );
    }

    final List<NoteModel> notes = viewModel.visibleNotes;

    if (notes.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(
          context,
          icon: Icons.search_off_rounded,
          title: _emptyTitleFor(viewModel.filter),
          subtitle: _emptySubtitleFor(viewModel.filter),
        ),
      );
    }

    final bool showPinnedSection =
        viewModel.filter == HomeFilter.all && viewModel.pinnedNotes.isNotEmpty;

    final List<Widget> children = [const SizedBox(height: AppSpacing.md)];

    if (showPinnedSection) {
      children.add(_buildSectionHeader(context, 'Pinned'));
      children.add(const SizedBox(height: AppSpacing.xs));
      for (final note in viewModel.pinnedNotes) {
        children.add(_buildNoteCard(context, viewModel, note));
      }
      children.add(const SizedBox(height: AppSpacing.md));
    }

    children.add(_buildSectionHeader(context, _titleFor(viewModel.filter)));
    children.add(const SizedBox(height: AppSpacing.xs));
    for (final note in notes) {
      children.add(_buildNoteCard(context, viewModel, note));
    }

    return SliverList(delegate: SliverChildListDelegate(children));
  }

  Widget _buildNoteCard(BuildContext context, HomeViewModel viewModel, NoteModel note) {
    final bool isArchivedTab = viewModel.filter == HomeFilter.archived;

    void handleTap() {
      if (isArchivedTab) {
        _showArchivedNoteActions(context, viewModel, note);
      } else {
        viewModel.openNote(note);
      }
    }

    void handleSwipe() {
      if (isArchivedTab) {
        _showArchivedNoteActions(context, viewModel, note);
      } else {
        viewModel.archiveNote(note);
      }
    }

    void handleSelect(bool _) {
      if (viewModel.multiSelectMode) {
        viewModel.toggleSelection(note.id);
      } else {
        viewModel.enterMultiSelect(note.id);
      }
    }

    return NoteCard(
      note: note,
      selectable: viewModel.multiSelectMode,
      selected: viewModel.selectedIds.contains(note.id),
      onSelectChanged: handleSelect,
      onTap: handleTap,
      onArchive: handleSwipe,
      onToggleFavorite: () => viewModel.toggleFavorite(note.id),
      onTogglePin: () => viewModel.togglePin(note.id),
    );
  }

  void _showArchivedNoteActions(
    BuildContext context,
    HomeViewModel viewModel,
    NoteModel note,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    note.title.isEmpty ? 'Untitled' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(color: context.textPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.unarchive_rounded, color: AppColors.primary),
                  title: const Text('Restore note'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    viewModel.restoreNote(note);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                  title: const Text('Delete permanently'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    viewModel.deletePermanently(note);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.headline.copyWith(color: context.textPrimary),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: context.textSecondary),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.headline.copyWith(color: context.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(color: context.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleFor(HomeFilter filter) {
    switch (filter) {
      case HomeFilter.all:
        return 'All Notes';
      case HomeFilter.favorites:
        return 'Favorites';
      case HomeFilter.archived:
        return 'Archived';
      case HomeFilter.pinned:
        return 'Pinned';
    }
  }

  String _emptyTitleFor(HomeFilter filter) {
    switch (filter) {
      case HomeFilter.favorites:
        return AppStrings.emptyFavoritesTitle;
      case HomeFilter.archived:
        return AppStrings.emptyArchiveTitle;
      case HomeFilter.pinned:
        return AppStrings.emptyPinnedTitle;
      case HomeFilter.all:
        return AppStrings.emptySearchTitle;
    }
  }

  String _emptySubtitleFor(HomeFilter filter) {
    switch (filter) {
      case HomeFilter.favorites:
        return AppStrings.emptyFavoritesSubtitle;
      case HomeFilter.archived:
        return AppStrings.emptyArchiveSubtitle;
      case HomeFilter.pinned:
        return AppStrings.emptyPinnedSubtitle;
      case HomeFilter.all:
        return AppStrings.emptySearchSubtitle;
    }
  }
}