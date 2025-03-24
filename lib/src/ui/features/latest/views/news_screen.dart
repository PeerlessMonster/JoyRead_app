import 'package:flutter/material.dart';

import '../../../core/breakpoint_state.dart';
import '../../../core/shared/sign.dart';
import '../../../widgets/load_state_changed_secondary_scaffold.dart';
import '../view_models/news_screen.dart';
import 'more_news_list.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});

  final _viewModel = NewsScreenViewModel();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) =>
            SliverLoadStateChangedSecondaryScaffoldWithSign(
          dataFuture: _viewModel.firstPageFuture,
          title: '最新资讯',
          uncompletedSign: LoadingSign(),
          bodySliversBuilder: (context, data) => [
            BreakpointProvider(
              child: MoreLatestNewsList(
                firstPage: data,
                loadMorePage: _viewModel.loadMorePage,
                loadImageUrl: _viewModel.loadImageUrl,
                fallbackImage: _viewModel.fallbackImage,
                pageSize: _viewModel.pageSize,
                preloadDataCount: _viewModel.preloadDataCount,
                maxCachedPageCount: _viewModel.maxCachedPageCount,
              ),
            ),
          ],
          errorSignBuilder: (context, _) => NoNetworkSign(
            retry: _viewModel.reloadFirstPage,
          ),
        ),
      );
}
