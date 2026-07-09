import 'package:flutter/material.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

/// Simple reusable app bar used for inner screens (Add/Edit Note,
/// Settings, Search) that need a back button + title + optional actions.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.bgColor,
      elevation: 0,
      leading: leading ??
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: context.textPrimary, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
      title: Text(
        title,
        style: AppTextStyles.title.copyWith(color: context.textPrimary),
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
