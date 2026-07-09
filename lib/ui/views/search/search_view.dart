import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_spacing.dart';
import '../../../shared/enums/note_enums.dart';
import '../../common/app_text_styles.dart';
import '../../components/custom_app_bar.dart';
import '../../components/empty_state.dart';
import '../../components/note_card.dart';
import '../../components/search_bar.dart';
import '../../common/ui_helpers.dart';
import 'search_viewmodel.dart';

/// Dedicated live-search screen with scope filters
/// (all / pinned / archived).
class SearchView extends StackedView<SearchViewModel> {
  const SearchView({super.key});

  @override
  Widget builder(BuildContext context, SearchViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: const CustomAppBar(title: 'Search'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              AppSearchBar(
                controller: TextEditingController(text: viewModel.query),
                onChanged: viewModel.onQueryChanged,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _ScopeChip(
                    label: 'All',
                    selected: viewModel.scope == HomeFilter.all,
                    onTap: () => viewModel.setScope(HomeFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _ScopeChip(
                    label: 'Pinned',
                    selected: viewModel.scope == HomeFilter.pinned,
                    onTap: () => viewModel.setScope(HomeFilter.pinned),
                  ),
                  const SizedBox(width: 8),
                  _ScopeChip(
                    label: 'Archived',
                    selected: viewModel.scope == HomeFilter.archived,
                    onTap: () => viewModel.setScope(HomeFilter.archived),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: viewModel.query.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_rounded,
                        title: 'Search your notes',
                        subtitle: 'Start typing to find notes by title or content',
                      )
                    : viewModel.results.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No results found',
                            subtitle: 'Try a different keyword',
                          )
                        : ListView(
                            children: viewModel.results
                                .map((n) => NoteCard(
                                      note: n,
                                      onTap: () => viewModel.openNote(n),
                                      onArchive: () {},
                                      onToggleFavorite: () {},
                                      onTogglePin: () {},
                                    ))
                                .toList(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();
}

class _ScopeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ScopeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : context.surfaceColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyStrong.copyWith(
            color: selected ? Colors.white : context.textSecondary,
          ),
        ),
      ),
    );
  }
}
