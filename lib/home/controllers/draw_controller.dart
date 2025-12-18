import 'dart:io';

import 'package:admission_lottery/home/controllers/home_controller.dart';
import 'package:admission_lottery/models/student_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DrawController extends GetxController {
  final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  void clearAll() {
    fqAdmittedStudents.clear();
    eqAdmittedStudents.clear();
    caqAdmittedStudents.clear();
    siblingAdmittedStudents.clear();
    generalAdmittedStudents.clear();
    allStudents.clear();
  }

  @override
  void dispose() {
    clearAll();
    fqAdmittedStudents.clear();
    eqAdmittedStudents.clear();
    caqAdmittedStudents.clear();
    siblingAdmittedStudents.clear();
    generalAdmittedStudents.clear();
    super.dispose();
  }

  final RxList<Student> fqAdmittedStudents = <Student>[].obs;
  final RxList<Student> eqAdmittedStudents = <Student>[].obs;
  final RxList<Student> caqAdmittedStudents = <Student>[].obs;
  final RxList<Student> siblingAdmittedStudents = <Student>[].obs;
  final RxList<Student> twinAdmittedStudents = <Student>[].obs;
  final RxList<Student> lillahBoardingAdmittedStudents = <Student>[].obs;
  final RxList<Student> disabilityAdmittedStudents = <Student>[].obs;
  final RxList<Student> generalAdmittedStudents = <Student>[].obs;

  final RxList<Student> allStudents = <Student>[].obs;

  void drawFqEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfFqQuota,
  }) {
    allStudents.addAll(homeController.students);
    int numberOfFqEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfFqQuota / 100).round();
    fqAdmittedStudents.clear();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isFq?.toLowerCase() == 'yes') {
        if (fqAdmittedStudents.length == numberOfFqEligibleStudents) {
          break;
        }
        fqAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < fqAdmittedStudents.length; i++) {
      allStudents.remove(fqAdmittedStudents[i]);
    }

    fqAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawEqEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfEqQuota,
  }) {
    eqAdmittedStudents.clear();
    final numberOfEqEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfEqQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isEq?.toLowerCase() == 'yes') {
        if (eqAdmittedStudents.length == numberOfEqEligibleStudents) {
          break;
        }
        eqAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < eqAdmittedStudents.length; i++) {
      allStudents.remove(eqAdmittedStudents[i]);
    }
    eqAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawCaqEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfCaqQuota,
  }) {
    caqAdmittedStudents.clear();
    final numberOfCaqEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfCaqQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isCaq?.toLowerCase() == 'yes') {
        if (caqAdmittedStudents.length == numberOfCaqEligibleStudents) {
          break;
        }
        caqAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < caqAdmittedStudents.length; i++) {
      allStudents.remove(caqAdmittedStudents[i]);
    }
    caqAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawSiblingEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfSiblingQuota,
  }) {
    siblingAdmittedStudents.clear();
    final numberOfSiblingEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfSiblingQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isSibling?.toLowerCase() == 'yes') {
        if (siblingAdmittedStudents.length == numberOfSiblingEligibleStudents) {
          break;
        }
        siblingAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < siblingAdmittedStudents.length; i++) {
      allStudents.remove(siblingAdmittedStudents[i]);
    }
    siblingAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawTwinEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfTwinQuota,
  }) {
    twinAdmittedStudents.clear();
    final numberOfTwinEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfTwinQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isTwin?.toLowerCase() == 'yes') {
        if (twinAdmittedStudents.length == numberOfTwinEligibleStudents) {
          break;
        }
        twinAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < twinAdmittedStudents.length; i++) {
      allStudents.remove(twinAdmittedStudents[i]);
    }
    twinAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawLillahBoardingEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfLillahBoardingQuota,
  }) {
    lillahBoardingAdmittedStudents.clear();
    final numberOfLillahBoardingEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfLillahBoardingQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isLillahBoarding?.toLowerCase() == 'yes') {
        if (lillahBoardingAdmittedStudents.length == numberOfLillahBoardingEligibleStudents) {
          break;
        }
        lillahBoardingAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < lillahBoardingAdmittedStudents.length; i++) {
      allStudents.remove(lillahBoardingAdmittedStudents[i]);
    }
    lillahBoardingAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawDisabilityEligibleStudents({
    required int numberOfStudentsToBeAdmitted,
    required int percentageOfDisabilityQuota,
  }) {
    disabilityAdmittedStudents.clear();
    final numberOfDisabilityEligibleStudents = (numberOfStudentsToBeAdmitted * percentageOfDisabilityQuota / 100).round();
    allStudents.shuffle();
    for (int i = 0; i < allStudents.length; i++) {
      if (allStudents[i].isDisablity?.toLowerCase() == 'yes') {
        if (disabilityAdmittedStudents.length == numberOfDisabilityEligibleStudents) {
          break;
        }
        disabilityAdmittedStudents.add(allStudents[i]);
        homeController.students.remove(allStudents[i]);
      }
    }
    for (int i = 0; i < disabilityAdmittedStudents.length; i++) {
      allStudents.remove(disabilityAdmittedStudents[i]);
    }
    disabilityAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
  }

  void drawGeneralStudents({
    required int numberOfStudentsToBeAdmitted,
    required int generalQuotaStudents,
  }) {
    generalAdmittedStudents.clear();
    allStudents.shuffle();

    for (int i = 0; i < allStudents.length; i++) {
      if (generalAdmittedStudents.length == generalQuotaStudents) {
        break;
      }
      generalAdmittedStudents.add(allStudents[i]);
      homeController.students.remove(allStudents[i]);
    }
    for (int i = 0; i < generalAdmittedStudents.length; i++) {
      allStudents.remove(generalAdmittedStudents[i]);
    }
    generalAdmittedStudents.sort((a, b) => a.roll!.compareTo(b.roll!));
    allStudents.sort((a, b) => a.sl!.compareTo(b.sl!));
  }

  int now = DateTime.now().millisecondsSinceEpoch;

  void createExcel(BuildContext context) async {
    now = DateTime.now().millisecondsSinceEpoch;

    final excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add class, shift, and version information
    sheetObject.appendRow([TextCellValue('Class: ${homeController.selectedClass.value}')]);
    sheetObject.appendRow([TextCellValue('Shift: ${homeController.shift.value}')]);
    sheetObject.appendRow([TextCellValue('Version: ${homeController.version.value}')]);
    sheetObject.appendRow([TextCellValue('')]); // Empty row for spacing

    sheetObject.appendRow([TextCellValue('Freedom Fighter Quota: (${fqAdmittedStudents.length})')]);
    for (int i = 0; i < fqAdmittedStudents.length; i++) {
      sheetObject.appendRow([TextCellValue(fqAdmittedStudents[i].roll ?? '')]);
    }

    sheetObject.appendRow([TextCellValue('Education Quota:(${eqAdmittedStudents.length})')]);
    for (int i = 0; i < eqAdmittedStudents.length; i++) {
      sheetObject.appendRow([TextCellValue(eqAdmittedStudents[i].roll ?? '')]);
    }
    sheetObject.appendRow([TextCellValue('')]);
    sheetObject.appendRow([TextCellValue('Catchment Area Quota:(${caqAdmittedStudents.length})')]);
    for (int i = 0; i < caqAdmittedStudents.length; i++) {
      sheetObject.appendRow([TextCellValue(caqAdmittedStudents[i].roll ?? '')]);
    }
    sheetObject.appendRow([TextCellValue('')]);
    sheetObject.appendRow([TextCellValue('Sibling Quota:(${siblingAdmittedStudents.length})')]);
    for (int i = 0; i < siblingAdmittedStudents.length; i++) {
      sheetObject.appendRow([TextCellValue(siblingAdmittedStudents[i].roll ?? '')]);
    }
    sheetObject.appendRow([TextCellValue('')]);
    sheetObject.appendRow([TextCellValue('General Quota: (${generalAdmittedStudents.length})')]);
    for (int i = 0; i < generalAdmittedStudents.length; i++) {
      sheetObject.appendRow([TextCellValue(generalAdmittedStudents[i].roll ?? '')]);
    }
    final fileBytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final filename = '${dir.path}/result_$now.xlsx';
    File(filename)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }

  final image = pw.MemoryImage(
    File('assets/header.jpeg').readAsBytesSync(),
  );

  final headerStyle = pw.TextStyle(
    fontSize: 6,
    fontWeight: pw.FontWeight.bold,
  );

  pw.Widget headerWidget(String text) {
    return pw.Center(
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Text(
          text,
          style: headerStyle,
        ),
      ),
    );
  }

  pw.Widget bodyWidget(List<Student> students) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Column(
        children: [
          for (int i = 0; i < students.length; i++)
            pw.Text(
              students[i].roll!,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10),
        clip: false,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Image(image)),
              pw.SizedBox(height: 10),
              // Add class, shift, and version information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Class: ${homeController.selectedClass.value}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Text(
                    'Shift: ${homeController.shift.value}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Text(
                    'Version: ${homeController.version.value}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                defaultColumnWidth: const pw.IntrinsicColumnWidth(),
                children: [
                  pw.TableRow(
                    children: [
                      headerWidget('Freedom Fighter Quota: (${fqAdmittedStudents.length})'),
                      headerWidget('Education Quota:(${eqAdmittedStudents.length})'),
                      headerWidget('Catchment Area Quota:(${caqAdmittedStudents.length})'),
                      headerWidget('Sibling Quota:(${siblingAdmittedStudents.length})'),
                      headerWidget('Twin Quota:(${twinAdmittedStudents.length})'),
                      headerWidget('Lillah Boarding Quota:(${lillahBoardingAdmittedStudents.length})'),
                      headerWidget('Disability Quota:(${disabilityAdmittedStudents.length})'),
                      headerWidget('General Quota: (${generalAdmittedStudents.length})'),
                    ],
                  ),
                  pw.TableRow(
                    verticalAlignment: pw.TableCellVerticalAlignment.top,
                    children: [
                      bodyWidget(fqAdmittedStudents),
                      bodyWidget(eqAdmittedStudents),
                      bodyWidget(caqAdmittedStudents),
                      bodyWidget(siblingAdmittedStudents),
                      bodyWidget(twinAdmittedStudents),
                      bodyWidget(lillahBoardingAdmittedStudents),
                      bodyWidget(disabilityAdmittedStudents),
                      bodyWidget(generalAdmittedStudents),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final fileBytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final filename = '${dir.path}/result_$now.pdf';
    File(filename)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(filename),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
