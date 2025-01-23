import 'package:apartmantmanager/modules/manager-apartment/manager-service.dart';
import 'package:flutter/material.dart';
import 'package:apartmantmanager/global/index.dart';

class FormWidgets {
  // Section Header Widget
  static Widget buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: GlobalConfig.primaryColor),
          const SizedBox(width: 6),
          Text(
            title.tr(),
            style: AppTextStyles.cardTitle
                .copyWith(color: GlobalConfig.primaryColor, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // Form Field Widget
  static Widget buildFormField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    Widget? prefix,
    bool required = false,
    String? Function(String?)? customValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyText
            .copyWith(color: Colors.grey.shade900, fontSize: 15),
        cursorColor: Colors.grey.shade600,
        validator: (value) {
          // First check if the field is required
          if (required && (value == null || value.isEmpty)) {
            return "${label.tr()} ${'is required'.tr()}";
          }
          // If a custom validator is provided, use it
          if (customValidator != null) {
            return customValidator(value);
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label.tr() + (required ? ' *' : ''),
          labelStyle: AppTextStyles.bodyText
              .copyWith(color: Colors.grey.shade600, fontSize: 14),
          prefix: prefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade800),
            gapPadding: 4,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade200),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}
