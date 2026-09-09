import 'package:delivary_partner/authentication/registration/presentation/create_page.dart';
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final documentsProvider =
    StateNotifierProvider<DocumentsNotifier, DocumentsState>((ref) {
      return DocumentsNotifier();
    });

class DocumentsState {
  final bool isLoading;
  const DocumentsState({this.isLoading = false});

  DocumentsState copyWith({bool? isLoading}) =>
      DocumentsState(isLoading: isLoading ?? this.isLoading);
}

class DocumentsNotifier extends StateNotifier<DocumentsState> {
  DocumentsNotifier() : super(const DocumentsState());

  Future<void> proceed() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isLoading: false);
  }
}

// ─── Constants ────────────────────────────────────────────────────────────────

/// Background — the lime-green from the screenshot
const _kGreenBg = Color(0xFF8DC63F);

class _DocItem {
  final String label;
  final String pngAsset; // e.g. 'assets/images/png/aadhaar.png'
  const _DocItem(this.label, this.pngAsset);
}

const _kDocuments = [
  _DocItem('Aadhaar Card', 'assets/images/png/aadhaar.png'),
  _DocItem('PAN Card', 'assets/images/png/pan_card.png'),
  _DocItem('Selfie Verification', 'assets/images/png/selfie.png'),
  _DocItem('Driving License', 'assets/images/png/driving_license.png'),
  _DocItem('Vehicle RC', 'assets/images/png/vehicle_rc.png'),
  _DocItem('Bank Details', 'assets/images/png/bank_details.png'),
];

// ignore: camel_case_types
class documentsRequiredPage extends HookConsumerWidget {
  const documentsRequiredPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final state = ref.watch(documentsProvider);

    // ── Animation values ──────────────────────────────────────────────────────
    final headerOpacity = useState(0.0);
    final illustOpacity = useState(0.0);
    final illustOffset = useState(30.0);
    final listOpacity = useState(0.0);
    final btnOpacity = useState(0.0);

    useEffect(() {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => headerOpacity.value = 1.0,
      );
      Future.delayed(const Duration(milliseconds: 280), () {
        illustOpacity.value = 1.0;
        illustOffset.value = 0.0;
      });
      Future.delayed(
        const Duration(milliseconds: 520),
        () => listOpacity.value = 1.0,
      );
      Future.delayed(
        const Duration(milliseconds: 720),
        () => btnOpacity.value = 1.0,
      );
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: const Color(0xFF8DC63F),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              bottom: 30.h,

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 18.h),

                              // ── Logo ────────────────────────────────────────────────
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: headerOpacity.value,
                                child: Image.asset(
                                  'assets/images/png/dash_logo.png',
                                  height: 89.h,
                                  width: 279.w,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(height: 10.h),

                              // ── Illustration ────────────────────────────────────────
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 550),
                                opacity: illustOpacity.value,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 550),
                                  curve: Curves.easeOutCubic,
                                  transform: Matrix4.translationValues(
                                    0,
                                    illustOffset.value,
                                    0,
                                  ),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/png/Group15.png',
                                    height: 102.h,
                                    width: 82.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              SizedBox(height: 14.h),

                              // ── "KYC Documents" title + cards ───────────────────────
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: listOpacity.value,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 40.w,
                                        bottom: 14.h,
                                      ),
                                      child: Text(
                                        'KYC Documents',
                                        style: context.headlineMedium.copyWith(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Color.fromRGBO(240, 80, 95, 1),
                                        ),
                                      ),
                                    ),

                                    // Step cards
                                    ..._kDocuments.asMap().entries.map((entry) {
                                      final step = entry.key + 1;
                                      final doc = entry.value;
                                      final isLast =
                                          entry.key == _kDocuments.length - 1;
                                      return _StepCard(
                                        step: step,
                                        doc: doc,
                                        isLast: isLast,
                                      );
                                    }),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Proceed button — pinned at bottom ───────────────────────────
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: btnOpacity.value,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 51.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kGreenBg,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    await ref
                                        .read(documentsProvider.notifier)
                                        .proceed();
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreateAccountPage(),
                                        ),
                                      );
                                      // context.goNamed(
                                      //   AppRoutesName.createAccountPageName,
                                      // );
                                    }
                                  },
                            child: state.isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Proceed',
                                    style: context.headlineMedium.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step Card ─────────────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final int step;
  final _DocItem doc;
  final bool isLast;

  const _StepCard({
    required this.step,
    required this.doc,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.51.h,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Color.fromRGBO(232, 232, 232, 1), width: 1.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.27),
            blurRadius: 8,
            spreadRadius: -2, // clips shadow on left, right & top
            offset: const Offset(0, 8), // pushes shadow downward only
          ),
        ],
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          width: 42.w,
          height: 42.w, // same as width — always square
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.r),
            child: Image.asset(doc.pngAsset, fit: BoxFit.contain),
          ),
        ),
        title: Text(
          'STEP $step',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(143, 147, 148, 1),
            height: 1.1,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: Text(
            doc.label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: const Color.fromRGBO(117, 117, 117, 1),
          size: 22.sp,
        ),
      ),
    );
  }
}
