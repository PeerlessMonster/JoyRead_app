import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/future_network_image.dart';
import '../core/network_notification.dart';
import 'blurred_box.dart';
import 'load_failed_placeholder.dart';
import 'loading_placeholder.dart';

class LoadStateChangedNetworkImage extends StatelessWidget {
  final String url;
  final String fallbackImageAssetName;
  final bool showLoadingPlaceholder;
  final bool showLoadFailedPlaceholder;
  final bool displayNotificationWhenLoadFailed;
  final Widget Function(BuildContext context, Widget completedWidget)?
      completedBuilder;
  final Color foregroundColor;
  final BoxFit fit;
  final double? placeholderAspectRatio;

  const LoadStateChangedNetworkImage(this.url,
      {super.key,
      required this.fallbackImageAssetName,
      this.showLoadingPlaceholder = true,
      this.showLoadFailedPlaceholder = true,
      this.displayNotificationWhenLoadFailed = false,
      this.completedBuilder,
      required this.foregroundColor,
      this.fit = BoxFit.cover,
      this.placeholderAspectRatio});

  Widget _buildBlurredBox() => BlurredBox(
        imageAssetName: fallbackImageAssetName,
      );

  Widget _buildLoadingPlaceholder(double? value) => LoadingPlaceholder(
        value: value,
        backgroundImageAssetName: fallbackImageAssetName,
        foregroundColor: foregroundColor,
      );

  Widget _buildLoadFailedPlaceholder(void Function() reload) =>
      LoadFailedPlaceholder(
        reload: reload,
        backgroundImageAssetName: fallbackImageAssetName,
        foregroundColor: foregroundColor,
      );

  @override
  Widget build(BuildContext context) => FutureNetworkImage(
        url: url,
        loadingBuilder: (context, loadingProgress) {
          if (!showLoadingPlaceholder) {
            return _buildBlurredBox();
          }

          final value = loadingProgress?.expectedTotalBytes == null
              ? null
              : loadingProgress!.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!;
          return placeholderAspectRatio == null
              ? _buildLoadingPlaceholder(value)
              : AspectRatio(
                  aspectRatio: placeholderAspectRatio!,
                  child: _buildLoadingPlaceholder(value),
                );
        },
        completedBuilder: (context, _1, _2, _3, _4, completedWidget) {
          if (displayNotificationWhenLoadFailed) {
            SchedulerBinding.instance.addPostFrameCallback(
                (timestamp) => NetworkNotification.restored().dispatch(context));
          }

          return completedBuilder == null
              ? completedWidget
              : completedBuilder!(context, completedWidget);
        },
        failedBuilder: (context, reloadImage) {
          if (displayNotificationWhenLoadFailed) {
            SchedulerBinding.instance.addPostFrameCallback(
                (timestamp) => NetworkNotification.error().dispatch(context));
          }

          if (!showLoadFailedPlaceholder) {
            return _buildBlurredBox();
          }
          return placeholderAspectRatio == null
              ? _buildLoadFailedPlaceholder(reloadImage)
              : AspectRatio(
                  aspectRatio: placeholderAspectRatio!,
                  child: _buildLoadFailedPlaceholder(reloadImage),
                );
        },
        fit: fit,
      );
}
