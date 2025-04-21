import 'package:flutter/material.dart';

import '../core/network_notification.dart';
import '../core/themes/constants/animation.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;
import 'network_notification_banner.dart';
import 'sliver_persistent_header_delegate.dart';

class _NetworkNotificationDisplayContainer extends StatelessWidget {
  final Widget Function(BuildContext context, Widget banner) bodyBuilder;
  final void Function() showBanner;
  final void Function() hideBanner;
  final bool isVisible;
  final bool floating;
  final bool shadowDropped;

  const _NetworkNotificationDisplayContainer(
      {super.key,
      required this.bodyBuilder,
      required this.showBanner,
      required this.hideBanner,
      required this.isVisible,
      this.floating = false,
      this.shadowDropped = false});

  @override
  Widget build(BuildContext context) => NetworkNotificationListener(
        onNetworkError: showBanner,
        onNetworkRestored: () {
          if (isVisible) {
            Future.delayed(
              PlayTime.snackBarDisplay,
              hideBanner,
            );
          }
        },
        childBuilder: (context, isNetworkError) => bodyBuilder(
            context,
            isNetworkError
                ? NetworkErrorNotificationBanner(
                    onClose: hideBanner,
                    capsuleShaped: floating,
                    elevation: shadowDropped ? null : 0,
                  )
                : NetworkRestoredNotificationBanner(
                    onClose: hideBanner,
                    capsuleShaped: floating,
                    elevation: shadowDropped ? null : 0,
                  )),
      );
}

const _bannerHeight = dimension.Banner.heightPlusDivider;

const _duration = Duration(milliseconds: 200);

class FixedNetworkNotificationDisplayContainer extends StatefulWidget {
  final Widget body;

  const FixedNetworkNotificationDisplayContainer(
      {super.key, required this.body});

  @override
  State<FixedNetworkNotificationDisplayContainer> createState() =>
      _FixedNetworkNotificationDisplayContainerState();
}

class _FixedNetworkNotificationDisplayContainerState
    extends State<FixedNetworkNotificationDisplayContainer> {
  var isVisible = false;

  @override
  Widget build(BuildContext context) => _NetworkNotificationDisplayContainer(
        key: widget.key,
        isVisible: isVisible,
        showBanner: () => setState(() {
          isVisible = true;
        }),
        hideBanner: () => setState(() {
          isVisible = false;
        }),
        bodyBuilder: (context, banner) => Column(
          children: [
            AnimatedContainer(
              duration: _duration,
              height: isVisible ? _bannerHeight : 0,
              child: ClipRect(
                child: banner,
              ),
            ),
            Expanded(
              child: widget.body,
            ),
          ],
        ),
      );
}

class SliverFixedNetworkNotificationDisplayContainer extends StatefulWidget {
  final Widget sliverAppBar;
  final List<Widget> sliversBody;

  const SliverFixedNetworkNotificationDisplayContainer(
      {super.key, required this.sliverAppBar, required this.sliversBody});

  @override
  State<SliverFixedNetworkNotificationDisplayContainer> createState() =>
      _SliverFixedNetworkNotificationDisplayContainerState();
}

class _SliverFixedNetworkNotificationDisplayContainerState
    extends State<SliverFixedNetworkNotificationDisplayContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    );
    animation = Tween(begin: .0, end: _bannerHeight).animate(_controller);
  }

  var isVisible = false;

  @override
  Widget build(BuildContext context) => _NetworkNotificationDisplayContainer(
        key: widget.key,
        isVisible: isVisible,
        showBanner: () {
          _controller.forward();

          setState(() {
            isVisible = true;
          });
        },
        hideBanner: () {
          _controller.reverse();

          setState(() {
            isVisible = false;
          });
        },
        bodyBuilder: (context, banner) => CustomScrollView(slivers: [
          widget.sliverAppBar,
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) => SliverPersistentHeader(
              delegate: SizedSliverPersistentHeaderDelegate(
                height: animation.value,
                child: ClipRect(
                  child: banner,
                ),
              ),
              pinned: true,
            ),
          ),
          ...widget.sliversBody,
        ]),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FloatingNetworkNotificationDisplayContainer extends StatefulWidget {
  final Widget body;

  const FloatingNetworkNotificationDisplayContainer(
      {super.key, required this.body});

  @override
  State<FloatingNetworkNotificationDisplayContainer> createState() =>
      _FloatingNetworkNotificationDisplayContainerState();
}

class _FloatingNetworkNotificationDisplayContainerState
    extends State<FloatingNetworkNotificationDisplayContainer> {
  var isVisible = false;

  @override
  Widget build(BuildContext context) => _NetworkNotificationDisplayContainer(
        key: widget.key,
        shadowDropped: isVisible,
        floating: true,
        isVisible: isVisible,
        showBanner: () => setState(() {
          isVisible = true;
        }),
        hideBanner: () => setState(() {
          isVisible = false;
        }),
        bodyBuilder: (context, banner) => Stack(
          alignment: Alignment.topCenter,
          children: [
            widget.body,
            AnimatedPositioned(
              duration: _duration,
              top: isVisible
                  ? spacing.Margin.floatingVerticalMargin
                  : -_bannerHeight,
              child: SizedBox(
                width: dimension.Banner.floatingWidth,
                child: banner,
              ),
            ),
          ],
        ),
      );
}
