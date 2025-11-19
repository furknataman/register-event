import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/attendance_response_model.dart';
import '../providers/attendance_provider.dart';

class ScanProcessingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setProcessing(bool value) {
    if (state != value) {
      state = value;
    }
  }
}

final scanProcessingProvider =
    NotifierProvider.autoDispose<ScanProcessingNotifier, bool>(
  ScanProcessingNotifier.new,
);

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (ref.read(scanProcessingProvider)) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    ref.read(scanProcessingProvider.notifier).setProcessing(true);

    try {
      final qrData = barcode.rawValue!;

      // Process QR code data
      await _processQRCode(qrData);
    } catch (e) {
      if (mounted) {
        _showErrorDialog(AppLocalizations.of(context)!.qrCodeProcessFailed);
        ref.read(scanProcessingProvider.notifier).setProcessing(false);
      }
    }
  }

  Future<void> _processQRCode(String qrData) async {
    try {
      // Call attendance API
      final attendanceNotifier = ref.read(attendanceProvider.notifier);
      final response = await attendanceNotifier.takeAttendance(qrData);

      if (!mounted) return;

      if (response == null) {
        _showErrorDialog(AppLocalizations.of(context)!.qrCodeProcessFailed);
        ref.read(scanProcessingProvider.notifier).setProcessing(false);
        return;
      }

      // Show result based on status
      _showAttendanceResult(response);
    } catch (e) {
      if (mounted) {
        _showErrorDialog(AppLocalizations.of(context)!.qrCodeProcessFailed);
        ref.read(scanProcessingProvider.notifier).setProcessing(false);
      }
    }
  }

  void _showAttendanceResult(AttendanceResponseModel response) {
    if (response.isSuccess) {
      // Success - green dialog
      final message = response.status == AttendanceStatus.generalAttendanceSuccess
          ? AppLocalizations.of(context)!.generalAttendanceSuccess
          : AppLocalizations.of(context)!.presentationAttendanceSuccess;

      _showSuccessDialog(
        AppLocalizations.of(context)!.attendanceSuccess,
        message,
      );
    } else if (response.isAlreadyTaken) {
      // Already taken - warning yellow dialog
      final message = response.status == AttendanceStatus.generalAttendanceAlreadyTaken
          ? AppLocalizations.of(context)!.generalAttendanceAlreadyTaken
          : AppLocalizations.of(context)!.presentationAttendanceAlreadyTaken;

      _showWarningDialog(
        AppLocalizations.of(context)!.attendanceAlreadyTaken,
        message,
      );
    } else if (response.isError) {
      // Info dialog with specific titles
      final title = response.status == AttendanceStatus.notRegisteredForPresentation
          ? AppLocalizations.of(context)!.notRegistered
          : AppLocalizations.of(context)!.invalidQr;

      final message = response.status == AttendanceStatus.notRegisteredForPresentation
          ? AppLocalizations.of(context)!.notRegisteredForPresentation
          : AppLocalizations.of(context)!.invalidQrCode;

      _showErrorDialogWithTitle(title, message);
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(scanProcessingProvider.notifier).setProcessing(false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(scanProcessingProvider.notifier).setProcessing(false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    _showErrorDialogWithTitle(AppLocalizations.of(context)!.info, message);
  }

  void _showErrorDialogWithTitle(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(scanProcessingProvider.notifier).setProcessing(false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = ref.watch(scanProcessingProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.scanPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: () => _showManualEntryDialog(),
            tooltip: AppLocalizations.of(context)!.manualEntryTitle,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Stack(
                  children: [
                    // Scanner view
                    MobileScanner(
                      controller: controller,
                      onDetect: _onDetect,
                    ),

                    // Overlay with scanning frame
                    Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final cutOutSize = (screenWidth * 0.75).clamp(250.0, 400.0);

                        return Container(
                          decoration: ShapeDecoration(
                            shape: QrScannerOverlayShape(
                              borderColor: Colors.white,
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: cutOutSize,
                            ),
                          ),
                        );
                      },
                    ),

                    // Instructions
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: const EdgeInsets.all(16),
                            constraints: const BoxConstraints(maxHeight: 140),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.scanQrInstruction,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.scanQrAutomatic,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Processing indicator
                    if (isProcessing)
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                      color: Colors.white),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.processingAttendance,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Black overlay for bottom bar - OUTSIDE SafeArea
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.manualEntryTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.manualEntryDescription,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.eventIdLabel,
                  labelStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB7EA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final value = textController.text.trim();
                if (value.isNotEmpty) {
                  Navigator.of(context).pop();
                  ref.read(scanProcessingProvider.notifier).setProcessing(true);
                  _processQRCode(value);
                }
              },
              child: Text(AppLocalizations.of(context)!.manualEntryProcess),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom overlay shape for QR scanner
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    Path holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      );
    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getOuterPath(rect), paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final centerRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    // Draw corner borders
    final path = Path();

    // Top left
    path.moveTo(centerRect.left, centerRect.top + borderLength);
    path.lineTo(centerRect.left, centerRect.top + borderRadius);
    path.quadraticBezierTo(
      centerRect.left,
      centerRect.top,
      centerRect.left + borderRadius,
      centerRect.top,
    );
    path.lineTo(centerRect.left + borderLength, centerRect.top);

    // Top right
    path.moveTo(centerRect.right - borderLength, centerRect.top);
    path.lineTo(centerRect.right - borderRadius, centerRect.top);
    path.quadraticBezierTo(
      centerRect.right,
      centerRect.top,
      centerRect.right,
      centerRect.top + borderRadius,
    );
    path.lineTo(centerRect.right, centerRect.top + borderLength);

    // Bottom right
    path.moveTo(centerRect.right, centerRect.bottom - borderLength);
    path.lineTo(centerRect.right, centerRect.bottom - borderRadius);
    path.quadraticBezierTo(
      centerRect.right,
      centerRect.bottom,
      centerRect.right - borderRadius,
      centerRect.bottom,
    );
    path.lineTo(centerRect.right - borderLength, centerRect.bottom);

    // Bottom left
    path.moveTo(centerRect.left + borderLength, centerRect.bottom);
    path.lineTo(centerRect.left + borderRadius, centerRect.bottom);
    path.quadraticBezierTo(
      centerRect.left,
      centerRect.bottom,
      centerRect.left,
      centerRect.bottom - borderRadius,
    );
    path.lineTo(centerRect.left, centerRect.bottom - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
