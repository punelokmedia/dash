import 'package:delivary_partner/core/infra/driver_online_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isOnlineProvider = NotifierProvider<IsOnlineNotifier, bool>(
  IsOnlineNotifier.new,
);

class IsOnlineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

const _leftItems = [
  _NavItem(icon: Icons.home_rounded, label: 'Home'),
  _NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
];

const _rightItems = [
  _NavItem(icon: Icons.history_rounded, label: 'History'),
  _NavItem(icon: Icons.person_rounded, label: 'profile'),
];

// ─── Colour tokens ─────────────────────────────────────────────────────────────
class _C {
  static const barTop = Color(0xFF8BBB22); // lime green top
  static const barBot = Color(0xFF7A9E1A); // slightly darker bottom
  static const active = Colors.white;
  static const inactive = Color(0xFFD4E88A); // soft yellow-green
  static const activePill = Color(0x22FFFFFF); // subtle white tint pill
  // light grey for OFF state
  // green icon/text on OFF
  static const btnOnTop = Color(0xFF8BBB22);
  static const btnOnBot = Color(0xFF4F7010);
}

// ─────────────────────────────────────────────────────────────────────────────

class BottomNavWidget extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavWidget({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CustomBottomNavBar(navigationShell: navigationShell);
  }
}

class _CustomBottomNavBar extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const _CustomBottomNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(navigationShell.currentIndex);

    // ── Watch session async state ──────────────────────────────────
    final sessionAsync = ref.watch(onlineSessionProvider);
    final session = sessionAsync.asData?.value;
    final isOnline = session?.isOnline ?? false;

    // ── Tick every second to update formattedTime ──────────────────
    final ticker = useState(0);
    useEffect(() {
      if (!isOnline) return null;
      final timer = Stream.periodic(const Duration(seconds: 1));
      final sub = timer.listen((_) => ticker.value++);
      return sub.cancel;
    }, [isOnline]); // restarts timer when online state changes

    final animController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );

    final pulseAnim = useAnimation(
      Tween<double>(begin: 1.0, end: 1.10).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeInOut),
      ),
    );

    useEffect(() {
      if (isOnline) {
        animController.repeat(reverse: true);
      } else {
        animController.stop();
        animController.reset();
      }
      return null;
    }, [isOnline]);

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
        child: SizedBox(
          height: 65.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: _BarBackground(
                  selectedIndex: selectedIndex.value,
                  leftItems: _leftItems,
                  rightItems: _rightItems,
                  onLeftTap: (i) {
                    navigationShell.goBranch(i);
                    selectedIndex.value = i;
                  },
                  onRightTap: (i) {
                    navigationShell.goBranch(i + 2);
                    selectedIndex.value = i + 2;
                  },
                ),
              ),
              Positioned(
                top: -25.h,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(onlineSessionProvider.notifier).toggle(),
                  child: Transform.scale(
                    scale: pulseAnim,
                    child: _CentreToggleButton(
                      isOnline: isOnline,
                      // Pass live time so it re-renders every tick
                      timeLabel: session?.formattedTime ?? '00:00:00',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Fully-rounded floating pill bar ──────────────────────────────────────────
class _BarBackground extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> leftItems;
  final List<_NavItem> rightItems;
  final void Function(int) onLeftTap;
  final void Function(int) onRightTap;

  const _BarBackground({
    required this.selectedIndex,
    required this.leftItems,
    required this.rightItems,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_C.barTop, _C.barBot],
        ),
        // ── All 4 corners rounded = floating pill ──────────────────────
        borderRadius: BorderRadius.circular(36.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A6B10).withOpacity(0.50),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left items
          ...leftItems.asMap().entries.map(
            (e) => Expanded(
              child: _NavTile(
                item: e.value,
                isSelected: selectedIndex == e.key,
                onTap: () => onLeftTap(e.key),
              ),
            ),
          ),

          // Space for centre button
          SizedBox(width: 68.w),

          // Right items
          ...rightItems.asMap().entries.map(
            (e) => Expanded(
              child: _NavTile(
                item: e.value,
                isSelected: selectedIndex == e.key + 2,
                onTap: () => onRightTap(e.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav tile ──────────────────────────────────────────────────────────────────
class _NavTile extends HookWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = useAnimationController(
      duration: const Duration(milliseconds: 220),
      initialValue: isSelected ? 1.0 : 0.0,
    );

    useEffect(() {
      isSelected ? ctrl.forward() : ctrl.reverse();
      return null;
    }, [isSelected]);

    final scaleAnim = useAnimation(
      Tween<double>(
        begin: 0.85,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)),
    );
    final bgAnim = useAnimation(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)),
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.transparent, _C.activePill, bgAnim),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Transform.scale(
              scale: scaleAnim,
              child: Icon(
                item.icon,

                size: 34.sp,
                color: isSelected ? _C.active : _C.inactive,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? _C.active : _C.inactive,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Centre toggle button ──────────────────────────────────────────────────────
class _CentreToggleButton extends StatelessWidget {
  final bool isOnline;
  final String timeLabel; // ← new
  const _CentreToggleButton({required this.isOnline, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Timer label above button ───────────────────────────────
        AnimatedOpacity(
          opacity: isOnline ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _C.barTop,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              timeLabel,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // ── Circle button (unchanged structure) ────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          width: 58.w,
          height: 60.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _C.barTop,
              ),
              child: Center(
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? null : Colors.white,
                    gradient: isOnline
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_C.btnOnTop, _C.btnOnBot],
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: 22.sp,
                        color: isOnline ? Colors.white : Colors.grey.shade500,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        isOnline ? 'On' : 'Off',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isOnline ? Colors.white : Colors.grey.shade500,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
