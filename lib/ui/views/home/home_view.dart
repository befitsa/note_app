import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:note_app_2/ui/common/app_colors.dart';
import 'package:note_app_2/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return const Scaffold(
      
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
