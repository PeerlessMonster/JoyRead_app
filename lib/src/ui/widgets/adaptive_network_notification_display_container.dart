import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import '../core/breakpoint_state.dart';
import '../core/max_width_box.dart';
import '../core/network_notification.dart';
import '../core/themes/constants/animation.dart' as animation;
import '../core/themes/constants/dimension.dart' as dimension;
import 'message_banner.dart';
import 'network_banner.dart';
import 'sliver_persistent_header_delegate.dart';

const _bannerHeight = dimension.Banner.heightIncludingDivider;

class _AdaptiveNetworkNotificationDisplayContainerLayout
    extends StatefulWidget {
  final Widget Function(BuildContext context, Widget banner, bool isBannerShown)
      narrowScreenBuilder;

  const _AdaptiveNetworkNotificationDisplayContainerLayout(
      {super.key, required this.narrowScreenBuilder});

  @override
  State<_AdaptiveNetworkNotificationDisplayContainerLayout> createState() =>
      _AdaptiveNetworkNotificationDisplayContainerLayoutState();
}

class _AdaptiveNetworkNotificationDisplayContainerLayoutState
    extends State<_AdaptiveNetworkNotificationDisplayContainerLayout> {
  var shouldShowBanner = false;

  void _hideBanner() => setState(() {
        shouldShowBanner = false;
      });

  static const _hiddenBannerTopOffset = -(_bannerHeight + 10);
  static const _shownBannerTopOffset = dimension.SnackBar.verticalMargin;

  Widget _buildBanner(bool hasError, bool floating) {
    final behavior =
        floating ? MessageBannerBehavior.floating : MessageBannerBehavior.fixed;

    return hasError
        ? ErrorNetworkBanner(
            onDismissed: _hideBanner,
            behavior: behavior,
          )
        : RestoredNetworkBanner(
            onDismissed: _hideBanner,
            behavior: behavior,
          );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.of(context);

    return NetworkNotificationListener(
      onError: () => setState(() {
        shouldShowBanner = true;
      }),
      onRestored: () {
        if (shouldShowBanner) {
          Future.delayed(animation.SnackBar.displayDuration, _hideBanner);
        }
      },
      childBuilder: (context, hasError) => Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.narrowScreenBuilder(context, _buildBanner(hasError, false),
              breakpoint.isNarrowScreen && shouldShowBanner),
          AnimatedPositioned(
            duration: animation.SnackBar.transitionDuration,
            top: breakpoint.isWideScreen && shouldShowBanner
                ? _shownBannerTopOffset
                : _hiddenBannerTopOffset,
            left: dimension.SnackBar.horizontalMargin,
            right: dimension.SnackBar.horizontalMargin,
            child: MaxWidthBox.breakpoint(
              endpoint: Breakpoint.medium,
              child: _buildBanner(hasError, true),
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptiveNetworkNotificationDisplayContainer extends StatelessWidget {
  final Widget body;

  const AdaptiveNetworkNotificationDisplayContainer(
      {super.key, required this.body});

  @override
  Widget build(BuildContext context) =>
      _AdaptiveNetworkNotificationDisplayContainerLayout(
        key: key,
        narrowScreenBuilder: (context, banner, isBannerShown) =>
            Column(children: [
          AnimatedContainer(
            duration: animation.SnackBar.transitionDuration,
            height: isBannerShown ? _bannerHeight : 0,
            child: ClipRect(child: banner),
          ),
          Expanded(child: body),
        ]),
      );
}

class AdaptiveSliverNetworkNotificationDisplayContainer
    extends StatelessWidget {
  final Widget sliverAppBar;
  final List<Widget> sliversBody;

  const AdaptiveSliverNetworkNotificationDisplayContainer(
      {super.key, required this.sliverAppBar, required this.sliversBody});

  @override
  Widget build(BuildContext context) =>
      _AdaptiveNetworkNotificationDisplayContainerLayout(
        key: key,
        narrowScreenBuilder: (context, banner, isBannerShown) =>
            CustomScrollView(slivers: [
          sliverAppBar,
          TweenAnimationBuilder(
            tween: Tween(
              begin: .0,
              end: isBannerShown ? _bannerHeight : .0,
            ),
            duration: animation.SnackBar.transitionDuration,
            builder: (context, height, child) => SliverPersistentHeader(
              delegate: SizedSliverPersistentHeaderDelegate(
                height: height,
                child: child!,
              ),
              pinned: true,
            ),
            child: ClipRect(child: banner),
          ),
          ...sliversBody,
        ]),
      );
}
