import 'dart:async';
import 'dart:math';
import 'package:admission_lottery/home/controllers/draw_controller.dart';
import 'package:admission_lottery/main.dart';
import 'package:admission_lottery/models/student_model.dart';
import 'package:admission_lottery/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> with TickerProviderStateMixin {
  final drawcontroller = Get.isRegistered<DrawController>() ? Get.find<DrawController>() : Get.put(DrawController());

  // Track which columns are visible (0-7 for 8 quota types)
  int visibleColumnsCount = 0;
  Timer? revealTimer;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToMax = false;
  final Random _random = Random();

  // Define all quota types in order
  final List<QuotaData> quotaTypes = [
    QuotaData(
      title: 'Freedom Fighter Quota',
      students: (controller) => controller.fqAdmittedStudents,
    ),
    QuotaData(
      title: 'Education Quota',
      students: (controller) => controller.eqAdmittedStudents,
    ),
    QuotaData(
      title: 'Catchment Area Quota',
      students: (controller) => controller.caqAdmittedStudents,
    ),
    QuotaData(
      title: 'Sibling Quota',
      students: (controller) => controller.siblingAdmittedStudents,
    ),
    QuotaData(
      title: 'Twin Quota',
      students: (controller) => controller.twinAdmittedStudents,
    ),
    QuotaData(
      title: 'Lillah Boarding Quota',
      students: (controller) => controller.lillahBoardingAdmittedStudents,
    ),
    QuotaData(
      title: 'Disability Quota',
      students: (controller) => controller.disabilityAdmittedStudents,
    ),
    QuotaData(
      title: 'General Quota',
      students: (controller) => controller.generalAdmittedStudents,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startRevealSequence();
  }

  void _startRevealSequence() {
    _revealNextColumn(1);
  }

  void _revealNextColumn(int nextColumnIndex) {
    if (!mounted || nextColumnIndex > quotaTypes.length) {
      return;
    }

    // Get delay duration based on column index
    final delaySeconds = _getDelayForColumn(nextColumnIndex);

    Future.delayed(Duration(seconds: delaySeconds), () {
      if (mounted) {
        setState(() {
          visibleColumnsCount = nextColumnIndex;

          // When 6 columns are visible (2 columns left), scroll to max extent
          if (visibleColumnsCount == 6 && !_hasScrolledToMax) {
            _scrollToMaxExtent();
          }
        });

        // Continue to next column
        if (nextColumnIndex < quotaTypes.length) {
          _revealNextColumn(nextColumnIndex + 1);
        }
      }
    });
  }

  int _getDelayForColumn(int columnIndex) {
    // 3rd column (index 3) and 8th column (index 8) should load for 15 seconds
    if (columnIndex == 3 || columnIndex == 8) {
      return 15;
    }
    // All other columns: random between 3-8 seconds
    return 3 + _random.nextInt(6); // 3 + (0-5) = 3-8 seconds
  }

  void _scrollToMaxExtent() {
    if (_scrollController.hasClients && !_hasScrolledToMax) {
      _hasScrolledToMax = true;
      // Wait a bit for the layout to update, then scroll
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    revealTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Result',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            drawcontroller.dispose();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              drawcontroller.createExcel(context);
              drawcontroller.generatePdf(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 300.w, vertical: 10.h),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.class_,
                      label: 'Class',
                      value: '${drawcontroller.homeController.selectedClass.value}',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.access_time,
                      label: 'Shift',
                      value: drawcontroller.homeController.shift.value,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.language,
                      label: 'Version',
                      value: drawcontroller.homeController.version.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: SizedBox(
          height: height - MediaQuery.of(context).padding.top - kToolbarHeight - 40.sp,
          width: width,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int index = 0; index < quotaTypes.length; index++)
                  SizedBox(
                    width: width / quotaTypes.length,
                    height: height - MediaQuery.of(context).padding.top - kToolbarHeight - 40.sp,
                    child: _buildAnimatedQuotaColumn(
                      quotaData: quotaTypes[index],
                      index: index,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedQuotaColumn({
    required QuotaData quotaData,
    required int index,
  }) {
    final isVisible = index < visibleColumnsCount;
    final students = quotaData.students(drawcontroller);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          ),
        );
      },
      child: isVisible ? _buildQuotaColumn(quotaData, students, index) : _buildLoadingColumn(quotaData.title, index),
    );
  }

  Widget _buildQuotaColumn(QuotaData quotaData, List<Student> students, int index) {
    return Padding(
      key: ValueKey('quota_content_$index'),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${quotaData.title}: (${students.length})',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < students.length; i++)
                    TweenAnimationBuilder<double>(
                      key: ValueKey('student_${index}_$i'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (i * 50)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - value)),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                              child: Text(
                                students[i].roll?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingColumn(String title, int index) {
    return Padding(
      key: ValueKey('loading_$index'),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 0.7),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            onEnd: () {
              if (mounted) {
                setState(() {});
              }
            },
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Container(
                  width: 200.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.3, end: 0.7),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 120.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to store quota data
class QuotaData {
  final String title;
  final List<Student> Function(DrawController) students;

  QuotaData({
    required this.title,
    required this.students,
  });
}
