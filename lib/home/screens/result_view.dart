import 'dart:async';
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
    // Wait 2 seconds before showing first column, then reveal each subsequent column every 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          visibleColumnsCount = 1;
        });

        // Continue revealing remaining columns every 2 seconds
        revealTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
          if (mounted) {
            setState(() {
              if (visibleColumnsCount < quotaTypes.length) {
                visibleColumnsCount++;

                // When 6 columns are visible (2 columns left), scroll to max extent
                if (visibleColumnsCount == 6 && !_hasScrolledToMax) {
                  _scrollToMaxExtent();
                }
              } else {
                timer.cancel();
              }
            });
          }
        });
      }
    });
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
