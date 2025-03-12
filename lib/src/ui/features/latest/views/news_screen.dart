import 'package:flutter/material.dart';

import '../../../core/shared/sign.dart';
import '../../../widgets/load_state_changed_future_layout.dart';
import '../view_models/news_screen.dart';
import 'more_news_list.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});

  final _viewModel = NewsScreenViewModel();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => LoadStateChangedFutureSliverLayoutWithSign(
          dataFuture: _viewModel.firstPageFuture,
          title: '最新资讯',
          uncompletedSign: LoadingSign(),
          dataBuilder: (context, data) => [
            MoreLatestNewsList(
              firstPage: data,
              loadMorePage: _viewModel.loadMorePage,
              fallbackImage: _viewModel.fallbackImage,
              pageSize: _viewModel.pageSize,
              preloadDataCount: _viewModel.preloadDataCount,
              maxCachedPageCount: _viewModel.maxCachedPageCount,
            ),
          ],
          errorSignBuilder: (context, _) => NoNetworkSign(
            retry: _viewModel.reloadFirstPage,
          ),
        ),
      );
}
