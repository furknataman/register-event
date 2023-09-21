import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: buildQrView(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 40),
                child: Text(
                  textAlign: TextAlign.center,
                  "Scan the QR code of \nyour event.",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color(0xffe43c2f),
          borderRadius: 30,
          borderLength: 30,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      controller.pauseCamera();
      dialogAlert();
    });
  }

  String? title;
  String? body;
  bool register = false;
  int? id;
  bool attendMessage = false;

  Future<dynamic> dialogAlert() {
    final userData = ref.watch(userDataProvider).asData?.value;
    final eventData = ref.watch(presentationDataProvider).asData?.value;

    int? eventIdMatchingWithCode;
    for (var event in eventData!) {
      if (event.id!.toString().contains(result!.code.toString())) {
        eventIdMatchingWithCode = event.id;
        break;
      }
    }

    if (eventIdMatchingWithCode == null) {
      title = "Unrecognized Code";
      body =
          "The code you have scanned cannot be recognized by our system. Please scan only the codes printed on doors.";
    } else if (userData!.registeredEventId?.contains(eventIdMatchingWithCode) ?? false) {
      register = true;
      title =
          "Attending to ${eventData.firstWhere((e) => e.id == eventIdMatchingWithCode).title} ";
      body =
          "You are about to attend to${eventData.firstWhere((e) => e.id == eventIdMatchingWithCode).title}, are you sure?";
    } else {
      title = "Non-registered";
      body =
          "You are not registered the event that you have scanned. Please try one of that you are. You can see them on your home page.";
    }

    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: 277,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.25,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Container(
                        height: 5.0,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2.5)),
                            color: Color(0xff828282)),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(title!, style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(body!, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (register == true)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.disable,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            controller!.resumeCamera();
                          },
                          child: Text("Cancel ",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).floatingActionButtonTheme.backgroundColor,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        onPressed: () {
                          if (register == false) {
                            Navigator.pop(context);
                            controller!.resumeCamera();
                          } else {
                            attendMessage = true;

                            // userInfo.writeAttend(registeredEvents: id);
                            Navigator.pop(context);
                            dialogAlert();
                          }
                        },
                        child: const Text(
                          "Okay",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
