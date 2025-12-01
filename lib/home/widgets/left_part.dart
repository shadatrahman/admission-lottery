// ignore_for_file: invalid_use_of_protected_member

import 'package:admission_lottery/home/controllers/draw_controller.dart';
import 'package:admission_lottery/home/controllers/home_controller.dart';
import 'package:admission_lottery/home/screens/result_view.dart';
import 'package:admission_lottery/home/widgets/textfield_with_label.dart';
import 'package:admission_lottery/main.dart';
import 'package:admission_lottery/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:win_toast/win_toast.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class LeftPart extends StatefulWidget {
  const LeftPart({
    super.key,
  });

  @override
  State<LeftPart> createState() => _LeftPartState();
}

class _LeftPartState extends State<LeftPart> {
  final controller = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    // controller.readDataFromExcelSheet();
    studentToBeAdmittedController.text = '100';
    freedomFighterQuotaController.text = '5';
    educationQuotaController.text = '2';
    catchmentAreaQuotaController.text = '40';
    siblingQuotaController.text = '5';
    twinQuotaController.text = '3';
    lillahBoardingQuotaController.text = '2';
    disabilityQuotaController.text = '1';
  }

  final studentToBeAdmittedController = TextEditingController();
  final freedomFighterQuotaController = TextEditingController();
  final educationQuotaController = TextEditingController();
  final catchmentAreaQuotaController = TextEditingController();
  final siblingQuotaController = TextEditingController();
  final twinQuotaController = TextEditingController();
  final lillahBoardingQuotaController = TextEditingController();
  final disabilityQuotaController = TextEditingController();

  @override
  void dispose() {
    studentToBeAdmittedController.dispose();
    freedomFighterQuotaController.dispose();
    educationQuotaController.dispose();
    catchmentAreaQuotaController.dispose();
    siblingQuotaController.dispose();
    twinQuotaController.dispose();
    lillahBoardingQuotaController.dispose();
    disabilityQuotaController.dispose();

    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: width,
      height: height,
      color: AppColors.tertiaryContainer,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Class:',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Obx(
                    () => DropdownButton(
                      value: controller.selectedClass.value,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 3,
                          child: Text('3', style: TextStyle(fontSize: 16.sp)),
                        ),
                        // DropdownMenuItem(
                        //   value: 6,
                        //   child: Text('6', style: TextStyle(fontSize: 16.sp)),
                        // ),
                        // DropdownMenuItem(
                        //   value: 9,
                        //   child: Text('9', style: TextStyle(fontSize: 16.sp)),
                        // ),
                      ],
                      onChanged: (v) {
                        controller.selectedClass.value = v as int;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(
                () => controller.selectedClass.value == 9
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Major:',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: AppColors.onTertiaryContainer,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Obx(
                                () => DropdownButton(
                                  value: controller.selectedMajor.value,
                                  underline: const SizedBox(),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Science',
                                      child: Text('Science', style: TextStyle(fontSize: 16.sp)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Commerce',
                                      child: Text('Commerce', style: TextStyle(fontSize: 16.sp)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Arts',
                                      child: Text('Arts', style: TextStyle(fontSize: 16.sp)),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    controller.selectedMajor.value = v as String;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      )
                    : const SizedBox(),
              ),
              Row(
                children: [
                  Text(
                    'Version:',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Obx(
                    () => DropdownButton(
                      value: controller.version.value,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English', style: TextStyle(fontSize: 16.sp)),
                        ),
                        DropdownMenuItem(
                          value: 'Bangla',
                          child: Text('Bangla', style: TextStyle(fontSize: 16.sp)),
                        ),
                      ],
                      onChanged: (v) {
                        controller.version.value = v as String;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'Shift:',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Obx(
                    () => DropdownButton(
                      value: controller.shift.value,
                      underline: const SizedBox(),
                      items: [
                        // DropdownMenuItem(
                        //   value: 'Morning',
                        //   child: Text('Morning', style: TextStyle(fontSize: 16.sp)),
                        // ),
                        DropdownMenuItem(
                          value: 'Day',
                          child: Text('Day', style: TextStyle(fontSize: 16.sp)),
                        ),
                      ],
                      onChanged: (v) {
                        controller.shift.value = v as String;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'Resident Status:',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Obx(
                    () => DropdownButton(
                      value: controller.res.value,
                      underline: const SizedBox(),
                      items: [
                        // DropdownMenuItem(
                        //   value: 'Mandatory Resident',
                        //   child: Text('Mandatory Resident', style: TextStyle(fontSize: 16.sp)),
                        // ),
                        DropdownMenuItem(
                          value: 'Non-resident',
                          child: Text('Non-resident', style: TextStyle(fontSize: 16.sp)),
                        ),
                      ],
                      onChanged: (v) {
                        controller.res.value = v as String;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextFieldWithLabel(
                controller: studentToBeAdmittedController,
                label: 'Students to be admitted:',
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(v) < 0) {
                    return 'Please enter a positive number';
                  }
                  if (int.parse(v) > controller.students.length) {
                    return 'Can not be more than ${controller.students.length}';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: freedomFighterQuotaController,
                label: 'Freedom Fighter Quota(%):',
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(v) > 100) {
                    return 'Please enter a value less than 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: educationQuotaController,
                label: 'Education Quota(%):',
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(v) > 100) {
                    return 'Please enter a value less than 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: catchmentAreaQuotaController,
                label: 'Catchment Area Quota(%):',
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(v) > 100) {
                    return 'Please enter a value less than 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: siblingQuotaController,
                label: 'Sibling Quota(%):',
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(v) > 100) {
                    return 'Please enter a value less than 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: twinQuotaController,
                label: 'Twin Quota(%):',
                validator: (v) {
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: lillahBoardingQuotaController,
                label: 'Lillah Boarding Quota(%):',
                validator: (v) {
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFieldWithLabel(
                controller: disabilityQuotaController,
                label: 'Disability Quota(%):',
                validator: (v) {
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              if (isLoading)
                Center(child: const CircularProgressIndicator())
              else
                GestureDetector(
                  onTap: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    getResult(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Result',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onPrimary,
                        ),
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

  Future<void> showToast(String message) async {
    final xml = """
<?xml version="1.0" encoding="UTF-8"?>
<toast launch="action=viewConversation&amp;conversationId=9813">
   <visual>
      <binding template="ToastGeneric">
         <text></text>
         <text>$message</text>
      </binding>
   </visual>
   <actions>
      <input id="tbReply" type="text" placeHolderContent="Type a reply" />
      <action content="Reply" activationType="background" arguments="action=reply&amp;conversationId=9813" />
      <action content="Like" activationType="background" arguments="action=like&amp;conversationId=9813" />
      <action content="View" activationType="background" arguments="action=viewImage&amp;imageUrl=https://picsum.photos/364/202?image=883" />
   </actions>
</toast>
  """;
    WinToast.instance().showCustomToast(xml: xml);
  }

  void getResult(BuildContext context) {
    try {
      setState(() {
        isLoading = true;
      });
      controller.filterStudents();
      final drawController = Get.isRegistered<DrawController>() ? Get.find<DrawController>() : Get.put(DrawController());

      final int numberOfStudentsToBeAdmitted = int.tryParse(studentToBeAdmittedController.text) ?? 0;
      final int percentageOfFqQuota = freedomFighterQuotaController.text.isEmpty ? 0 : int.tryParse(freedomFighterQuotaController.text) ?? 0;
      final int percentageOfEqQuota = educationQuotaController.text.isEmpty ? 0 : int.tryParse(educationQuotaController.text) ?? 0;
      final int percentageOfCaqQuota = catchmentAreaQuotaController.text.isEmpty ? 0 : int.tryParse(catchmentAreaQuotaController.text) ?? 0;
      final int percentageOfSiblingQuota = siblingQuotaController.text.isEmpty ? 0 : int.tryParse(siblingQuotaController.text) ?? 0;
      final int percentageOfTwinQuota = twinQuotaController.text.isEmpty ? 0 : int.tryParse(twinQuotaController.text) ?? 0;
      final int percentageOfLillahBoardingQuota = lillahBoardingQuotaController.text.isEmpty ? 0 : int.tryParse(lillahBoardingQuotaController.text) ?? 0;
      final int percentageOfDisabilityQuota = disabilityQuotaController.text.isEmpty ? 0 : int.tryParse(disabilityQuotaController.text) ?? 0;

      drawController.clearAll();

      drawController.drawFqEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfFqQuota: percentageOfFqQuota,
      );

      drawController.drawEqEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfEqQuota: percentageOfEqQuota,
      );

      drawController.drawCaqEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfCaqQuota: percentageOfCaqQuota,
      );

      drawController.drawSiblingEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfSiblingQuota: percentageOfSiblingQuota,
      );

      drawController.drawTwinEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfTwinQuota: percentageOfTwinQuota,
      );

      drawController.drawLillahBoardingEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfLillahBoardingQuota: percentageOfLillahBoardingQuota,
      );

      drawController.drawDisabilityEligibleStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        percentageOfDisabilityQuota: percentageOfDisabilityQuota,
      );

      final int generalQuota = numberOfStudentsToBeAdmitted -
          drawController.fqAdmittedStudents.length -
          drawController.eqAdmittedStudents.length -
          drawController.caqAdmittedStudents.length -
          drawController.siblingAdmittedStudents.length -
          drawController.twinAdmittedStudents.length -
          drawController.lillahBoardingAdmittedStudents.length -
          drawController.disabilityAdmittedStudents.length;
      drawController.drawGeneralStudents(
        numberOfStudentsToBeAdmitted: numberOfStudentsToBeAdmitted,
        generalQuotaStudents: generalQuota,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultView(),
        ),
      );
      // showToast('Result generated successfully');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // showToast('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
