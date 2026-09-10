import 'package:flutter/material.dart';

/// Stub AppLocalizations until build_runner code gen is restored.
///
/// Arabic is primary. All strings used via AppLocalizations.of(context).
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ── Common ──
  String get appTitle => 'حفيظ';
  String get save => 'حفظ';
  String get cancel => 'إلغاء';
  String get delete => 'حذف';
  String get edit => 'تعديل';
  String get add => 'إضافة';
  String get search => 'بحث';
  String get loading => 'جار التحميل...';
  String get error => 'خطأ';
  String get success => 'نجاح';
  String get confirm => 'تأكيد';
  String get yes => 'نعم';
  String get no => 'لا';
  String get ok => 'موافق';
  String get retry => 'إعادة المحاولة';
  String get noData => 'لا توجد بيانات';
  String get saved => 'تم الحفظ';
  String get name => 'الاسم';
  String get title => 'العنوان';
  String get description => 'الوصف';
  String get status => 'الحالة';
  String get notes => 'ملاحظات';
  String get gender => 'الجنس';
  String get nationality => 'الجنسية';
  String get dateOfBirth => 'تاريخ الميلاد';
  String get level => 'المستوى';
  String get advanced => 'متقدم';
  String get common => 'عام';
  String get accent => 'accent';
  String get validation => 'التحقق';
  String get searchHint => 'ابحث...';
  String get emptyTitle => 'فارغ';
  String get emptyMessage => 'لا توجد بيانات';
  String get saving => 'جار الحفظ...';
  String get all => 'الكل';
  String get next => 'التالي';
  String get previous => 'السابق';

  // ── Auth ──
  String get login => 'تسجيل الدخول';
  String get logout => 'تسجيل الخروج';
  String get email => 'البريد الإلكتروني';
  String get password => 'كلمة المرور';
  String get forgotPassword => 'نسيت كلمة المرور؟';
  String get resetPassword => 'إعادة تعيين كلمة المرور';
  String get fullName => 'الاسم الكامل';
  String get preferredName => 'الاسم المفضل';
  String get phone => 'الهاتف';

  // ── Navigation ──
  String get dashboard => 'لوحة التحكم';
  String get students => 'الطلاب';
  String get teachers => 'المعلمون';
  String get classes => 'الفصول';
  String get attendance => 'الحضور';
  String get schedule => 'الجدول';
  String get quranProgress => 'تقدم القرآن';
  String get assessments => 'التقييمات';
  String get guardians => 'أولياء الأمور';
  String get reports => 'التقارير';
  String get settings => 'الإعدادات';
  String get notifications => 'الإشعارات';
  String get hifzAssignments => 'تعيينات الحفظ';

  // ── Student ──
  String get addStudent => 'إضافة طالب';
  String get studentProfile => 'ملف الطالب';
  String get studentName => 'اسم الطالب';
  String get studentId => 'رقم الطالب';
  String get studentAdded => 'تمت إضافة الطالب';
  String get basicInfo => 'المعلومات الأساسية';
  String get contactInfo => 'معلومات الاتصال';
  String get previousEducation => 'التعليم السابق';
  String get currentQuranLevel => 'مستوى القرآن الحالي';
  String get readingLevel => 'مستوى القراءة';
  String get memorizationLevel => 'مستوى الحفظ';
  String get tajwidLevel => 'مستوى التجويد';
  String get quranEducation => 'تعليم القرآن';
  String get studentsComingSoon => 'الطلاب قريباً';
  String get performanceComingSoon => 'الأداء قريباً';

  // ── Teacher ──
  String get addTeacher => 'إضافة معلم';
  String get teacherProfile => 'ملف المعلم';
  String get teacherName => 'اسم المعلم';

  // ── Class ──
  String get addClass => 'إضافة فصل';
  String get maxCapacity => 'السعة القصوى';
  String get tabInfo => 'معلومات';
  String get tabStudents => 'الطلاب';
  String get tabSchedule => 'الجدول';
  String get tabAttendance => 'الحضور';
  String get tabPerformance => 'الأداء';
  String get tabQuran => 'القرآن';

  // ── Schedule ──
  String get addSession => 'إضافة جلسة';
  String get sessions => 'الجلسات';
  String get noSessions => 'لا توجد جلسات';
  String get noSessionsMessage => 'لا توجد جلسات مجدولة';
  String get noEvents => 'لا توجد أحداث';
  String get startDate => 'تاريخ البداية';
  String get endDate => 'تاريخ النهاية';
  String get startTime => 'وقت البداية';
  String get endTime => 'وقت النهاية';
  String get selectDate => 'اختر التاريخ';
  String get daysOfWeek => 'أيام الأسبوع';
  String get scheduleComingSoon => 'الجدول قريباً';
  String get attendanceComingSoon => 'الحضور قريباً';

  // ── Attendance ──
  String get markAttendance => 'تسجيل الحضور';
  String get present => 'حاضر';
  String get absent => 'غائب';
  String get late => 'متأخر';
  String get excused => 'معذور';
  String get noStudents => 'لا يوجد طلاب';

  // ── Quran ──
  String get quran => 'القرآن';
  String get juzAma => 'جزء عم';
  String get juz2to5 => 'الأجزاء 2-5';
  String get juz6to10 => 'الأجزاء 6-10';
  String get juz11to20 => 'الأجزاء 11-20';
  String get juz21to30 => 'الأجزاء 21-30';
  String get beginner => 'مبتدئ';
  String get elementary => 'ابتدائي';
  String get intermediate => 'متوسط';
  String get hafiz => 'حافظ';
  String get cantRead => 'لا يستطيع القراءة';
  String get none => 'لا شيء';

  // ── Steps ──
  String get basic => 'أساسي';
  String get stepBasicInfo => 'الخطوة 1: المعلومات الأساسية';
  String get stepContact => 'الخطوة 2: معلومات الاتصال';
  String get stepEducation => 'الخطوة 3: التعليم';

  // ── Hifz ──
  String get newMemorization => 'حفظ جديد';
  String get revision => 'مراجعة';
  String get comprehensiveRevision => 'مراجعة شاملة';
  String get assignmentStatus => 'حالة التعيين';
  String get dueDate => 'تاريخ التسليم';
  String get qualityTarget => 'الجودة المطلوبة';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for convenient access via context.l
extension BuildContextLocalization on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}
