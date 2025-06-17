import 'package:flutter/material.dart';

import '../../../core/future_widget.dart';
import '../../../core/responsive_margin.dart';
import '../../../core/themes/constants/animation.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/load_state_changed_network_image.dart';
import '../../../widgets/search_field.dart';
import '../view_models/extensions.dart';
import '../view_models/search_view_model.dart';
import 'search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _viewModel = SearchViewModel();

  static const _spacing = spacing.Padding.increment * 1;

  @override
  Widget build(BuildContext context) {
    final responsiveEdgeInsets = calculateResponsiveMarginValue(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: calculateResponsiveMarginValue(context),
                vertical: spacing.Padding.targetSpacing,
              ),
              child: Center(
                child: Hero(
                  tag: HeroTag.scaffoldFloatingActionButton,
                  child: SearchField(onSearch: _viewModel.search),
                ),
              ),
            ),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) => _viewModel.hasResult
                  ? Expanded(
                      child: FutureWidget(
                        dataFuture: _viewModel.resultFuture,
                        uncompletedWidget: ListView(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsiveEdgeInsets,
                              vertical: _spacing,
                            ),
                            child: SearchResultCardSkeleton(isLoading: true),
                          ),
                        ]),
                        dataBuilder: (context, dataList) => ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final data = dataList[index];

                            final imageUrl = _viewModel
                                .loadImageUrl(data.coverImageFilename);
                            final fallbackImage =
                                _viewModel.loadFallbackImage();

                            return Padding(
                              padding: EdgeInsets.only(
                                left: responsiveEdgeInsets,
                                right: responsiveEdgeInsets,
                                top: _spacing,
                                bottom:
                                    index == dataList.length - 1 ? _spacing : 0,
                              ),
                              child: SearchResultCard(
                                dataId: data.id,
                                image: LoadStateChangedNetworkImage(
                                  imageUrl,
                                  fallbackImageAssetName:
                                      fallbackImage.assetName,
                                  foregroundColor:
                                      fallbackImage.foregroundColor,
                                ),
                                title: data.title,
                                segments: data.hitSegments,
                                source: data.source,
                                time: data.formattedPublishTime,
                              ),
                            );
                          },
                        ),
                        errorBuilder: (context, _) => ListView(children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: responsiveEdgeInsets,
                              right: responsiveEdgeInsets,
                              top: _spacing,
                            ),
                            child: SearchResultCardSkeleton(isLoading: false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: _spacing),
                            child: Center(
                              child: FilledButton.icon(
                                onPressed: _viewModel.retrySearch,
                                label: Text('Retry'),
                                icon: Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
