import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/services/service.dart';
import 'package:autumn_conference/core/theme/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:autumn_conference/l10n/app_localizations.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  BarcodeCapture? result;
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool isBottomSheetDisplayed = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.stop();
    }
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.scanqr),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: true,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: buildQrView(context),
                ),
              ),
            ),
          ),
          // Black overlay for bottom bar - OUTSIDE SafeArea
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: onBarcodeDetect,
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void onBarcodeDetect(BarcodeCapture barcodeCapture) async {
    if (!isBottomSheetDisplayed && barcodeCapture.barcodes.isNotEmpty) {
      result = barcodeCapture;
      await controller.stop();
      isBottomSheetDisplayed = true; 
      dialogAlert();
    }
  }

  String? title;
  String? body;
  bool register = false;
  int? id;
  bool attendMessage = false;

  Future<dynamic> dialogAlert() {
    final userData = ref.watch(userDataProvider);
    final eventData = ref.watch(presentationDataProvider).asData?.value;
    int? userId;
    int? eventIdMatchingWithCode;

    userData.when(
        data: (data) {
          userId = data.id;

          if (result!.barcodes.first.rawValue == "0fCpKyBVgZFsobgYPo6j2w2e0VA1yxLT") {
            eventIdMatchingWithCode = 2023;
            register = true;
            title = AppLocalizations.of(context)!.rollCallTitle;
            body = AppLocalizations.of(context)!.rollCallBody;
          } else {
            for (var event in eventData!) {
              if (event.id == int.tryParse(result!.barcodes.first.rawValue ?? '')) {
                eventIdMatchingWithCode = event.id;
                break;
              }
            }
            if (data.attendedToEventId?.contains(eventIdMatchingWithCode) ?? false) {
              register = false;
              title = AppLocalizations.of(context)!.allreadyAttended;
              body = AppLocalizations.of(context)!.allReadyAttendedMessage;
            } else if (eventIdMatchingWithCode == null) {
              title = AppLocalizations.of(context)!.unrecognized;
              body = AppLocalizations.of(context)!.unrecognizedMessage;
            } else if (data.registeredEventId?.contains(eventIdMatchingWithCode) ??
                false) {
              register = true;
              title = AppLocalizations.of(context)!.attendedEvent;
              body = AppLocalizations.of(context)!.attendedEventMessage(
                  eventData.firstWhere((e) => e.id == eventIdMatchingWithCode).title!);
            } else {
              title = AppLocalizations.of(context)!.nonRegistered;
              body = AppLocalizations.of(context)!.nonRegisterMessage;
            }
          }
        },
        loading: () => const Text(" "),
        error: (error, stackTrace) => const Text(" "));

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 277,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.25,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          height: 5.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          body!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (register == true)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: () {
                                isBottomSheetDisplayed = false;
                                register = false;
                                Navigator.pop(context);
                                controller.start();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          if (register == true)
                            const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1AB7EA),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                            onPressed: () async {
                              final ctx = context;
                              final navigator = Navigator.of(ctx);
                              final successMessage = AppLocalizations.of(ctx)!.scanAttendMessage;
                              isBottomSheetDisplayed = false;
                              if (register == false) {
                                navigator.pop();
                                controller.start();
                              } else {
                                attendMessage = true;

                                register = false;
                                await WebService().attendanceEvent(
                                    userId!, eventIdMatchingWithCode!, successMessage);
                                controller.start();
                                ref.invalidate(userDataProvider);
                                ref.invalidate(presentationDataProvider);
                                if (mounted) {
                                  navigator.pop();
                                }
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.ok,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
