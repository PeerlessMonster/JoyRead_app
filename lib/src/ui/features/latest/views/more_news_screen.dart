import 'package:flutter/material.dart';

import '../../../../utils/breakpoint.dart';
import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/shared/illustration.dart';
import '../../../widgets/load_state_screen.dart';
import '../../../widgets/network_notification_display_container.dart';
import '../../../widgets/sign.dart';
import '../view_models/more_news_view_model.dart';
import 'more_news_list.dart';

const _title = '最新资讯';

class MoreNewsScreen extends StatefulWidget {
  const MoreNewsScreen({super.key});

  @override
  State<MoreNewsScreen> createState() => _MoreNewsScreenState();
}

class _MoreNewsScreenState extends State<MoreNewsScreen> {
  final _viewModel = MoreNewsViewModel();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) => FutureWidget(
          dataFuture: _viewModel.firstPageFuture,
          uncompletedWidget: LoadStateScreen(
            title: _title,
            sign: Sign(
              imageAssetName: Illustration.loading.assetName,
              text: Illustration.loading.description,
            ),
          ),
          dataBuilder: (context, data) => Scaffold(
            body: SafeArea(
              child: BreakpointProvider(
                child: _AdaptiveSliverNetworkNotificationDisplayContainer(
                  sliverAppBar: SliverAppBar(
                    title: Text(_title),
                    floating: true,
                  ),
                  sliverBody: MoreLatestNewsList(
                    firstPage: data,
                    loadMorePage: _viewModel.loadMorePage,
                    loadImageUrl: _viewModel.loadImageUrl,
                    loadFallbackImage: _viewModel.loadFallbackImage,
                    pageSize: _viewModel.pageSize,
                    preloadDataCount: _viewModel.preloadDataCount,
                    maxCachedPageCount: _viewModel.maxCachedPageCount,
                  ),
                ),
              ),
            ),
          ),
          errorBuilder: (context, error) => LoadStateScreen(
            title: _title,
            sign: Sign(
              imageAssetName: Illustration.noNetwork.assetName,
              text: Illustration.noNetwork.description,
              action: FilledButton(
                onPressed: _viewModel.reloadFirstPage,
                child: Text('Retry'),
              ),
            ),
          ),
        ),
      );
}

class _AdaptiveSliverNetworkNotificationDisplayContainer
    extends StatelessWidget {
  final Widget sliverAppBar;
  final Widget sliverBody;

  const _AdaptiveSliverNetworkNotificationDisplayContainer(
      {required this.sliverAppBar, required this.sliverBody});

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.of(context);
    return breakpoint <= Breakpoint.compact
        ? SliverFixedNetworkNotificationDisplayContainer(
            sliverAppBar: sliverAppBar,
            sliversBody: [sliverBody],
          )
        : FloatingNetworkNotificationDisplayContainer(
            body: CustomScrollView(slivers: [
              sliverAppBar,
              sliverBody,
            ]),
          );
  }
}
