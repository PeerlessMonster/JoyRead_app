import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// A wrapper of [ExtendedImage.network()].
///
/// No need to manually switch different states and custom the load state
/// widgets, instead, just pass them.
class FutureNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget Function(BuildContext context, ImageChunkEvent? loadingProgress)?
      loadingBuilder;
  final Widget Function(
      BuildContext context,
      Object? imageStreamKey,
      ImageInfo? imageInfo,
      bool invertColors,
      ImageProvider imageProvider,
      Widget completedWidget)? completedBuilder;
  final Widget Function(BuildContext context, void Function() reloadImage)?
      failedBuilder;

  const FutureNetworkImage(
      {super.key,
      required this.url,
      required this.fit,
      this.loadingBuilder,
      this.completedBuilder,
      this.failedBuilder});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      fit: fit,
      handleLoadingProgress: true,
      loadStateChanged: (state) {
        return switch (state.extendedImageLoadState) {
        LoadState.loading => loadingBuilder == null
            ? null
            : loadingBuilder!(context, state.loadingProgress),
        LoadState.completed => completedBuilder == null
            ? null
            : completedBuilder!(
                context,
                state.imageStreamKey,
                state.extendedImageInfo,
                state.invertColors,
                state.imageProvider,
                state.completedWidget),
        LoadState.failed => failedBuilder == null
            ? null
            : failedBuilder!(context, state.reLoadImage),
      };},
      cache: true,
      clearMemoryCacheWhenDispose: true,
    );
  }
}
