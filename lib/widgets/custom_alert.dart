import 'package:flutter/material.dart';
import 'package:apartmantmanager/global/index.dart';

class CustomAlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback? onClose;
  final String? closeButtonText;
  final VoidCallback? onConfirm;
  final String? confirmButtonText;

  const CustomAlertBanner({
    Key? key,
    required this.title,
    required this.message,
    this.isSuccess = true,
    this.onClose,
    this.closeButtonText,
    this.onConfirm,
    this.confirmButtonText,
  }) : super(key: key);

  Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(120),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isSuccess ? Icons.check_circle : Icons.error,
                        color: isSuccess
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style:
                                AppTextStyles.cardTitle.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message,
                            style:
                                AppTextStyles.bodyText.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isSuccess
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                        ),
                        foregroundColor: isSuccess
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        closeButtonText ?? "Close".tr(),
                        style: AppTextStyles.bodyText.copyWith(
                          color: isSuccess
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (onConfirm != null)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm!();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSuccess
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          confirmButtonText ?? 'OK'.tr(),
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// Global helper function remains the same
void showCustomBanner(
  BuildContext context, {
  required String title,
  required String message,
  bool isSuccess = true,
  VoidCallback? onConfirm,
  String? confirmButtonText,
}) {
  CustomAlertBanner(
    title: title,
    message: message,
    isSuccess: isSuccess,
    confirmButtonText: confirmButtonText,
    onConfirm: onConfirm,
  ).show(context);
}
