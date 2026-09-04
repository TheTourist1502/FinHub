// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'FinHub';

  @override
  String get errorNetwork => 'इंटरनेट कनेक्शन नहीं है। कृपया अपना नेटवर्क जाँचें और फिर प्रयास करें।';

  @override
  String errorServer(String statusCode) {
    return 'सर्वर त्रुटि ($statusCode)। कृपया बाद में पुनः प्रयास करें।';
  }

  @override
  String get errorUnauthorized => 'आपका सत्र समाप्त हो गया है। कृपया फिर से लॉग इन करें।';

  @override
  String get errorForbidden => 'आपके पास यह कार्य करने की अनुमति नहीं है।';

  @override
  String get errorNotFound => 'अनुरोधित संसाधन नहीं मिला।';

  @override
  String get errorUnknown => 'एक अप्रत्याशित त्रुटि हुई। कृपया पुनः प्रयास करें।';

  @override
  String get commonInvalidEmail => 'एक मान्य ईमेल पता दर्ज करें।';

  @override
  String commonInvalidMobileNumber(int min, int max) {
    return '$min से $max अंकों के बीच होना चाहिए।';
  }

  @override
  String get commonInvalidPostalCode => 'एक मान्य पिन कोड दर्ज करें।';

  @override
  String commonMaxLengthExceeded(int max) {
    return 'अधिकतम $max अक्षर की अनुमति है।';
  }

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName आवश्यक है !';
  }

  @override
  String get authLoginTitle => 'पुनः स्वागत है';

  @override
  String get authLoginSubtitle => 'अपने सलाहकार वर्कस्पेस में साइन इन करें।';

  @override
  String get authIdentifierLabel => 'उपयोगकर्ता नाम या ईमेल';

  @override
  String get authIdentifierHint => 'उदा. daniel.alvarez';

  @override
  String get authPasswordLabel => 'पासवर्ड';

  @override
  String get authPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get authShowPassword => 'पासवर्ड दिखाएँ';

  @override
  String get authHidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get authLoginButton => 'साइन इन करें';

  @override
  String get authSignOutButton => 'साइन आउट';

  @override
  String get authInvalidCredentials => 'वह उपयोगकर्ता नाम या पासवर्ड सही नहीं है।';

  @override
  String get validationIdentifierRequired => 'अपना उपयोगकर्ता नाम या ईमेल दर्ज करें।';

  @override
  String get validationPasswordRequired => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get accessDeniedTitle => 'पहुँच अस्वीकृत';

  @override
  String get accessDeniedMessage => 'आपकी भूमिका को इस क्षेत्र तक पहुँच नहीं है।';

  @override
  String get accessDeniedBackButton => 'होम पर वापस जाएँ';

  @override
  String get navHome => 'होम';

  @override
  String get navHouseholds => 'परिवार';

  @override
  String get navRealTime => 'रियल-टाइम';

  @override
  String get navServiceRequests => 'अनुरोध';

  @override
  String get navCommissions => 'कमीशन';

  @override
  String get navInsights => 'इनसाइट्स';

  @override
  String get roleAdvisor => 'सलाहकार';

  @override
  String get roleLeadership => 'नेतृत्व';

  @override
  String comingSoonTitle(String tab) {
    return '$tab जल्द ही आ रहा है';
  }

  @override
  String get comingSoonMessage => 'यह टैब तैयार है और अपनी स्क्रीन की प्रतीक्षा कर रहा है।';

  @override
  String dashboardGreeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String dashboardSessionSummary(String role, String advisorId) {
    return '$role के रूप में साइन इन · सलाहकार $advisorId';
  }

  @override
  String get appErrorWidgetEmptyDescription => 'अभी दिखाने के लिए कोई डेटा नहीं है।';

  @override
  String get appErrorWidgetEmptyTitle => 'अभी यहाँ कुछ नहीं';

  @override
  String get appErrorWidgetForbiddenDescription => 'आपके पास यह कार्य करने की अनुमति नहीं है।';

  @override
  String get appErrorWidgetForbiddenTitle => 'पहुँच अस्वीकृत';

  @override
  String get appErrorWidgetMaintenanceDescription => 'सुधार किए जाने के दौरान यह सुविधा अस्थायी रूप से अनुपलब्ध है।';

  @override
  String get appErrorWidgetMaintenanceTitle => 'रखरखाव जारी है';

  @override
  String get appErrorWidgetNetworkDescription =>
      'इंटरनेट कनेक्शन नहीं है। कृपया अपना नेटवर्क जाँचें और फिर प्रयास करें।';

  @override
  String get appErrorWidgetNetworkTitle => 'कोई कनेक्शन नहीं';

  @override
  String get appErrorWidgetNotFoundDescription => 'आप जो आइटम खोज रहे हैं वह मौजूद नहीं है या हटा दिया गया है।';

  @override
  String get appErrorWidgetNotFoundTitle => 'नहीं मिला';

  @override
  String get appErrorWidgetServerDescription => 'हमारी ओर से कुछ गड़बड़ हो गई। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get appErrorWidgetServerTitle => 'सर्वर त्रुटि';

  @override
  String get appErrorWidgetServiceUnavailableDescription =>
      'सेवा अस्थायी रूप से अनुपलब्ध है। कृपया थोड़ी देर में पुनः प्रयास करें।';

  @override
  String get appErrorWidgetServiceUnavailableTitle => 'सेवा अनुपलब्ध';

  @override
  String get appErrorWidgetTimeoutDescription => 'अनुरोध का उत्तर आने में बहुत समय लगा। कृपया पुनः प्रयास करें।';

  @override
  String get appErrorWidgetTimeoutTitle => 'अनुरोध का समय समाप्त';

  @override
  String get appErrorWidgetUnauthorizedDescription => 'आपका सत्र समाप्त हो गया है। कृपया फिर से लॉग इन करें।';

  @override
  String get appErrorWidgetUnauthorizedTitle => 'सत्र समाप्त';

  @override
  String get appErrorWidgetUnknownDescription => 'एक अप्रत्याशित त्रुटि हुई। कृपया पुनः प्रयास करें।';

  @override
  String get appErrorWidgetUnknownTitle => 'कुछ गड़बड़ हो गई';

  @override
  String get appErrorWidgetValidationDescription =>
      'दी गई कुछ जानकारी मान्य नहीं है। कृपया जाँचें और पुनः प्रयास करें।';

  @override
  String get appErrorWidgetValidationTitle => 'अमान्य जानकारी';

  @override
  String get commonBrowseFile => 'फ़ाइल चुनें';

  @override
  String get commonButtonCancel => 'रद्द करें';

  @override
  String get commonButtonClear => 'साफ़ करें';

  @override
  String get commonButtonOk => 'ठीक है';

  @override
  String get commonButtonRetry => 'पुनः प्रयास करें';

  @override
  String commonDuplicateFile(String fileName) {
    return '$fileName नाम की फ़ाइल पहले से मौजूद है।';
  }

  @override
  String get commonFilePickFailed => 'फ़ाइल पिकर नहीं खुल सका। कृपया पुनः प्रयास करें।';

  @override
  String commonFileTooLarge(String limit) {
    return 'फ़ाइल $limit से छोटी होनी चाहिए।';
  }

  @override
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed) {
    String _temp0 = intl.Intl.pluralLogic(
      allowedCount,
      locale: localeName,
      other: 'प्रकार हैं',
      one: 'प्रकार है',
    );
    return '$rejected प्रकार की फ़ाइल की अनुमति नहीं है। अनुमत फ़ाइल $_temp0 $allowed !';
  }

  @override
  String get commonInputHint => 'लिखें...';

  @override
  String commonMaxFilesReached(int count) {
    return 'अधिकतम फ़ाइल संख्या $count है।';
  }

  @override
  String get commonNoRecordFound => 'कोई रिकॉर्ड नहीं मिला!';

  @override
  String get commonRemove => 'हटाएँ';

  @override
  String get commonSearchClear => 'खोज साफ़ करें';

  @override
  String get commonUnsupportedFileType => 'असमर्थित फ़ाइल प्रकार। कृपया कोई समर्थित फ़ाइल चुनें।';

  @override
  String get commonUploadedDocumentsTitle => 'अपलोड किए गए दस्तावेज़';

  @override
  String selectNSelected(int count) {
    return '$count चयनित';
  }

  @override
  String get selectSearchHint => 'खोजें...';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get statusEscalated => 'आगे बढ़ाया गया';

  @override
  String get statusInProgress => 'प्रगति पर';

  @override
  String get statusNone => 'कोई नहीं';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get allocationChartRoundingNote => 'ⓘ मान दो दशमलव स्थानों तक और प्रतिशत एक दशमलव स्थान तक पूर्णांकित हैं।';

  @override
  String get assetAllocationLabel => 'परिसंपत्ति आवंटन';

  @override
  String get assetClassLongAlternativeInvestment => 'वैकल्पिक निवेश';

  @override
  String get assetClassLongAlternativeInvestments => 'वैकल्पिक निवेश';

  @override
  String get assetClassLongAlts => 'विकल्प';

  @override
  String get assetClassLongAnnuities => 'वार्षिकियाँ';

  @override
  String get assetClassLongBonds => 'बॉण्ड';

  @override
  String get assetClassLongCash => 'नकद एवं नकद समकक्ष';

  @override
  String get assetClassLongDebentures => 'डिबेंचर';

  @override
  String get assetClassLongDerivatives => 'डेरिवेटिव';

  @override
  String get assetClassLongEquity => 'इक्विटी';

  @override
  String get assetClassLongFixedIncome => 'स्थिर आय';

  @override
  String get assetClassLongMutualFunds => 'म्यूचुअल फंड';

  @override
  String get assetClassLongOthers => 'अन्य';

  @override
  String get assetClassLongRealEstate => 'रियल एस्टेट';

  @override
  String get assetClassLongRest => 'शेष';

  @override
  String get assetClassLongStructuredProducts => 'संरचित उत्पाद';

  @override
  String get assetClassMediumAlternativeInvestment => 'वैक. निवेश';

  @override
  String get assetClassMediumAlternativeInvestments => 'वैक. निवेश';

  @override
  String get assetClassMediumAlts => 'विकल्प';

  @override
  String get assetClassMediumAnnuities => 'वार्षिकियाँ';

  @override
  String get assetClassMediumBonds => 'बॉण्ड';

  @override
  String get assetClassMediumCash => 'नकद';

  @override
  String get assetClassMediumDebentures => 'डिबेंचर';

  @override
  String get assetClassMediumDerivatives => 'डेरिवेटिव';

  @override
  String get assetClassMediumEquity => 'इक्विटी';

  @override
  String get assetClassMediumFixedIncome => 'स्थिर आय';

  @override
  String get assetClassMediumMutualFunds => 'म्यूचुअल फंड';

  @override
  String get assetClassMediumOthers => 'अन्य';

  @override
  String get assetClassMediumRealEstate => 'रियल एस्टेट';

  @override
  String get assetClassMediumRest => 'शेष';

  @override
  String get assetClassMediumStructuredProducts => 'संर. उत्पाद';

  @override
  String get assetClassShortAlternativeInvestment => 'वैक. निवेश';

  @override
  String get assetClassShortAlts => 'विक';

  @override
  String get assetClassShortAnnuities => 'वार्षि.';

  @override
  String get assetClassShortBonds => 'बॉण्ड';

  @override
  String get assetClassShortCash => 'नकद';

  @override
  String get assetClassShortDebentures => 'डिबें';

  @override
  String get assetClassShortDerivatives => 'डेरि.';

  @override
  String get assetClassShortEquity => 'इक्वि';

  @override
  String get assetClassShortFixedIncome => 'स्थि.आय';

  @override
  String get assetClassShortMutualFunds => 'एमएफ';

  @override
  String get assetClassShortOthers => 'अन्य';

  @override
  String get assetClassShortRealEstate => 'आरई';

  @override
  String get assetClassShortRest => 'शेष';

  @override
  String get assetClassShortStructuredProducts => 'संर. उत्पाद';

  @override
  String get commonButtonChange => 'बदलें';

  @override
  String get commonSortBy => 'इसके अनुसार क्रमबद्ध करें';

  @override
  String get historyChartBreadcrumbSeparator => ' > ';

  @override
  String get historyChartChangeRowSeparator => ' • ';

  @override
  String historyChartCommissionDataAsOf(String date) {
    return 'ⓘ यह चार्ट $date तक के डेटा पर आधारित है। YTD कमीशन राशि अस्थायी है और लंबित सत्यापन के अधीन है।';
  }

  @override
  String historyChartDataAsOf(String date) {
    return 'ⓘ यह चार्ट $date तक के डेटा पर आधारित है।';
  }

  @override
  String get riskProfileConservative => 'रूढ़िवादी';

  @override
  String get riskProfileGrowth => 'वृद्धि';

  @override
  String get riskProfileHighRisk => 'उच्च जोखिम';

  @override
  String get riskProfileLowRisk => 'कम जोखिम';

  @override
  String get riskProfileModerate => 'मध्यम';

  @override
  String get riskProfileModerateRisk => 'मध्यम जोखिम';

  @override
  String get riskProfileModeratelyAggressive => 'मध्यम रूप से आक्रामक';

  @override
  String get riskProfileModeratelyConservative => 'मध्यम रूप से रूढ़िवादी';

  @override
  String get riskProfileSignificantRisk => 'उल्लेखनीय जोखिम';

  @override
  String get riskProfileSpeculative => 'सट्टात्मक';

  @override
  String get dashboardAssetAllocation => 'परिसंपत्ति आवंटन';

  @override
  String get dashboardAumLabel => 'एयूएम';

  @override
  String get dashboardByAum => '( एयूएम के अनुसार )';

  @override
  String get dashboardHeroYtdLabel => 'YTD';

  @override
  String dashboardHouseholdIdLabel(String code) {
    return 'परिवार आईडी: #$code';
  }

  @override
  String get dashboardQuickActionAccountMaintenance => 'खाता रखरखाव';

  @override
  String get dashboardQuickActionAssetMovement => 'परिसंपत्ति स्थानांतरण';

  @override
  String get dashboardQuickActionClientSearch => 'ग्राहक खोज';

  @override
  String get dashboardQuickActionInvestorPortal => 'निवेशक पोर्टल';

  @override
  String get dashboardQuickActionInvestorPortalLaunchFailedMessage =>
      'निवेशक पोर्टल नहीं खुल सका। कृपया पुनः प्रयास करें।';

  @override
  String get dashboardQuickActionMeetingNotes => 'बैठक नोट्स';

  @override
  String get dashboardQuickActionMyCommissions => 'कमीशन';

  @override
  String get dashboardQuickActionOnlineAccess => 'ऑनलाइन एक्सेस';

  @override
  String get dashboardQuickActionTasksDashboard => 'कार्य डैशबोर्ड';

  @override
  String get dashboardRecentTransactions => 'हाल के लेनदेन';

  @override
  String dashboardRecentTransactionsAsOf(String date) {
    return '( $date तक )';
  }

  @override
  String get dashboardTopHouseholds => 'शीर्ष 5 परिवार';

  @override
  String get dashboardTopHouseholdsShort => 'शीर्ष परिवार';

  @override
  String get dashboardTotalAum => 'कुल एयूएम';

  @override
  String get dashboardTotalCommissions => 'कुल कमीशन';

  @override
  String get dashboardTransactionDateToday => 'आज';

  @override
  String get dashboardTransactionDateYesterday => 'कल';

  @override
  String get dashboardViewAll => 'सभी देखें';

  @override
  String get dashboardViewTransactionHistory => 'लेनदेन इतिहास देखें';

  @override
  String get dashboardYtdChangeLabel => 'YTD परिवर्तन';

  @override
  String get historyChartNoData => 'इस अवधि के लिए कोई डेटा उपलब्ध नहीं है।';

  @override
  String get historyChartRangeCurrentMonth => 'वर्तमान माह';

  @override
  String get historyChartRangePastSixMonths => 'पिछले 6 माह';

  @override
  String get historyChartRangePastThreeMonths => 'पिछले 3 माह';

  @override
  String get historyChartRangeYtd => 'YTD';

  @override
  String historyChartWeekTooltip(int week, String date, String value) {
    return 'सप्ताह$week $date का कमीशन $value है';
  }

  @override
  String get transactionTypeNonTrade => 'गैर-व्यापार';

  @override
  String get viewTransactionsTypeBuy => 'खरीद';

  @override
  String get viewTransactionsTypeSell => 'बिक्री';

  @override
  String get viewTransactionsTitle => 'लेनदेन इतिहास';

  @override
  String accountsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी खाते ($count)',
      one: 'सभी खाते ($count)',
      zero: 'सभी खाते ($count)',
    );
    return '$_temp0';
  }

  @override
  String accountsCustodianLabel(String name) {
    return 'कस्टोडियन : $name';
  }

  @override
  String get accountsFilterAll => 'सभी';

  @override
  String get accountsFilterHouseholdLinked => 'परिवार से जुड़े';

  @override
  String get accountsFilterStandalone => 'स्वतंत्र';

  @override
  String accountsIdLabel(String number) {
    return 'खाता संख्या : $number';
  }

  @override
  String get accountsPaginationError => 'और खाते लोड नहीं हो सके';

  @override
  String get commonName => 'नाम';

  @override
  String get dashboardViewDetails => 'विवरण देखें';

  @override
  String accountDetailAccountNumberLabel(String number) {
    return 'खाता: $number';
  }

  @override
  String accountDetailAllHoldings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी होल्डिंग ($count)',
      one: 'सभी होल्डिंग ($count)',
      zero: 'सभी होल्डिंग ($count)',
    );
    return '$_temp0';
  }

  @override
  String get accountDetailAllTransactionsHeader => 'अंतिम 30 लेनदेन';

  @override
  String get accountDetailAssetAllocation => 'परिसंपत्ति आवंटन';

  @override
  String get accountDetailAumTrend => 'एयूएम रुझान';

  @override
  String get accountDetailAumTrendEmpty => 'अभी कोई एयूएम रुझान डेटा नहीं';

  @override
  String get accountDetailHeroYtdLabel => 'YTD';

  @override
  String get accountDetailLatestActivity => 'नवीनतम गतिविधि';

  @override
  String get accountDetailPositions => 'पोज़िशन';

  @override
  String get accountDetailPositionsEmptyFilter => 'इस परिसंपत्ति वर्ग में कोई होल्डिंग नहीं';

  @override
  String get accountDetailPositionsFilterAll => 'सभी परिसंपत्ति वर्ग';

  @override
  String get accountDetailRiskProfileLabel => 'जोखिम प्रोफ़ाइल:';

  @override
  String get accountDetailScreenTitle => 'खाता विवरण';

  @override
  String get accountDetailTabOverview => 'अवलोकन';

  @override
  String get accountDetailTabTransactions => 'लेनदेन';

  @override
  String get accountDetailToday => 'आज';

  @override
  String get accountDetailTransactionsEmptySearch => 'आपकी खोज से कोई लेनदेन मेल नहीं खाता';

  @override
  String get accountDetailTransactionsSearchHint => 'खोजें';

  @override
  String get commonAmount => 'राशि';

  @override
  String get commonDate => 'तारीख';

  @override
  String get commonValue => 'मूल्य';

  @override
  String get transactionFilterAllTransactions => 'सभी लेनदेन';

  @override
  String get transactionFilterNonTrade => 'गैर-व्यापार';

  @override
  String get transactionFilterTrade => 'व्यापार';

  @override
  String transactionPrice(String price) {
    return 'मूल्य: $price';
  }

  @override
  String viewTransactionsAssetClass(String assetClass) {
    return 'परिसंपत्ति वर्ग: $assetClass';
  }

  @override
  String viewTransactionsDescription(String description) {
    return 'विवरण: $description';
  }

  @override
  String get viewTransactionsDetailClose => 'बंद करें';

  @override
  String get viewTransactionsDetailLabelAmount => 'लेनदेन राशि';

  @override
  String get viewTransactionsDetailLabelAssetClass => 'परिसंपत्ति वर्ग';

  @override
  String get viewTransactionsDetailLabelDate => 'लेनदेन तिथि';

  @override
  String get viewTransactionsDetailLabelDescription => 'विवरण';

  @override
  String get viewTransactionsDetailLabelPricePerUnit => 'प्रति इकाई मूल्य';

  @override
  String get viewTransactionsDetailLabelQuantity => 'मात्रा';

  @override
  String get viewTransactionsDetailLabelTradeDetails => 'अतिरिक्त विवरण';

  @override
  String get viewTransactionsDetailLabelTradeId => 'ट्रेड आईडी';

  @override
  String get viewTransactionsDetailTitle => 'लेनदेन विवरण';

  @override
  String viewTransactionsQuantity(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'मात्रा: $qtyString';
  }

  @override
  String viewTransactionsQuantityShort(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'मात्रा: $qtyString';
  }

  @override
  String get viewTransactionsViewDetails => 'विवरण देखें';

  @override
  String get viewTransactionsEmpty => 'इस फ़िल्टर से कोई लेनदेन मेल नहीं खाता';

  @override
  String get viewTransactionsPaginationError => 'और लेनदेन लोड नहीं हो सके';

  @override
  String get viewTransactionsSearchHint => 'खोजें';

  @override
  String get viewTransactionsAllHeader => 'अंतिम 30 लेनदेन';

  @override
  String get accountsSearchHint => 'खाते से खोजें...';

  @override
  String get householdsSearchHint => 'परिवार से खोजें...';

  @override
  String get householdsTitle => 'परिवार';

  @override
  String get householdsAccountsTabLabel => 'खाते';

  @override
  String householdsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी परिवार ($count)',
      one: 'सभी परिवार ($count)',
      zero: 'सभी परिवार ($count)',
    );
    return '$_temp0';
  }

  @override
  String householdsHouseholdIdLabel(String code) {
    return 'आईडी: $code';
  }

  @override
  String householdsTotalAccounts(int count) {
    return '$count खाते';
  }

  @override
  String get householdsPaginationError => 'अधिक परिवार लोड करने में विफल';

  @override
  String get householdDetailScreenTitle => 'परिवार विवरण';

  @override
  String get householdDetailTabOverview => 'अवलोकन';

  @override
  String get householdDetailTabAccounts => 'खाते';

  @override
  String get householdDetailTabTransactions => 'लेनदेन';

  @override
  String householdDetailSubtitle(String code, int count) {
    return '$code • $count खाते';
  }

  @override
  String get householdDetailTotalAum => 'कुल एयूएम';

  @override
  String get householdDetailYtdPerformance => 'वर्ष-दर-वर्ष परिवर्तन';

  @override
  String get householdDetailAssetAllocation => 'परिसंपत्ति आवंटन';

  @override
  String get householdDetailTopAccounts => 'शीर्ष खाते';

  @override
  String householdDetailSeeAll(int count) {
    return 'सभी देखें ($count)';
  }

  @override
  String householdDetailAccountTypeLabel(String type) {
    return 'खाता प्रकार: $type';
  }

  @override
  String householdDetailAccountNumberLabel(String number) {
    return 'खाता संख्या: $number';
  }

  @override
  String householdDetailAllAccountsHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी खाते ($count)',
      one: 'सभी खाते ($count)',
      zero: 'सभी खाते ($count)',
    );
    return '$_temp0';
  }

  @override
  String get householdDetailNoAccountsFound => 'कोई खाता नहीं मिला।';

  @override
  String get householdDetailAllTransactionsHeader => 'अंतिम 30 लेनदेन';

  @override
  String get householdDetailNoTransactionsFound => 'कोई लेनदेन नहीं मिला।';

  @override
  String get householdDetailTransactionsEmptySearch => 'आपकी खोज से कोई लेनदेन मेल नहीं खाता';

  @override
  String get householdDetailTransactionsSearchHint => 'खोजें';

  @override
  String get householdDetailToday => 'आज';

  @override
  String get commonButtonContinue => 'जारी रखें';

  @override
  String get realTimeSelectAccountTitle => 'एक वित्तीय खाता चुनें';

  @override
  String get realTimeSelectAccountSubtitle =>
      'किसी खाते के लाइव पोज़िशन और लेनदेन देखें। डेटा सीधे स्रोत से प्राप्त होता है और खाता चुनने के बाद केवल पर्शिंग के लिए उपलब्ध है।';

  @override
  String get realTimeSelectAccountLabel => 'खाता संख्या चुनें';

  @override
  String get realTimeSelectAccountHint => 'खाता संख्या चुनें';

  @override
  String get realTimeDetailedViewTitle => 'रीयल-टाइम विस्तृत दृश्य';

  @override
  String get realTimePositionsTab => 'पोज़िशन';

  @override
  String get realTimeTransactionsTab => 'लेनदेन';

  @override
  String get realTimeChangeAccount => 'बदलें';

  @override
  String get realTimeDelayNote => 'रीयल-टाइम पोज़िशन और लेनदेन के लिए मार्केट फ़ीड में 15 मिनट की देरी होती है।';

  @override
  String realTimeCusipIdentifier(String cusip) {
    return 'सीयूएसआईपी पहचानकर्ता: $cusip';
  }

  @override
  String get realTimeMarketPriceLabel => 'बाज़ार मूल्य';

  @override
  String get realTimeClosePriceLabel => 'समापन मूल्य';

  @override
  String get realTimeNoPositions => 'कोई पोज़िशन नहीं मिली।';

  @override
  String get realTimeNoTransactions => 'कोई लेनदेन नहीं मिला।';

  @override
  String get realTimeSearchPositions => 'पोज़िशन खोजें...';

  @override
  String get realTimeSearchTransactions => 'लेनदेन खोजें...';

  @override
  String realTimeAllHoldings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी होल्डिंग्स ($count)',
      one: 'सभी होल्डिंग ($count)',
      zero: 'सभी होल्डिंग ($count)',
    );
    return '$_temp0';
  }

  @override
  String realTimeAllTransactionsHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी लेनदेन',
      one: 'सभी लेनदेन',
      zero: 'सभी लेनदेन',
    );
    return '$_temp0 ($count)';
  }

  @override
  String get realTimeAccountActivityLabel => 'गतिविधि विवरण';

  @override
  String get serviceRequestNewButton => 'नई सेवा अनुरोध';

  @override
  String get serviceRequestSearchHint => 'नाम या कोड से खोजें...';

  @override
  String get serviceRequestFilterAll => 'सभी';

  @override
  String get serviceRequestFilterActive => 'खुली';

  @override
  String get serviceRequestFilterClosed => 'बंद';

  @override
  String serviceRequestHeadingAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी सेवा अनुरोध ($count)',
      one: 'सभी सेवा अनुरोध ($count)',
      zero: 'सभी सेवा अनुरोध ($count)',
    );
    return '$_temp0';
  }

  @override
  String serviceRequestHeadingActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'खुले सेवा अनुरोध ($count)',
      one: 'खुला सेवा अनुरोध ($count)',
      zero: 'खुला सेवा अनुरोध ($count)',
    );
    return '$_temp0';
  }

  @override
  String serviceRequestHeadingClosed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बंद सेवा अनुरोध ($count)',
      one: 'बंद सेवा अनुरोध ($count)',
      zero: 'बंद सेवा अनुरोध ($count)',
    );
    return '$_temp0';
  }

  @override
  String get serviceRequestSectionActive => 'खुली';

  @override
  String get serviceRequestSectionClosed => 'बंद';

  @override
  String get serviceRequestEmpty => 'कोई सेवा अनुरोध नहीं मिला';

  @override
  String get serviceRequestEmptySearch => 'कोई मिलान सेवा अनुरोध नहीं मिला';

  @override
  String get serviceRequestView => 'देखें';

  @override
  String get serviceRequestDateToday => 'आज';

  @override
  String get serviceRequestDateYesterday => 'कल';

  @override
  String get serviceRequestDateTomorrow => 'कल';

  @override
  String get serviceRequestDetailFinancialAccountLabel => 'खाता संख्या :';

  @override
  String get serviceRequestDetailFinancialAccountTypeLabel => 'खाता प्रकार :';

  @override
  String get serviceRequestDetailRecordId => 'एसआर आईडी :';

  @override
  String get serviceRequestDetailStatus => 'वर्तमान स्थिति';

  @override
  String get serviceRequestDetailActionPending => 'लंबित कार्रवाई';

  @override
  String get serviceRequestDetailNoPendingAction => 'कोई लंबित कार्रवाई नहीं';

  @override
  String get serviceRequestDetailDueDateLabel => 'नियत तारीख :';

  @override
  String get serviceRequestDetailWorkflowStatus => 'वर्कफ़्लो स्थिति';

  @override
  String get serviceRequestDetailStepSubmitted => 'प्रस्तुत';

  @override
  String get serviceRequestDetailStepCompleted => 'पूर्ण';

  @override
  String get serviceRequestDetailOwner => 'स्वामी';

  @override
  String get serviceRequestDetailAssignedTo => 'सौंपा गया';

  @override
  String get serviceRequestDetailDueDate => 'नियत तारीख';

  @override
  String get serviceRequestDetailComments => 'टिप्पणियाँ';

  @override
  String get serviceRequestDetailViewMore => 'और देखें';

  @override
  String get serviceRequestDetailClose => 'बंद करें';

  @override
  String get serviceRequestSuccessTitle => 'अनुरोध सबमिट किया गया';

  @override
  String get serviceRequestSuccessRecordLabel => 'आपकी सेवा अनुरोध आईडी';

  @override
  String get serviceRequestSuccessConfirmation => 'सफलतापूर्वक बनाया गया।';

  @override
  String get serviceRequestSuccessCopied => 'रिकॉर्ड आईडी क्लिपबोर्ड पर कॉपी हो गई';

  @override
  String get serviceRequestSuccessRedirectPrefix => 'आप ';

  @override
  String get serviceRequestSuccessRedirectSuffix => ' सेकंड में सेवा अनुरोध होम पेज पर पुनर्निर्देशित होंगे।';

  @override
  String get serviceRequestSuccessGoButton => 'सेवा अनुरोध पर जाएं';
}
