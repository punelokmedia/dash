import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/utils/snackbar_helper.dart';
import 'package:dash_logistics/features/dashboard/trip_details/presentation/widget/trip_bottom_card.dart';
import 'package:dash_logistics/features/dashboard/trip_details/presentation/widget/trip_header.dart';
import 'package:dash_logistics/features/dashboard/trip_details/presentation/widget/trip_map_view.dart';
import 'package:dash_logistics/features/dashboard/trip_details/shared/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TripDetailsScreen extends HookConsumerWidget {
  final String tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripControllerProvider);
    final controller = ref.read(tripControllerProvider.notifier);

    useEffect(() {
      Future.microtask(() => controller.loadTrip(tripId));
      return null;
    }, []);

    ref.listen(tripControllerProvider, (_, next) {
      if (next.errorMessage != null) { 
        SnackbarHelper.showError(context, next.errorMessage!);
        controller.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          TripHeader(tripId: state.tripId.isNotEmpty ? state.tripId : tripId),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.lemon),
                  )
                : Column(
                    children: [
                      const Expanded(flex: 5, child: TripMapView()),
                      TripBottomCard(state: state),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
