import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// A wrapper of [ExtendedImage.network()].
///
/// No need to manually write different branches while overriding the default display
/// effect of load state, instead, just pass widgets.
class FutureNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget Function(BuildContext context, ImageChunkEvent? loadingProgress)?
      loadingBuilder;
  final Widget Function(BuildContext context, ExtendedImageState state)?
      completedBuilder;
  final Widget Function(BuildContext context, void Function() reloadImage)?
      failedBuilder;

  const FutureNetworkImage(
      {super.key,
      required this.url,
      this.fit = BoxFit.cover,
      this.loadingBuilder,
      this.completedBuilder,
      this.failedBuilder});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      fit: fit,
      loadStateChanged: (state) => switch (state.extendedImageLoadState) {
        LoadState.loading => loadingBuilder == null
            ? null
            : loadingBuilder!(context, state.loadingProgress),
        LoadState.completed =>
          completedBuilder == null ? null : completedBuilder!(context, state),
        LoadState.failed => failedBuilder == null
            ? null
            : failedBuilder!(context, state.reLoadImage),
      },
      cache: true,
    );
  }
}
