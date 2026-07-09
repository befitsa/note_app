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

// ===========================================================================
// HOME VIEW
// ===========================================================================
//
// This file only draws the screen. It does NOT decide what data to show,
// how notes are sorted, or how saving/deleting actually works — all of
// that logic lives in "home_viewmodel.dart" (the ViewModel).
//
// Think of it like this:
//   - The ViewModel is the "brain": it holds the data and the rules.
//   - The View (this file) is the "face": it just displays whatever the
//     brain currently says, and tells the brain when the user taps
//     something (e.g. "the user tapped this note").
//
// Every time you see `viewModel.something`, that's this View asking the
// ViewModel either "what should I show?" (a getter) or "please do this
// for me" (a method call like `viewModel.openNote(note)`).
//
// The screen has 3 main visual parts, each built by its own method below:
//   1. _buildHeader          -> the purple/blue gradient box at the top
//   2. _buildBody            -> the scrollable list of notes
//   3. _buildBottomNav       -> the floating pill nav bar at the bottom
// There's also _buildMultiSelectBar, which replaces the bottom nav only
// while the user has selected multiple notes at once.
// ===========================================================================
class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  // -------------------------------------------------------------------
  // This `builder` method is called by Stacked every time the ViewModel
  // changes (for example, after a note is added, or the theme changes).
  // It rebuilds the screen using the latest data from `viewModel`.
  // -------------------------------------------------------------------
  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // The background color automatically switches for light/dark mode.
      backgroundColor: context.bgColor,

      // The round "Add Note" button in the bottom-right corner.
      // It's hidden while the user is in multi-select mode, because in
      // that mode we want them focused on choosing notes, not adding one.
      floatingActionButton: _buildAddNoteButton(viewModel),

      // The bottom bar changes depending on whether the user is
      // currently selecting multiple notes or just browsing normally.
      bottomNavigationBar: _buildBottomBar(context, viewModel),

      // The main scrollable content: header on top, notes list below.
      body: SafeArea(
        
        child: RefreshIndicator(
          // Pulling down to refresh just waits briefly — there's no
          // network call to make, since everything is stored locally.
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context, viewModel)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, 100),
                sliver: _buildBody(context, viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tells Stacked how to create the ViewModel for this screen.
  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  // Called once, right after the ViewModel is created. Nothing needed
  // here right now — the notes and theme are already loaded earlier,
  // during the startup/splash screen.
  @override
  void onViewModelReady(HomeViewModel viewModel) {}

  // ===========================================================================
  // SECTION 1: The floating "Add Note" button
  // ===========================================================================

  /// Shows the "Add Note" button — or nothing at all, while the user is
  /// picking multiple notes to archive/delete at once.
  Widget? _buildAddNoteButton(HomeViewModel viewModel) {
    if (viewModel.multiSelectMode) {
      return null; // no button while multi-selecting
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

  // ===========================================================================
  // SECTION 2: Bottom bar (normal nav bar, or multi-select action bar)
  // ===========================================================================

  /// Decides which bottom bar to show: the multi-select action bar (with
  /// Archive/Delete buttons) if the user has notes selected, otherwise
  /// the normal floating navigation pill.
  Widget _buildBottomBar(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.multiSelectMode) {
      return _buildMultiSelectBar(context, viewModel);
    }
    return _buildBottomNav(context, viewModel);
  }

  /// The normal floating pill-shaped navigation bar with 4 tabs:
  /// Home, Favorites, Archive, and Settings.
  Widget _buildBottomNav(BuildContext context, HomeViewModel viewModel) {
    // Each tab needs: an outline icon, a filled icon (shown when
    // selected), and a text label. A "record" (the parentheses syntax
    // below) is just a lightweight way to group these 3 things together
    // without creating a whole new class for it.
    final tabs = <(IconData outlineIcon, IconData filledIcon, String label)>[
      (Icons.home_outlined, Icons.home_rounded, 'Home'),
      (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorites'),
      (Icons.archive_outlined, Icons.archive_rounded, 'Archive'),
      (Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
    ];

    return SafeArea(
      // `top: false` means: don't add extra space at the top of the
      // screen — we only care about the safe area at the bottom here.
      top: false,
      child: Padding(
        // This padding is what makes the bar "float" with a visible gap
        // from the screen edges, instead of touching them directly.
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(28), // rounded pill shape
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
            // Build one tab button for each entry in the `tabs` list above.
            children: List.generate(tabs.length, (index) {
              return _buildNavTab(context, viewModel, tabs[index], index);
            }),
          ),
        ),
      ),
    );
  }

  /// Builds a single tab (icon + label) inside the bottom nav bar, and
  /// highlights it if it's the currently-selected tab.
  Widget _buildNavTab(
    BuildContext context,
    HomeViewModel viewModel,
    (IconData outlineIcon, IconData filledIcon, String label) tab,
    int index,
  ) {
    final isSelected = index == viewModel.bottomNavIndex;
    final icon = isSelected ? tab.$2 : tab.$1; // filled icon if selected
    final color = isSelected ? AppColors.primary : context.textSecondary;

    return GestureDetector(
      onTap: () => viewModel.setBottomNavIndex(index),
      behavior: HitTestBehavior.opaque, // makes the whole area tappable
      child: AnimatedContainer(
        // "Animated" means it smoothly fades between selected/unselected
        // instead of snapping instantly.
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
              tab.$3, // the label text
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

  /// The bar shown instead of the normal nav bar while the user has one
  /// or more notes selected (long-press to enter this mode). Lets them
  /// cancel, archive the selection, or delete it permanently.
  Widget _buildMultiSelectBar(BuildContext context, HomeViewModel viewModel) {
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
            // "X" button — tapping it cancels multi-select mode entirely.
            IconButton(
              icon: Icon(Icons.close_rounded, color: context.textPrimary),
              onPressed: viewModel.cancelMultiSelect,
            ),
            // Shows how many notes are currently selected, e.g. "3 selected".
            Flexible(
              child: Text(
                '${viewModel.selectedIds.length} selected',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.textPrimary),
              ),
            ),
            const Spacer(), // pushes the next two buttons to the right
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

  // ===========================================================================
  // SECTION 3: Header (greeting, dashboard shortcut, search bar)
  // ===========================================================================

  /// The gradient box at the top of the screen: greeting text, app name,
  /// a shortcut button to the Dashboard, and a tappable search bar.
  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Different gradient colors for light vs dark mode.
          colors: context.isDark
              ? AppColors.gradientHeaderDark
              : AppColors.gradientHeaderLight,
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
              // Left side: "Good morning" + "NotesHub"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    greetingForNow(), // e.g. "Good morning"
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              // Right side: small button that opens the Dashboard screen.
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

  /// This LOOKS like a search box, but you can't type in it here — tapping
  /// it just opens the real Search screen, where typing actually works.
  /// It's kept simple on purpose since it never needs to hold any text.
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
              AppStrings.searchHint, // e.g. "Search your notes..."
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 4: Body — the scrollable list of notes (or an empty-state message)
  // ===========================================================================

  /// Decides what to show below the header:
  ///   - If there are no notes at all -> a friendly "add your first note" message
  ///   - If a filter/search has no matches -> a "no results" message
  ///   - Otherwise -> the actual list of notes (pinned notes first, if any)
  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    // Case 1: the user has never created any note yet.
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

    // `visibleNotes` already accounts for the current search text and
    // whichever filter tab (All / Favorites / Archived) is selected.
    final notes = viewModel.visibleNotes;

    // Case 2: there ARE notes, but none match the current filter/search.
    if (notes.isEmpty) {
      final emptyMessages = _emptyTextsFor(viewModel.filter);
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(
          context,
          icon: Icons.search_off_rounded,
          title: emptyMessages.$1,   // title text
          subtitle: emptyMessages.$2, // subtitle text
        ),
      );
    }

    // Case 3: show the real list.
    final showPinnedSection =
        viewModel.filter == HomeFilter.all && viewModel.pinnedNotes.isNotEmpty;

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: AppSpacing.md),

        // Only show a separate "Pinned" section while browsing "All Notes".
        if (showPinnedSection) ...[
          _buildSectionHeader(context, 'Pinned'),
          const SizedBox(height: AppSpacing.xs),
          ...viewModel.pinnedNotes.map(
            (note) => _buildNoteCard(context, viewModel, note),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // The main list, titled "All Notes" / "Favorites" / "Archived"
        // depending on which tab is selected.
        _buildSectionHeader(context, _titleFor(viewModel.filter)),
        const SizedBox(height: AppSpacing.xs),
        ...notes.map((note) => _buildNoteCard(context, viewModel, note)),
      ]),
    );
  }

  /// Builds one note card, wiring up all of its buttons/gestures to the
  /// right ViewModel action. The behavior changes slightly when we're
  /// looking at the Archive tab:
  ///   - Tapping/swiping an archived note opens a Restore/Delete choice
  ///     instead of doing anything immediately.
  Widget _buildNoteCard(BuildContext context, HomeViewModel viewModel, NoteModel note) {
    final isArchivedTab = viewModel.filter == HomeFilter.archived;

    // What happens when the user taps the note.
    void handleTap() {
      if (isArchivedTab) {
        _showArchivedNoteActions(context, viewModel, note);
      } else {
        viewModel.openNote(note);
      }
    }

    // What happens when the user swipes the note (the "archive" gesture).
    void handleSwipe() {
      if (isArchivedTab) {
        _showArchivedNoteActions(context, viewModel, note);
      } else {
        viewModel.archiveNote(note);
      }
    }

    // What happens when the user taps to select the note (multi-select).
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

  /// Shows a small pop-up sheet from the bottom of the screen with two
  /// clear choices for an archived note: "Restore" or "Delete permanently".
  /// This is on purpose — we never want a single tap to silently restore
  /// or destroy a note by accident.
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
                // Little grey "handle" bar, just a visual hint that this
                // sheet can be dragged/dismissed.
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
                // Shows which note this sheet is about.
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
                // Option 1: put the note back where it was.
                ListTile(
                  leading: const Icon(Icons.unarchive_rounded, color: AppColors.primary),
                  title: const Text('Restore note'),
                  onTap: () {
                    Navigator.of(sheetContext).pop(); // close the sheet first
                    viewModel.restoreNote(note);
                  },
                ),
                // Option 2: delete it for good (this will ask for one more
                // confirmation, handled inside the ViewModel).
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

  // ===========================================================================
  // SECTION 5: Small reusable pieces (section titles, empty-state message)
  // ===========================================================================

  /// A simple bold title above a group of notes, e.g. "Pinned" or "All Notes".
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.headline.copyWith(color: context.textPrimary),
    );
  }

  /// A friendly "nothing to see here" message with an icon, title, and
  /// subtitle — used both for "no notes yet" and "no search results".
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

  // ===========================================================================
  // SECTION 6: Small helper functions (just pick the right text to show)
  // ===========================================================================

  /// Turns the current filter into the section title shown above the list.
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

  /// Picks the right "title + subtitle" pair to show when a filter/search
  /// has no matching notes. Returns both pieces of text together as a
  /// simple 2-value pair (title first, subtitle second).
  (String, String) _emptyTextsFor(HomeFilter filter) {
    switch (filter) {
      case HomeFilter.favorites:
        return (AppStrings.emptyFavoritesTitle, AppStrings.emptyFavoritesSubtitle);
      case HomeFilter.archived:
        return (AppStrings.emptyArchiveTitle, AppStrings.emptyArchiveSubtitle);
      case HomeFilter.pinned:
        return (AppStrings.emptyPinnedTitle, AppStrings.emptyPinnedSubtitle);
      case HomeFilter.all:
        return (AppStrings.emptySearchTitle, AppStrings.emptySearchSubtitle);
    }
  }
}