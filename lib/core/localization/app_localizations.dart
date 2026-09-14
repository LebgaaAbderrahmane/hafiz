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
  String get yesterday => 'أمس';
  String get now => 'الآن';

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
  String get authAppName => 'حافظ';
  String get authOrDivider => 'أو';
  String get authNoAccount => 'ليس لديك حساب؟';
  String get authCreateAccount => 'إنشاء حساب';
  String get authSignUpTitle => 'إنشاء حساب';
  String get authSignUpSubtitle => 'إنشاء حساب جديد';
  String get authSignUpDescription => 'أدخل بياناتك لإنشاء حساب';
  String get authRequired => 'مطلوب';
  String get authInvalidEmail => 'بريد غير صالح';
  String get authPasswordMinLength => '6 أحرف على الأقل';
  String get authConfirmPassword => 'تأكيد كلمة المرور';
  String get authPasswordsMismatch => 'كلمتا المرور غير متطابقتين';
  String get authCreateAccountButton => 'إنشاء الحساب';
  String get authAlreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';
  String get authSignUpSuccess => 'تم إنشاء الحساب بنجاح. يمكنك تسجيل الدخول الآن.';

  // ── Navigation ──
  String get dashboard => 'لوحة التحكم';
  String get dashboardGreeting => 'مرحباً';
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

  // ── Student Edit ──
  String get editStudentTitle => 'تعديل الطالب';
  String get editStudentBasicInfo => 'المعلومات الأساسية';
  String get editStudentContactInfo => 'معلومات الاتصال';
  String get editStudentMale => 'ذكر';
  String get editStudentFemale => 'أنثى';
  String get editStudentSave => 'حفظ التعديلات';
  String get editStudentSuccess => 'تم تعديل الطالب بنجاح';

  // ── Teacher ──
  String get addTeacher => 'إضافة معلم';
  String get teacherProfile => 'ملف المعلم';
  String get teacherName => 'اسم المعلم';

  // ── Teacher Add ──
  String get addTeacherTitle => 'إضافة معلم';
  String get addTeacherBasicInfo => 'المعلومات الأساسية';
  String get addTeacherContactInfo => 'معلومات الاتصال';
  String get addTeacherProfessionalInfo => 'المعلومات المهنية';
  String get addTeacherSpecialization => 'التخصص';
  String get addTeacherHireDate => 'تاريخ التعيين';
  String get addTeacherSelectDate => 'اختر التاريخ';
  String get addTeacherNotesHint => 'ملاحظات إضافية...';
  String get addTeacherSubmit => 'إضافة المعلم';
  String get addTeacherBranchRequired => 'يجب اختيار الفرع قبل الإضافة';
  String get addTeacherSuccess => 'تمت إضافة المعلم بنجاح';

  // ── Teacher Profile ──
  String get teacherProfileTitle => 'ملف المعلم';
  String get teacherNotFound => 'المعلم غير موجود';
  String get teacherTabInfo => 'المعلومات';
  String get teacherTabClasses => 'الفصول';
  String get teacherTabSchedule => 'الجدول';
  String get teacherInfoFullName => 'الاسم الكامل';
  String get teacherInfoPreferredName => 'الاسم المفضل';
  String get teacherInfoGender => 'الجنس';
  String get teacherInfoDateOfBirth => 'تاريخ الميلاد';
  String get teacherInfoNationality => 'الجنسية';
  String get teacherInfoPhone => 'الهاتف';
  String get teacherInfoEmail => 'البريد الإلكتروني';
  String get teacherInfoSpecialization => 'التخصص';
  String get teacherInfoQualifications => 'المؤهلات';
  String get teacherInfoCertifications => 'الشهادات';
  String get teacherInfoLanguages => 'اللغات';
  String get teacherInfoStatus => 'الحالة';
  String get teacherInfoHireDate => 'تاريخ التوظيف';
  String get teacherInfoNotes => 'ملاحظات';
  String get teacherClassesError => 'حدث خطأ في تحميل الفصول';
  String get teacherNoClasses => 'لا توجد فصول';
  String get teacherNoClassesHint => 'لم يُسند أي فصل لهذا المعلم بعد';
  String get teacherScheduleError => 'حدث خطأ في تحميل الجدول';
  String get teacherNoSessions => 'لا توجد حصص مجدولة';
  String get teacherNoSessionsHint => 'لا توجد حصص مجدولة لهذا المعلم خلال 30 يوماً';
  String get teacherSessionScheduled => 'مجدول';
  String get teacherSessionInProgress => 'قيد التنفيذ';
  String get teacherSessionCompleted => 'مكتمل';
  String get teacherSessionCancelled => 'ملغي';
  String get teacherSessionRescheduled => 'تمت الإعادة جدولة';

  // ── Class ──
  String get addClass => 'إضافة فصل';
  String get maxCapacity => 'السعة القصوى';
  String get tabInfo => 'معلومات';
  String get tabStudents => 'الطلاب';
  String get tabSchedule => 'الجدول';
  String get tabAttendance => 'الحضور';
  String get tabPerformance => 'الأداء';
  String get tabQuran => 'القرآن';

  // ── Class Add ──
  String get addClassTitle => 'إضافة فصل';
  String get addClassInfo => 'معلومات الفصل';
  String get addClassName => 'اسم الفصل';
  String get addClassDescription => 'الوصف';
  String get addClassLevel => 'المستوى';
  String get addClassMaxStudents => 'الحد الأقصى للطلاب';
  String get addClassDays => 'أيام الأسبوع';
  String get addClassTiming => 'التوقيت';
  String get addClassSelectBranch => 'يرجى اختيار الفرع';
  String get addClassSubmit => 'إنشاء الفصل';
  String get addClassSuccess => 'تم إنشاء الفصل بنجاح';

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
  String get attendanceHistory => 'سجل الحضور';
  String get selectClass => 'اختر الفصل';
  String get allClasses => 'جميع الفصول';
  String get monthlyAttendance => 'الحضور الشهري';
  String get attendancePercentage => 'نسبة الحضور';
  String get noAttendanceRecords => 'لا توجد سجلات حضور';
  String get noAttendanceRecordsMessage => 'لم يتم تسجيل أي حضور في هذا التاريخ';
  String get today => 'اليوم';
  String get markAttendanceForClass => 'تسجيل الحضور للفصل';
  String get attendanceEmptyClassSelection => 'اختر فصلاً لعرض سجل الحضور';

  // ── Quran ──
  String get quran => 'القرآن';
  String get surah => 'السورة';
  String get surahs => 'سور';
  String get ayahs => 'آيات';
  String get pages => 'صفحات';
  String get tabSurahs => 'السور';
  String get tabJuzs => 'الأجزاء';
  String get memorizationPlans => 'خطط الحفظ';
  String get noPlans => 'لا توجد خطط';
  String get noPlansMessage => 'لا توجد خطط حفظ';
  String get createPlan => 'إنشاء خطة';
  String get required => 'مطلوب';
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

  // ── Quran Plan ──
  String get quranPlanTitle => 'خطة حفظ جديدة';
  String get quranPlanBasicInfo => 'المعلومات الأساسية';
  String get quranPlanStudentId => 'معرف الطالب';
  String get quranPlanTeacherId => 'معرف المعلم';
  String get quranPlanPriority => 'الأولوية';
  String get quranPlanScope => 'نطاق الحفظ';
  String get quranPlanFromSurah => 'من السورة';
  String get quranPlanFromAyah => 'من الآية';
  String get quranPlanToSurah => 'إلى السورة';
  String get quranPlanToAyah => 'إلى الآية';
  String get quranPlanSubmit => 'إنشاء الخطة';
  String get quranPlanSuccess => 'تم إنشاء الخطة بنجاح';

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

  // ── Hifz Form ──
  String get hifzFormTitle => 'تعيين حفظ جديد';
  String get hifzFormEditTitle => 'تعديل التعيين';
  String get hifzFormType => 'نوع التعيين';
  String get hifzFormTypeNew => 'حفظ جديد';
  String get hifzFormTypeRevision => 'مراجعة';
  String get hifzFormTypeComprehensive => 'مراجعة شاملة';
  String get hifzFormAyahs => 'الآيات';
  String get hifzFormFromSurah => 'من السورة';
  String get hifzFormFromAyah => 'من الآية';
  String get hifzFormToSurah => 'إلى السورة';
  String get hifzFormToAyah => 'إلى الآية';
  String get hifzFormDueDate => 'تاريخ التسليم';
  String get hifzFormSelectDate => 'اختر التاريخ';
  String get hifzFormQuality => 'الجودة المطلوبة';
  String get hifzFormNotesHint => 'ملاحظات إضافية...';
  String get hifzFormSaveEdit => 'حفظ التعديلات';
  String get hifzFormCreate => 'إنشاء التعيين';
  String get hifzFormDeleteTitle => 'حذف التعيين';
  String get hifzFormDeleteConfirm => 'هل أنت متأكد من حذف هذا التعيين؟';
  String get hifzFormDeleteSuccess => 'تم حذف التعيين';
  String get hifzFormEditSuccess => 'تم تعديل التعيين بنجاح';
  String get hifzFormCreateSuccess => 'تم إنشاء التعيين بنجاح';

  // ── Hifz List ──
  String get hifzListTitle => 'تعيينات الحفظ';
  String get hifzListEmpty => 'لا توجد تعيينات';
  String get hifzListEmptyHint => 'اضغط + لإنشاء تعيين حفظ جديد';
  String get hifzListTabAll => 'الكل';
  String get hifzListTabPending => 'قيد الانتظار';
  String get hifzListTabInProgress => 'جارية';
  String get hifzListTabCompleted => 'مكتملة';
  String get hifzListFilterByType => 'تصفية حسب النوع';
  String get hifzListOverdue => 'متأخر';
  String get hifzListTomorrow => 'غداً';

  // ── Revision Tracking ──
  String get revisionTracking => 'تتبع المراجعات';
  String get dueToday => 'مستحقة اليوم';
  String get overdueRevision => 'متأخرة';
  String get weakRevision => 'ضعيفة';
  String get strongRevision => 'قوية';
  String get completedRevision => 'مكتملة';
  String get startRevision => 'بدء المراجعة';
  String get revisionResult => 'نتيجة المراجعة';
  String get strongRevisionDesc => 'تم الحفظ بشكل ممتاز';
  String get needsRepetition => 'تحتاج تكرار';
  String get needsRepetitionDesc => 'تم الحفظ مع بعض الأخطاء';
  String get weakRevisionDesc => 'تحتاج مراجعة مكثفة';
  String get noRevisions => 'لا توجد مراجعات';
  String get noRevisionsDesc => 'لا توجد مراجعات حالياً لهذا القسم';
  String get lastReviewed => 'آخر مراجعة';
  String get notReviewedYet => 'لم تُراجع بعد';
  String get revisionRegisteredStrong => 'تم تسجيل المراجعة كقوية';
  String get revisionRegisteredNeedsRepetition => 'تم تسجيل المراجعة كتحتاج تكرار';
  String get revisionRegisteredWeak => 'تم تسجيل المراجعة كضعيفة';
  String get errorLoadingRevisions => 'خطأ في تحميل المراجعات';
  String get errorLoadingStats => 'خطأ في تحميل الإحصائيات';
  String get errorRegisteringRevision => 'خطأ في تسجيل المراجعة';
  String get revisionDetailTitle => 'تفاصيل المراجعة';
  String get revisionAyahs => 'الآيات';
  String get revisionPriority => 'الأولوية';
  String get revisionDueDate => 'موعد المراجعة';
  String get revisionQuality => 'الجودة';
  String get revisionReviewCount => 'عدد المراجعات';
  String get revisionLastReviewedLabel => 'آخر مراجعة';
  String get revisionResultTitle => 'نتيجة المراجعة';
  String get revisionStrongLabel => 'قوية';
  String get revisionStrongDescription => 'تم الحفظ بشكل ممتاز';
  String get revisionNeedsRepetitionLabel => 'تحتاج تكرار';
  String get revisionNeedsRepetitionDescription => 'تم الحفظ مع بعض الأخطاء';
  String get revisionWeakLabel => 'ضعيفة';
  String get revisionWeakDescription => 'تحتاج مراجعة مكثفة';
  String get revisionErrorRegistering => 'خطأ في تسجيل المراجعة';
  String get revisionSince => 'منذ';
  String get revisionWeeks => 'أسابيع';
  String get revisionMonths => 'أشهر';
  String get revisionOverdueBadge => 'متأخر';

  // ── Tasmi ──
  String get tasmiSessionListTitle => 'جلسات التسميع';
  String get tasmiSessionEmptyTitle => 'لا توجد جلسات';
  String get tasmiSessionEmptyDescription => 'لا توجد جلسات تسميع لهذا الفرع';
  String get tasmiSessionAddButton => 'إضافة جلسة';
  String get tasmiFilterAll => 'الكل';
  String get tasmiFilterToday => 'اليوم';
  String get tasmiFilterThisWeek => 'هذا الأسبوع';
  String get tasmiStudent => 'طالب';
  String get tasmiYesterday => 'أمس';
  String get tasmiDaysAgo => 'أيام';
  String get tasmiAccuracy => 'الدقة';
  String get tasmiTajwid => 'التجويد';
  String get tasmiFluency => 'الطلاقة';
  String get tasmiRating => 'التقييم';
  String get tasmiSessionDetailTitle => 'تفاصيل التسميع';
  String get tasmiSessionNotFound => 'جلسة التسميع غير موجودة';
  String get tasmiLoadingSession => 'جاري التحميل...';
  String get tasmiErrorLoadingSession => 'حدث خطأ أثناء تحميل بيانات الجلسة';
  String get tasmiDeleteSession => 'حذف الجلسة';
  String get tasmiDeleteSessionConfirm => 'هل أنت متأكد من حذف هذه الجلسة؟';
  String get tasmiSessionInfo => 'معلومات الجلسة';
  String get tasmiStudentId => 'رقم الطالب';
  String get tasmiTeacherId => 'رقم المعلم';
  String get tasmiSessionId => 'رقم الحصة';
  String get tasmiClassId => 'رقم الفصل';
  String get tasmiFrom => 'من';
  String get tasmiTo => 'إلى';
  String get tasmiSurah => 'سورة';
  String get tasmiResult => 'النتيجة';
  String get tasmiScores => 'الدرجات';
  String get tasmiOverallRating => 'التقييم العام';
  String get tasmiErrors => 'الأخطاء';
  String get tasmiErrorMinor => 'طفيف';
  String get tasmiErrorModerate => 'متوسط';
  String get tasmiErrorMajor => 'جسيم';
  String get tasmiErrorLocation => 'الموضع';
  String get tasmiTeacherNotes => 'ملاحظات المعلم';
  String get tasmiRecordTitle => 'تسجيل التسميع';
  String get tasmiSaving => 'جاري الحفظ...';
  String get tasmiFromSurah => 'من سورة';
  String get tasmiFromAyah => 'من آية';
  String get tasmiToSurah => 'إلى سورة';
  String get tasmiToAyah => 'إلى آية';
  String get tasmiSessionType => 'نوع الحصة';
  String get tasmiOutcome => 'النتيجة';
  String get tasmiHideErrors => 'إخفاء الأخطاء';
  String get tasmiAddErrors => 'إضافة أخطاء';
  String get tasmiSavedSuccessfully => 'تم الحفظ بنجاح';

  // ── Reports ──
  String get reportsTitle => 'التقارير';
  String get reportsErrorLoading => 'خطأ في تحميل التقارير';
  String get reportsSubtitle => 'اختر تصنيفاً لعرض التقارير المتاحة';
  String get reportsStatistics => 'التقارير والإحصائيات';
  String get reportsCategories => 'التصنيفات';
  String get reportsRecent => 'التقارير الأخيرة';
  String get reportsReportCount => 'تقارير';
  String get reportsFormatPdf => 'PDF';
  String get reportsFormatCsv => 'CSV';
  String get reportsFormatExcel => 'Excel';
  String get reportsExportComingSoon => 'سيتم إضافة التصدير قريباً';
  String get reportsSelectPeriod => 'اختيار الفترة';
  String get reportsExport => 'تصدير';
  String get reportsSummary => 'ملخص';
  String get reportsTotal => 'الإجمالي';
  String get reportsPresent => 'حاضرون';
  String get reportsAbsent => 'غائبون';
  String get reportsLate => 'متأخرون';
  String get reportsCompleted => 'مكتمل';
  String get reportsInProgress => 'قيد التنفيذ';
  String get reportsPercentage => 'النسبة';
  String get reportsActive => 'نشطون';
  String get reportsData => 'البيانات';
  String get reportsNoData => 'لا توجد بيانات';
  String get reportsNoReportData => 'لم يتم العثور على بيانات لهذا التقرير';
  String get reportsLoadingReport => 'جاري تحميل التقرير...';
  String get reportsErrorReport => 'حدث خطأ أثناء تحميل التقرير';
  String get reportsNoRecords => 'لا توجد سجلات';
  String get reportsNoReportDataForPeriod => 'لم يتم العثور على بيانات للفترة المحددة';
  String get reportsTableDate => 'التاريخ';
  String get reportsTableStatus => 'الحالة';
  String get reportsTableNotes => 'الملاحظات';
  String get reportsTableSurah => 'السورة';
  String get reportsTableAyahs => 'الآيات';
  String get reportsTableEvaluation => 'التقييم';
  String get reportsTableTeacher => 'المعلم';
  String get reportsTableClass => 'الفصل';
  String get reportsTableSessions => 'الحصص';
  String get reportsTableStudents => 'الطلاب';
  String get reportsTableAttendanceRate => 'معدل الحضور';
  String get reportsStatusPassed => 'ناجح';
  String get reportsStatusNeedsReview => 'يحتاج مراجعة';
  String get reportsDaysAgo => 'يوم';
  String get reportsHoursAgo => 'ساعة';
  String get reportsNow => 'الآن';

  // ── Settings ──
  String get settingsTitle => 'الإعدادات';
  String get settingsGeneral => 'عام';
  String get settingsLanguage => 'اللغة';
  String get settingsLanguageArabic => 'العربية';
  String get settingsTheme => 'المظهر';
  String get settingsThemeLight => 'فاتح';
  String get settingsThemeDark => 'داكن';
  String get settingsThemeAutomatic => 'تلقائي';
  String get settingsOrganization => 'المؤسسة';
  String get settingsBranches => 'الفروع';
  String get settingsUsers => 'المستخدمون';
  String get settingsData => 'البيانات';
  String get settingsBackup => 'النسخ الاحتياطي';
  String get settingsBackupComingSoon => 'النسخ الاحتياطي قيد التطوير';
  String get settingsExportData => 'تصدير البيانات';
  String get settingsExportDataComingSoon => 'تصدير البيانات قيد التطوير';
  String get settingsImportData => 'استيراد البيانات';
  String get settingsImportDataComingSoon => 'استيراد البيانات قيد التطوير';
  String get settingsAbout => 'حول';
  String get settingsAboutApp => 'عن التطبيق';
  String get settingsVersion => 'الإصدار 1.0.0';
  String get settingsTerms => 'الشروط والأحكام';
  String get settingsPrivacy => 'سياسة الخصوصية';
  String get settingsUser => 'مستخدم';
  String get settingsOrgInfo => 'معلومات المؤسسة';
  String get settingsOrgLoading => 'جاري التحميل...';
  String get settingsOrgError => 'خطأ في تحميل البيانات';
  String get settingsOrgName => 'اسم المؤسسة';
  String get settingsOrgAddress => 'العنوان';
  String get settingsOrgPhone => 'الهاتف';
  String get settingsOrgEmail => 'البريد';
  String get settingsNotDetermined => 'غير محدد';
  String get settingsChangeLanguage => 'اختيار اللغة';
  String get settingsLanguageChanged => 'تم تغيير اللغة';
  String get settingsThemeChanged => 'تم تغيير المظهر';
  String get settingsChangeTheme => 'اختيار المظهر';
  String get settingsEditProfile => 'تعديل الملف الشخصي';
  String get settingsProfileUpdated => 'تم تعديل الملف الشخصي';
  String get settingsAppDescription => 'تطبيق إدارة مدارس القرآن الكريم';
  String get settingsAppFeatures => 'إدارة الطلاب والمعلمين والحضور والحفظ والمراجعات';
  String get settingsClose => 'إغلاق';

  // ── Branch Management ──
  String get branchManagementTitle => 'إدارة الفروع';
  String get branchEmpty => 'لا توجد فروع';
  String get branchAddHint => 'اضغط على + لإضافة فرع جديد';
  String get branchAddNew => 'إضافة فرع جديد';
  String get branchEdit => 'تعديل الفرع';
  String get branchName => 'اسم الفرع';
  String get branchDelete => 'حذف الفرع';

  // ── User Management ──
  String get userManagementTitle => 'إدارة المستخدمين';
  String get userManagementEmpty => 'لا يوجد مستخدمون';
  String get userManagementAddHint => 'اضغط على + لدعوة مستخدم جديد';
  String get userManagementInvite => 'دعوة مستخدم';
  String get userManagementRole => 'الدور';
  String get userManagementInviteSent => 'تم إرسال الدعوة';
  String get userManagementSend => 'إرسال';
  String get userManagementEditRole => 'تعديل الدور';

  // ── Parent Portal ──
  String get parentPortalTitle => 'بوابة ولي الأمر';
  String get parentTabHome => 'الرئيسية';
  String get parentTabProgress => 'التقدم';
  String get parentTabAttendance => 'الحضور';
  String get parentTabSchedule => 'الجدول';
  String get parentError => 'حدث خطأ';
  String get parentNoChildren => 'لم يتم ربط أي أطفال بعد';
  String get parentNoChildrenHint => 'سيظهر أبناؤك هنا بعد ربطهم بحسابك';
  String get parentGreetingSubtitle => 'تتبع تقدم أطفالك في حفظ القرآن';
  String get parentLastEvaluations => 'آخر التقييمات';
  String get parentAttendance => 'الحضور';
  String get parentTasmi => 'التسميع';
  String get parentLevel => 'المستوى';
  String get parentTasmiSuccess => 'نجح';
  String get parentMemorizationStats => 'إحصائيات الحفظ';
  String get parentSavedPages => 'الصفحات المحفوظة';
  String get parentMemorizationLevel => 'مستوى الحفظ';
  String get parentNotDetermined => 'غير محدد';
  String get parentAttendanceRate => 'نسبة الحضور';
  String get parentTasmiSessions => 'جلسات التسميع';
  String get parentRecentTasmi => 'جلسات التسميع الأخيرة';
  String get parentNoTasmiEvaluations => 'لا توجد تقييمات بعد';
  String get parentNoTasmiSessions => 'لا توجد جلسات تسميع بعد';
  String get parentUpcomingSessions => 'الجلسات القادمة';
  String get parentNoUpcoming => 'لا توجد جلسات قادمة';
  String get parentErrorLoadingData => 'خطأ في تحميل البيانات';
  String get parentErrorLoadingAttendance => 'خطأ في تحميل بيانات الحضور';
  String get parentOutcomePass => 'نجح';
  String get parentOutcomeNeedsRevision => 'يحتاج مراجعة';
  String get parentOutcomeFail => 'لم ينجح';
  String get parentSessionNewMemorization => 'حفظ جديد';
  String get parentSessionRevision => 'مراجعة';
  String get parentSessionComprehensive => 'مراجعة شاملة';
  String get parentSessionExam => 'امتحان';
  String get parentSessionClass => 'حصة دراسية';
  String get parentSessionTasmi => 'تسميع';
  String get parentLegendPresent => 'حاضر';
  String get parentLegendLate => 'متأخر';
  String get parentLegendAbsent => 'غائب';
  String get parentLegendExcused => 'مبرر';
  String get parentEvaluationLabel => 'التقييم';

  // ── Notifications ──
  String get notificationsTitle => 'الإشعارات';
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';
  String get notificationsDeleteAll => 'حذف الكل';
  String get notificationsDeleteTitle => 'حذف الإشعار';
  String get notificationsDeleteConfirm => 'هل أنت متأكد من حذف هذا الإشعار؟';
  String get notificationsDeleteAllTitle => 'حذف جميع الإشعارات';
  String get notificationsDeleteAllConfirm => 'هل أنت متأكد من حذف جميع الإشعارات؟';
  String get notificationsEmpty => 'لا توجد إشعارات';
  String get notificationsEmptyHint => 'ستظهر هنا الإشعارات الجديدة عند وصولها';
  String get notificationsConnectionError => 'تعذر الاتصال بالخادم';
  String get notificationsLoadingError => 'خطأ في تحميل الإشعارات';
  String get notificationsCheckConnection => 'تأكد من اتصالك بالإنترنت';
  String get notificationsSectionToday => 'اليوم';
  String get notificationsSectionYesterday => 'أمس';
  String get notificationsSectionOlder => 'أقدم';

  // ── Create Notification ──
  String get createNotificationTitle => 'إنشاء إشعار';
  String get createNotificationLabel => 'العنوان';
  String get createNotificationHint => 'أدخل عنوان الإشعار';
  String get createNotificationTitleRequired => 'العنوان مطلوب';
  String get createNotificationBody => 'النص';
  String get createNotificationBodyHint => 'أدخل نص الإشعار';
  String get createNotificationBodyRequired => 'النص مطلوب';
  String get createNotificationType => 'نوع الإشعار';
  String get createNotificationAudience => 'الجمهور';
  String get createNotificationAllParents => 'جميع أولياء الأمور';
  String get createNotificationSpecificClass => 'فصل محدد';
  String get createNotificationSpecificStudent => 'طالب محدد';
  String get createNotificationSelectClass => 'اختر الفصل';
  String get createNotificationSelectStudent => 'اختر الطالب';
  String get createNotificationNoClasses => 'لا توجد فصول متاحة';
  String get createNotificationNoStudents => 'لا يوجد طلاب متاحون';
  String get createNotificationClassHint => 'اختر فصلاً';
  String get createNotificationStudentHint => 'اختر طالباً';
  String get createNotificationErrorClasses => 'خطأ في تحميل الفصول';
  String get createNotificationErrorStudents => 'خطأ في تحميل الطلاب';
  String get createNotificationSendNow => 'إرسال الآن';
  String get createNotificationSelectClassFirst => 'يرجى اختيار فصل';
  String get createNotificationSelectStudentFirst => 'يرجى اختيار طالب';
  String get createNotificationSent => 'تم إرسال الإشعار بنجاح';
  String get createNotificationSendError => 'خطأ في إرسال الإشعار';

  // ── Dashboard ──
  String get dashboardOwnerTitle => 'لوحة التحكم';
  String get dashboardGreetingSubtitle => 'نظرة عامة على أداء مؤسستك';
  String get dashboardOverview => 'نظرة عامة';
  String get dashboardQuickActions => 'إجراءات سريعة';
  String get dashboardRecentActivity => 'النشاط الأخير';
  String get dashboardViewAll => 'عرض الكل';
  String get dashboardNoActivity => 'لا يوجد نشاط حديث';
  String get dashboardConnectionError => 'تعذر الاتصال بالخادم';
  String get dashboardStatsError => 'خطأ في تحميل الإحصائيات';
  String get dashboardActivityError => 'خطأ في تحميل النشاط';
  String get dashboardCheckConnection => 'تأكد من اتصالك بالإنترنت وأن الخادم يعمل';
  String get dashboardCreateClass => 'إنشاء فصل';
  String get dashboardScheduleSession => 'جدولة حصة';
  String get dashboardMinutesShort => 'د';
  String get dashboardHoursShort => 'س';
  String get dashboardDaysShort => 'ي';
  String get dashboardWeeksShort => 'أ';

  // ── Assessments ──
  String get assessmentTitle => 'تقييم جديد';
  String get assessmentBasicInfo => 'المعلومات الأساسية';
  String get assessmentLabel => 'عنوان التقييم';
  String get assessmentType => 'نوع التقييم';
  String get assessmentScores => 'الدرجات';
  String get assessmentMaxScore => 'الدرجة النهائية';
  String get assessmentPassingScore => 'درجة النجاح';
  String get assessmentDateAndNotes => 'التاريخ والملاحظات';
  String get assessmentDate => 'تاريخ التقييم';
  String get assessmentSubmit => 'إنشاء التقييم';
  String get assessmentSuccess => 'تم إنشاء التقييم بنجاح';
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
