import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  static const _items = [
    _NavItem(
      activeIconPath: 'assets/icons/nav/home_active.png',
      inactiveIconPath: 'assets/icons/nav/home.png',
      fallbackIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      activeIconPath: 'assets/icons/nav/orders_active.png',
      inactiveIconPath: 'assets/icons/nav/orders.png',
      fallbackIcon: Icons.receipt_long_outlined,
      label: 'Orders',
    ),
    _NavItem(
      activeIconPath: 'assets/icons/nav/wallet_active.png',
      inactiveIconPath: 'assets/icons/nav/wallet.png',
      fallbackIcon: Icons.account_balance_wallet_outlined,
      label: 'Wallet',
    ),
    _NavItem(
      activeIconPath: 'assets/icons/nav/reward_active.png',
      inactiveIconPath: 'assets/icons/nav/reward.png',
      fallbackIcon: Icons.star_border_rounded,
      label: 'Reward',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ── all sizes in logical px, scaled via .h / .w ──────────────────────
    final double bubbleD = 48.w;
    final double barH = 56.h;
    final double hPad = 12.w;
    final double vPadBot = 10.h;
    final double aboveBar = 18.h;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, vPadBot),
      child: SizedBox(
        height: barH + aboveBar,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final barW = constraints.maxWidth;
            final itemW = barW / _items.length;
            final notchCx = itemW * widget.currentIndex + itemW / 2;
      
            
      
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ── notched pill ─────────────────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: barH,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(barH / 2),
                    child: _AnimatedBar(
                      notchCx: notchCx,
                      notchR: bubbleD / 2 + 4.w,
                      notchDepth: bubbleD * 0.40,
                      pillR: barH / 2,
                      color: AppColors.green71,
                      borderColor: Colors.white.withOpacity(0.30),
                    ),
                  ),
                ),
      
                // ── items row ────────────────────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: barH,
                  child: Row(
                    children: List.generate(
                      _items.length,
                      (i) => Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onTap(i),
                          behavior: HitTestBehavior.opaque,
                          child: _NavTile(
                            item: _items[i],
                            isSelected: i == widget.currentIndex,
                            bubbleD: bubbleD,
                            aboveBar: aboveBar,
                            barH: barH,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Animated bar: smoothly slides the notch on tab change ───────────────────
class _AnimatedBar extends StatefulWidget {
  final double notchCx, notchR, notchDepth, pillR;
  final Color color, borderColor;

  const _AnimatedBar({
    required this.notchCx,
    required this.notchR,
    required this.notchDepth,
    required this.pillR,
    required this.color,
    required this.borderColor,
  });

  @override
  State<_AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _cx;
  late double _from;

  @override
  void initState() {
    super.initState();
    _from = widget.notchCx;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _cx = AlwaysStoppedAnimation(widget.notchCx);
  }

  @override
  void didUpdateWidget(_AnimatedBar old) {
    super.didUpdateWidget(old);
    if (old.notchCx != widget.notchCx) {
      _from = old.notchCx;
      _cx = Tween<double>(
        begin: _from,
        end: widget.notchCx,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _cx,
    builder: (_, _) => CustomPaint(
      painter: _BarPainter(
        cx: _cx.value,
        nr: widget.notchR,
        nd: widget.notchDepth,
        pr: widget.pillR,
        color: widget.color,
        border: widget.borderColor,
      ),
    ),
  );
}

// ── Painter ─────────────────────────────────────────────────────────────────
class _BarPainter extends CustomPainter {
  final double cx, nr, nd, pr;
  final Color color, border;

  const _BarPainter({
    required this.cx,
    required this.nr,
    required this.nd,
    required this.pr,
    required this.color,
    required this.border,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final r = pr;
    final aw = nr * 1.15; // approach/exit ramp width

    final p = Path()
      ..moveTo(r, 0)
      // ── left ramp into notch ──────────────────────────────────────────
      ..lineTo(cx - nr - aw, 0)
      ..cubicTo(
        cx - nr - aw * 0.3,
        0, // hover near top
        cx - nr,
        nd, // pull to notch depth
        cx - nr,
        nd,
      )
      // ── concave arc across notch ──────────────────────────────────────
      ..arcToPoint(
        Offset(cx + nr, nd),
        radius: Radius.circular(nr),
        clockwise: false,
      )
      // ── right ramp out of notch ───────────────────────────────────────
      ..cubicTo(cx + nr, nd, cx + nr + aw * 0.3, 0, cx + nr + aw, 0)
      // ── pill corners ──────────────────────────────────────────────────
      ..lineTo(s.width - r, 0)
      ..arcToPoint(
        Offset(s.width, r),
        radius: Radius.circular(r),
        clockwise: true,
      )
      ..lineTo(s.width, s.height - r)
      ..arcToPoint(
        Offset(s.width - r, s.height),
        radius: Radius.circular(r),
        clockwise: true,
      )
      ..lineTo(r, s.height)
      ..arcToPoint(
        Offset(0, s.height - r),
        radius: Radius.circular(r),
        clockwise: true,
      )
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true)
      ..close();

    // soft shadow
    canvas.drawShadow(p, Colors.black.withOpacity(0.35), 10, true);
    // fill
    canvas.drawPath(
      p,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    // border
    canvas.drawPath(
      p,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_BarPainter o) => o.cx != cx;
}

// ── Single nav tile ──────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final double bubbleD, aboveBar, barH;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.bubbleD,
    required this.aboveBar,
    required this.barH,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // inactive: icon + label
        if (!isSelected)
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavIcon(
                assetPath: item.inactiveIconPath,
                fallback: item.fallbackIcon,
                color: Colors.white,
                size: 22.r,
              ),
              SizedBox(height: 3.h),
              Text(
                item.label, 
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
            ],
          ),

        // selected: floating bubble + label
        if (isSelected) ...[
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: bubbleD * 1.8, // bowl is wider than the circle
                height: bubbleD * 1.4,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // ── 1. WHITE BOWL shape at bottom (background patch) ──
                    Positioned(
                      bottom: 10.h,
                      left: 0,
                      right: 0,
                      // height: bubbleD * 1, // bowl height
                      // child: CustomPaint(
                      //   painter: _BowlPainter(color: Colors.white),
                      // ),
                      child: SizedBox(
                        child: Image.asset("assets/Icons/home/navbar_selected.png",)),
                    ),

                    // ── 2. CIRCLE + ICON on top of bowl ───────────────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: bubbleD,
                          height: bubbleD,
                          decoration: BoxDecoration(
                            color: AppColors.green71,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _NavIcon(
                                assetPath: item.activeIconPath,
                                fallback: item.fallbackIcon,
                                color: AppColors.white,
                                size: 20.r,
                              ),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: AppTextStyles.fontFamilyRoboto,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Data + icon ──────────────────────────────────────────────────────────────
class _NavItem {
  final String activeIconPath, inactiveIconPath, label;
  final IconData fallbackIcon;
  const _NavItem({
    required this.activeIconPath,
    required this.inactiveIconPath,
    required this.fallbackIcon,
    required this.label,
  });
}

class _NavIcon extends StatelessWidget {
  final String assetPath;
  final IconData fallback;
  final Color color;
  final double size;
  const _NavIcon({
    required this.assetPath,
    required this.fallback,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => Image.asset(
    assetPath,
    width: size,
    height: size,
    color: color,
    errorBuilder: (_, _, _) => Icon(fallback, size: size, color: color),
  );
}
