import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import '../core/network_notification.dart';
import '../core/responsive_layout_builder.dart';
import '../core/themes/constants/animation.dart' as animation;
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;
import 'network_notification_banner.dart';

class DisplayNetworkNotificationBody extends StatefulWidget {
  final Widget child;

  const DisplayNetworkNotificationBody({super.key, required this.child});

  @override
  State<DisplayNetworkNotificationBody> createState() =>
      _DisplayNetworkNotificationBodyState();
}

class _DisplayNetworkNotificationBodyState
    extends State<DisplayNetworkNotificationBody> {
  var isNetworkError = false;

  static const _bannerHeight = dimension.MaterialBanner.heightPlusDivider;

  var isVisible = false;

  void _hideBanner() => setState(() {
        isVisible = false;
      });

  static const _hideDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) => NetworkNotificationListener(
        onNetworkError: () {
          if (!isNetworkError) {
            setState(() {
              isNetworkError = true;
            });

            setState(() {
              isVisible = true;
            });
          }
        },
        onNetworkRestored: () {
          if (isNetworkError) {
            setState(() {
              isNetworkError = false;
            });

            if (isVisible) {
              Future.delayed(
                animation.SnackBar.displayDuration,
                () => setState(() {
                  isVisible = false;
                }),
              );
            }
          }
        },
        child: ResponsiveLayoutBuilder(
          narrowScreenWidget: Column(children: [
            AnimatedContainer(
              duration: _hideDuration,
              height: isVisible ? _bannerHeight : 0,
              child: isNetworkError
                  ? NetworkErrorNotificationBanner(
                      onClose: _hideBanner,
                    )
                  : NetworkRestoredNotificationBanner(
                      onClose: _hideBanner,
                    ),
            ),
            Expanded(
              child: widget.child,
            ),
          ]),
          wideScreenWidget: Stack(
            alignment: Alignment.topCenter,
            children: [
              widget.child,
              AnimatedPositioned(
                duration: _hideDuration,
                top: isVisible
                    ? spacing.Margin.floatingVerticalMargin
                    : -_bannerHeight,
                child: SizedBox(
                  width: Breakpoint.medium.screenWidthRange.start,
                  child: isNetworkError
                      ? NetworkErrorNotificationBanner(
                          onClose: _hideBanner,
                          shapedCapsule: true,
                          elevation: isVisible ? null : 0,
                        )
                      : NetworkRestoredNotificationBanner(
                          onClose: _hideBanner,
                          shapedCapsule: true,
                          elevation: isVisible ? null : 0,
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}
