import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/app_strings.dart';
import 'startup_viewmodel.dart';

/// Splash screen: shows the app logo + a loading animation while
/// StartupViewModel restores persisted data, then routes to Home.
class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientStartup,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.sticky_note_2_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your thoughts, organized beautifully',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initialise();
    });
  }
}