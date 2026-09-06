/// Form validation utilities.
class Validators {
  Validators._();

  /// Validate email format.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  /// Validate password strength.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    return null;
  }

  /// Validate required field.
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'هذا الحقل'} مطلوب';
    }
    return null;
  }

  /// Validate phone number (Saudi format).
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phoneRegex = RegExp(r'^(\+?966|0)?5[0-9]{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-]'), ''))) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  /// Validate name (minimum 2 characters).
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    return null;
  }

  /// Validate that two fields match (e.g., password confirmation).
  static String? match(String? value, String? matchValue, [String? fieldName]) {
    if (value != matchValue) {
      return '${fieldName ?? 'القيم'} غير متطابقة';
    }
    return null;
  }

  /// Validate age (for students).
  static String? age(String? value, {int minAge = 4, int maxAge = 80}) {
    if (value == null || value.isEmpty) {
      return 'العمر مطلوب';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'العمر يجب أن يكون رقماً';
    }
    if (age < minAge || age > maxAge) {
      return 'العمر يجب أن يكون بين $minAge و $maxAge';
    }
    return null;
  }
}
