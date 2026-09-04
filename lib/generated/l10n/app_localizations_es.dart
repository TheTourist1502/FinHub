// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'FinHub';

  @override
  String get errorNetwork => 'Sin conexión a internet. Por favor, comprueba tu red e inténtalo de nuevo.';

  @override
  String errorServer(String statusCode) {
    return 'Error del servidor ($statusCode). Por favor, inténtalo más tarde.';
  }

  @override
  String get errorUnauthorized => 'Tu sesión ha expirado. Por favor, inicia sesión de nuevo.';

  @override
  String get errorForbidden => 'No tienes permiso para realizar esta acción.';

  @override
  String get errorNotFound => 'El recurso solicitado no fue encontrado.';

  @override
  String get errorUnknown => 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';

  @override
  String get commonInvalidEmail => 'Introduzca una dirección de correo electrónico válida.';

  @override
  String commonInvalidMobileNumber(int min, int max) {
    return 'Debe tener entre $min y $max dígitos.';
  }

  @override
  String get commonInvalidPostalCode => 'Introduzca un código postal válido.';

  @override
  String commonMaxLengthExceeded(int max) {
    return 'Máximo $max caracteres permitidos.';
  }

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName es obligatorio !';
  }

  @override
  String get authLoginTitle => 'Bienvenido de nuevo';

  @override
  String get authLoginSubtitle => 'Inicia sesión en tu espacio de asesor.';

  @override
  String get authIdentifierLabel => 'Usuario o correo electrónico';

  @override
  String get authIdentifierHint => 'p. ej. daniel.alvarez';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authPasswordHint => 'Introduce tu contraseña';

  @override
  String get authShowPassword => 'Mostrar contraseña';

  @override
  String get authHidePassword => 'Ocultar contraseña';

  @override
  String get authLoginButton => 'Iniciar sesión';

  @override
  String get authSignOutButton => 'Cerrar sesión';

  @override
  String get authInvalidCredentials => 'El usuario o la contraseña no son correctos.';

  @override
  String get validationIdentifierRequired => 'Introduce tu usuario o correo electrónico.';

  @override
  String get validationPasswordRequired => 'Introduce tu contraseña.';

  @override
  String get accessDeniedTitle => 'Acceso denegado';

  @override
  String get accessDeniedMessage => 'Tu rol no tiene acceso a esta sección.';

  @override
  String get accessDeniedBackButton => 'Volver al inicio';

  @override
  String get navHome => 'Inicio';

  @override
  String get navHouseholds => 'Grupos familiares';

  @override
  String get navRealTime => 'Tiempo real';

  @override
  String get navServiceRequests => 'Solicitudes';

  @override
  String get navCommissions => 'Comisiones';

  @override
  String get navInsights => 'Análisis';

  @override
  String get roleAdvisor => 'Asesor';

  @override
  String get roleLeadership => 'Dirección';

  @override
  String comingSoonTitle(String tab) {
    return '$tab llegará pronto';
  }

  @override
  String get comingSoonMessage => 'Esta pestaña ya está conectada y espera sus pantallas.';

  @override
  String dashboardGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String dashboardSessionSummary(String role, String advisorId) {
    return 'Sesión iniciada como $role · asesor $advisorId';
  }

  @override
  String get appErrorWidgetEmptyDescription => 'No hay datos para mostrar en este momento.';

  @override
  String get appErrorWidgetEmptyTitle => 'Aún No Hay Nada Aquí';

  @override
  String get appErrorWidgetForbiddenDescription => 'No tienes permiso para realizar esta acción.';

  @override
  String get appErrorWidgetForbiddenTitle => 'Acceso Denegado';

  @override
  String get appErrorWidgetMaintenanceDescription =>
      'Esta función no está disponible temporalmente mientras hacemos mejoras.';

  @override
  String get appErrorWidgetMaintenanceTitle => 'En Mantenimiento';

  @override
  String get appErrorWidgetNetworkDescription =>
      'No hay conexión a internet. Por favor, verifica tu red e intenta de nuevo.';

  @override
  String get appErrorWidgetNetworkTitle => 'Sin Conexión';

  @override
  String get appErrorWidgetNotFoundDescription => 'El elemento que buscas no existe o ha sido movido.';

  @override
  String get appErrorWidgetNotFoundTitle => 'No Encontrado';

  @override
  String get appErrorWidgetServerDescription => 'Algo salió mal de nuestro lado. Por favor, intenta más tarde.';

  @override
  String get appErrorWidgetServerTitle => 'Error del Servidor';

  @override
  String get appErrorWidgetServiceUnavailableDescription =>
      'El servicio no está disponible temporalmente. Por favor, intenta en unos momentos.';

  @override
  String get appErrorWidgetServiceUnavailableTitle => 'Servicio No Disponible';

  @override
  String get appErrorWidgetTimeoutDescription =>
      'La solicitud tardó demasiado en responder. Por favor, intenta de nuevo.';

  @override
  String get appErrorWidgetTimeoutTitle => 'Tiempo de Espera Agotado';

  @override
  String get appErrorWidgetUnauthorizedDescription => 'Tu sesión ha expirado. Por favor, inicia sesión de nuevo.';

  @override
  String get appErrorWidgetUnauthorizedTitle => 'Sesión Expirada';

  @override
  String get appErrorWidgetUnknownDescription => 'Ocurrió un error inesperado. Por favor, intenta de nuevo.';

  @override
  String get appErrorWidgetUnknownTitle => 'Algo Salió Mal';

  @override
  String get appErrorWidgetValidationDescription =>
      'Parte de la información proporcionada no es válida. Por favor, revísala e intenta de nuevo.';

  @override
  String get appErrorWidgetValidationTitle => 'Información No Válida';

  @override
  String get commonBrowseFile => 'Buscar Archivo';

  @override
  String get commonButtonCancel => 'Cancelar';

  @override
  String get commonButtonClear => 'Borrar';

  @override
  String get commonButtonOk => 'Aceptar';

  @override
  String get commonButtonRetry => 'Intentar de nuevo';

  @override
  String commonDuplicateFile(String fileName) {
    return 'Ya existe un archivo con $fileName.';
  }

  @override
  String get commonFilePickFailed => 'No se pudo abrir el selector de archivos. Inténtalo de nuevo.';

  @override
  String commonFileTooLarge(String limit) {
    return 'El archivo debe ser menor de $limit.';
  }

  @override
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed) {
    String _temp0 = intl.Intl.pluralLogic(
      allowedCount,
      locale: localeName,
      other: 'Los tipos de archivo permitidos son',
      one: 'El tipo de archivo permitido es',
    );
    return 'El tipo de archivo $rejected no está permitido. $_temp0 $allowed !';
  }

  @override
  String get commonInputHint => 'Escribe...';

  @override
  String commonMaxFilesReached(int count) {
    return 'El número máximo de archivos es $count.';
  }

  @override
  String get commonNoRecordFound => '¡No se encontraron registros!';

  @override
  String get commonRemove => 'Eliminar';

  @override
  String get commonSearchClear => 'Borrar búsqueda';

  @override
  String get commonUnsupportedFileType => 'Tipo de archivo no compatible. Por favor, elija un archivo compatible.';

  @override
  String get commonUploadedDocumentsTitle => 'Documentos Subidos';

  @override
  String selectNSelected(int count) {
    return '$count seleccionados';
  }

  @override
  String get selectSearchHint => 'Buscar…';

  @override
  String get statusApproved => 'Aprobado';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusEscalated => 'Escalado';

  @override
  String get statusInProgress => 'En Progreso';

  @override
  String get statusNone => 'Ninguno';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String get allocationChartRoundingNote =>
      'ⓘ Los valores se redondean a dos decimales y los porcentajes a un decimal.';

  @override
  String get assetAllocationLabel => 'Asignación de Activos';

  @override
  String get assetClassLongAlternativeInvestment => 'Inversión Alternativa';

  @override
  String get assetClassLongAlternativeInvestments => 'Inversiones Alternativas';

  @override
  String get assetClassLongAlts => 'Alternativos';

  @override
  String get assetClassLongAnnuities => 'Anualidades';

  @override
  String get assetClassLongBonds => 'Bonos';

  @override
  String get assetClassLongCash => 'Efectivo y Equivalentes';

  @override
  String get assetClassLongDebentures => 'Debentures';

  @override
  String get assetClassLongDerivatives => 'Derivados';

  @override
  String get assetClassLongEquity => 'Acciones';

  @override
  String get assetClassLongFixedIncome => 'Renta Fija';

  @override
  String get assetClassLongMutualFunds => 'Fondos Mutuos';

  @override
  String get assetClassLongOthers => 'Otros';

  @override
  String get assetClassLongRealEstate => 'Bienes Raíces';

  @override
  String get assetClassLongRest => 'Resto';

  @override
  String get assetClassLongStructuredProducts => 'Productos Estructurados';

  @override
  String get assetClassMediumAlternativeInvestment => 'Inv. Alt.';

  @override
  String get assetClassMediumAlternativeInvestments => 'Invs. Alt.';

  @override
  String get assetClassMediumAlts => 'Alt';

  @override
  String get assetClassMediumAnnuities => 'Anualidades';

  @override
  String get assetClassMediumBonds => 'Bonos';

  @override
  String get assetClassMediumCash => 'Efectivo';

  @override
  String get assetClassMediumDebentures => 'Debentures';

  @override
  String get assetClassMediumDerivatives => 'Derivados';

  @override
  String get assetClassMediumEquity => 'Acciones';

  @override
  String get assetClassMediumFixedIncome => 'Renta Fija';

  @override
  String get assetClassMediumMutualFunds => 'Fondos Mutuos';

  @override
  String get assetClassMediumOthers => 'Otros';

  @override
  String get assetClassMediumRealEstate => 'Inm. Raíz';

  @override
  String get assetClassMediumRest => 'Resto';

  @override
  String get assetClassMediumStructuredProducts => 'Prod. Estr.';

  @override
  String get assetClassShortAlternativeInvestment => 'Invest. Alt.';

  @override
  String get assetClassShortAlts => 'Alt';

  @override
  String get assetClassShortAnnuities => 'Anual.';

  @override
  String get assetClassShortBonds => 'Bonos';

  @override
  String get assetClassShortCash => 'Efvo';

  @override
  String get assetClassShortDebentures => 'Dbnt';

  @override
  String get assetClassShortDerivatives => 'Deriv.';

  @override
  String get assetClassShortEquity => 'Ac';

  @override
  String get assetClassShortFixedIncome => 'RF';

  @override
  String get assetClassShortMutualFunds => 'FM';

  @override
  String get assetClassShortOthers => 'Otros';

  @override
  String get assetClassShortRealEstate => 'IR';

  @override
  String get assetClassShortRest => 'Resto';

  @override
  String get assetClassShortStructuredProducts => 'Prod. Estr.';

  @override
  String get commonButtonChange => 'Cambiar';

  @override
  String get commonSortBy => 'Ordenar por';

  @override
  String get historyChartBreadcrumbSeparator => ' > ';

  @override
  String get historyChartChangeRowSeparator => ' • ';

  @override
  String historyChartCommissionDataAsOf(String date) {
    return 'ⓘ Este gráfico se basa en los datos hasta el $date. Los importes de comisiones YTD son provisionales y están sujetos a validación pendiente.';
  }

  @override
  String historyChartDataAsOf(String date) {
    return 'ⓘ Este gráfico se basa en los datos hasta el $date.';
  }

  @override
  String get riskProfileConservative => 'Conservador';

  @override
  String get riskProfileGrowth => 'Crecimiento';

  @override
  String get riskProfileHighRisk => 'Riesgo Alto';

  @override
  String get riskProfileLowRisk => 'Riesgo Bajo';

  @override
  String get riskProfileModerate => 'Moderado';

  @override
  String get riskProfileModerateRisk => 'Riesgo Moderado';

  @override
  String get riskProfileModeratelyAggressive => 'Moderadamente Agresivo';

  @override
  String get riskProfileModeratelyConservative => 'Moderadamente Conservador';

  @override
  String get riskProfileSignificantRisk => 'Riesgo Significativo';

  @override
  String get riskProfileSpeculative => 'Especulativo';

  @override
  String get dashboardAssetAllocation => 'Asignación de Activos';

  @override
  String get dashboardAumLabel => 'AUM';

  @override
  String get dashboardByAum => '( Por AUM )';

  @override
  String get dashboardHeroYtdLabel => 'YTD';

  @override
  String dashboardHouseholdIdLabel(String code) {
    return 'ID Hogar: #$code';
  }

  @override
  String get dashboardQuickActionAccountMaintenance => 'Mantenimiento de Cuenta';

  @override
  String get dashboardQuickActionAssetMovement => 'Movimiento de Activos';

  @override
  String get dashboardQuickActionClientSearch => 'Buscar Cliente';

  @override
  String get dashboardQuickActionInvestorPortal => 'Portal del Inversor';

  @override
  String get dashboardQuickActionInvestorPortalLaunchFailedMessage =>
      'No se pudo abrir el Portal del Inversor. Inténtalo de nuevo.';

  @override
  String get dashboardQuickActionMeetingNotes => 'Notas de Reunión';

  @override
  String get dashboardQuickActionMyCommissions => 'Comisiones';

  @override
  String get dashboardQuickActionOnlineAccess => 'Acceso en Línea';

  @override
  String get dashboardQuickActionTasksDashboard => 'Panel de Tareas';

  @override
  String get dashboardRecentTransactions => 'Transacciones Recientes';

  @override
  String dashboardRecentTransactionsAsOf(String date) {
    return '( Al $date )';
  }

  @override
  String get dashboardTopHouseholds => 'Top 5 Hogares';

  @override
  String get dashboardTopHouseholdsShort => 'Top Hogares';

  @override
  String get dashboardTotalAum => 'AUM TOTAL';

  @override
  String get dashboardTotalCommissions => 'COMISIÓN TOTAL';

  @override
  String get dashboardTransactionDateToday => 'Hoy';

  @override
  String get dashboardTransactionDateYesterday => 'Ayer';

  @override
  String get dashboardViewAll => 'Ver Todo';

  @override
  String get dashboardViewTransactionHistory => 'Ver Historial de Transacciones';

  @override
  String get dashboardYtdChangeLabel => 'Cambio YTD';

  @override
  String get historyChartNoData => 'No hay datos disponibles para este período.';

  @override
  String get historyChartRangeCurrentMonth => 'Mes Actual';

  @override
  String get historyChartRangePastSixMonths => 'Últimos 6M';

  @override
  String get historyChartRangePastThreeMonths => 'Últimos 3M';

  @override
  String get historyChartRangeYtd => 'YTD';

  @override
  String historyChartWeekTooltip(int week, String date, String value) {
    return 'Comisión de la Semana$week $date es $value';
  }

  @override
  String get transactionTypeNonTrade => 'Sin Operación';

  @override
  String get viewTransactionsTypeBuy => 'Compra';

  @override
  String get viewTransactionsTypeSell => 'Venta';

  @override
  String get viewTransactionsTitle => 'Historial de Transacciones';

  @override
  String accountsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODAS LAS CUENTAS ($count)',
      one: 'TODA LA CUENTA ($count)',
      zero: 'TODA LA CUENTA ($count)',
    );
    return '$_temp0';
  }

  @override
  String accountsCustodianLabel(String name) {
    return 'Custodio : $name';
  }

  @override
  String get accountsFilterAll => 'Todos';

  @override
  String get accountsFilterHouseholdLinked => 'Vinculado al hogar';

  @override
  String get accountsFilterStandalone => 'Independiente';

  @override
  String accountsIdLabel(String number) {
    return 'Número de cuenta : $number';
  }

  @override
  String get accountsPaginationError => 'No se pudieron cargar más cuentas';

  @override
  String get commonName => 'Nombre';

  @override
  String get dashboardViewDetails => 'Ver Detalles';

  @override
  String accountDetailAccountNumberLabel(String number) {
    return 'Cuenta: $number';
  }

  @override
  String accountDetailAllHoldings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODAS LAS POSICIONES ($count)',
      one: 'TODA LA POSICIÓN ($count)',
      zero: 'TODA LA POSICIÓN ($count)',
    );
    return '$_temp0';
  }

  @override
  String get accountDetailAllTransactionsHeader => 'Últimas 30 Transacciones';

  @override
  String get accountDetailAssetAllocation => 'Asignación de activos';

  @override
  String get accountDetailAumTrend => 'Tendencia de AUM';

  @override
  String get accountDetailAumTrendEmpty => 'Aún no hay datos de tendencia de AUM';

  @override
  String get accountDetailHeroYtdLabel => 'YTD';

  @override
  String get accountDetailLatestActivity => 'Últimas actividades';

  @override
  String get accountDetailPositions => 'Posiciones';

  @override
  String get accountDetailPositionsEmptyFilter => 'No hay posiciones en esta clase de activos';

  @override
  String get accountDetailPositionsFilterAll => 'Todas las clases de activos';

  @override
  String get accountDetailRiskProfileLabel => 'Perfil de Riesgo:';

  @override
  String get accountDetailScreenTitle => 'Detalles de la cuenta';

  @override
  String get accountDetailTabOverview => 'Resumen';

  @override
  String get accountDetailTabTransactions => 'Transacciones';

  @override
  String get accountDetailToday => 'HOY';

  @override
  String get accountDetailTransactionsEmptySearch => 'Ninguna transacción coincide con tu búsqueda';

  @override
  String get accountDetailTransactionsSearchHint => 'Buscar';

  @override
  String get commonAmount => 'Monto';

  @override
  String get commonDate => 'Fecha';

  @override
  String get commonValue => 'Valor';

  @override
  String get transactionFilterAllTransactions => 'Todas las transacciones';

  @override
  String get transactionFilterNonTrade => 'No operaciones';

  @override
  String get transactionFilterTrade => 'Operaciones';

  @override
  String transactionPrice(String price) {
    return 'Precio: $price';
  }

  @override
  String viewTransactionsAssetClass(String assetClass) {
    return 'Clase de Activo: $assetClass';
  }

  @override
  String viewTransactionsDescription(String description) {
    return 'Descripción: $description';
  }

  @override
  String get viewTransactionsDetailClose => 'Cerrar';

  @override
  String get viewTransactionsDetailLabelAmount => 'Monto de Transacción';

  @override
  String get viewTransactionsDetailLabelAssetClass => 'Clase de Activo';

  @override
  String get viewTransactionsDetailLabelDate => 'Fecha de Transacción';

  @override
  String get viewTransactionsDetailLabelDescription => 'Descripción';

  @override
  String get viewTransactionsDetailLabelPricePerUnit => 'Precio Por Unidad';

  @override
  String get viewTransactionsDetailLabelQuantity => 'Cantidad';

  @override
  String get viewTransactionsDetailLabelTradeDetails => 'Detalles Adicionales';

  @override
  String get viewTransactionsDetailLabelTradeId => 'ID Operación';

  @override
  String get viewTransactionsDetailTitle => 'Detalles de Transacción';

  @override
  String viewTransactionsQuantity(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'Cantidad: $qtyString';
  }

  @override
  String viewTransactionsQuantityShort(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'Cant.: $qtyString';
  }

  @override
  String get viewTransactionsViewDetails => 'Ver Detalles';

  @override
  String get viewTransactionsEmpty => 'Ninguna transacción coincide con este filtro';

  @override
  String get viewTransactionsPaginationError => 'No se pudieron cargar más transacciones';

  @override
  String get viewTransactionsSearchHint => 'Buscar';

  @override
  String get viewTransactionsAllHeader => 'Últimas 30 Transacciones';

  @override
  String get accountsSearchHint => 'Buscar por cuenta...';

  @override
  String get householdsSearchHint => 'Buscar por hogar...';

  @override
  String get householdsTitle => 'Familias';

  @override
  String get householdsAccountsTabLabel => 'Cuentas';

  @override
  String householdsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODOS LOS HOGARES ($count)',
      one: 'TODO EL HOGAR ($count)',
      zero: 'TODO EL HOGAR ($count)',
    );
    return '$_temp0';
  }

  @override
  String householdsHouseholdIdLabel(String code) {
    return 'ID: $code';
  }

  @override
  String householdsTotalAccounts(int count) {
    return '$count Cuentas';
  }

  @override
  String get householdsPaginationError => 'No se pudieron cargar más hogares';

  @override
  String get householdDetailScreenTitle => 'Detalles del Hogar';

  @override
  String get householdDetailTabOverview => 'Resumen';

  @override
  String get householdDetailTabAccounts => 'Cuentas';

  @override
  String get householdDetailTabTransactions => 'Transacciones';

  @override
  String householdDetailSubtitle(String code, int count) {
    return '$code • $count Cuentas';
  }

  @override
  String get householdDetailTotalAum => 'AUM Total';

  @override
  String get householdDetailYtdPerformance => 'Cambio YTD';

  @override
  String get householdDetailAssetAllocation => 'Asignación de activos';

  @override
  String get householdDetailTopAccounts => 'Cuentas Principales';

  @override
  String householdDetailSeeAll(int count) {
    return 'Ver todos ($count)';
  }

  @override
  String householdDetailAccountTypeLabel(String type) {
    return 'Tipo de Cuenta: $type';
  }

  @override
  String householdDetailAccountNumberLabel(String number) {
    return 'Número de cuenta: $number';
  }

  @override
  String householdDetailAllAccountsHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODAS LAS CUENTAS ($count)',
      one: 'TODA LA CUENTA ($count)',
      zero: 'TODA LA CUENTA ($count)',
    );
    return '$_temp0';
  }

  @override
  String get householdDetailNoAccountsFound => 'No se encontraron cuentas.';

  @override
  String get householdDetailAllTransactionsHeader => 'Últimas 30 Transacciones';

  @override
  String get householdDetailNoTransactionsFound => 'No se encontraron transacciones.';

  @override
  String get householdDetailTransactionsEmptySearch => 'Ninguna transacción coincide con tu búsqueda';

  @override
  String get householdDetailTransactionsSearchHint => 'Buscar';

  @override
  String get householdDetailToday => 'HOY';

  @override
  String get commonButtonContinue => 'Continuar';

  @override
  String get realTimeSelectAccountTitle => 'Seleccionar una cuenta financiera';

  @override
  String get realTimeSelectAccountSubtitle =>
      'Acceda a posiciones y transacciones en vivo de una cuenta. Los datos se obtienen directamente de la fuente y existen solo para Pershing tras seleccionar la cuenta.';

  @override
  String get realTimeSelectAccountLabel => 'Seleccionar número de cuenta';

  @override
  String get realTimeSelectAccountHint => 'Seleccionar número de cuenta';

  @override
  String get realTimeDetailedViewTitle => 'Vista detallada en tiempo real';

  @override
  String get realTimePositionsTab => 'Posiciones';

  @override
  String get realTimeTransactionsTab => 'Transacciones';

  @override
  String get realTimeChangeAccount => 'Cambiar';

  @override
  String get realTimeDelayNote =>
      'El flujo de mercado para posiciones y transacciones en tiempo real tiene un retraso de 15 min.';

  @override
  String realTimeCusipIdentifier(String cusip) {
    return 'IDENTIFICADOR CUSIP: $cusip';
  }

  @override
  String get realTimeMarketPriceLabel => 'PRECIO DE MERCADO';

  @override
  String get realTimeClosePriceLabel => 'PRECIO DE CIERRE';

  @override
  String get realTimeNoPositions => 'No se encontraron posiciones.';

  @override
  String get realTimeNoTransactions => 'No se encontraron transacciones.';

  @override
  String get realTimeSearchPositions => 'Buscar posiciones...';

  @override
  String get realTimeSearchTransactions => 'Buscar transacciones...';

  @override
  String realTimeAllHoldings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODAS LAS POSICIONES ($count)',
      one: 'TODA LA POSICIÓN ($count)',
      zero: 'TODA LA POSICIÓN ($count)',
    );
    return '$_temp0';
  }

  @override
  String realTimeAllTransactionsHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todas las Transacciones',
      one: 'Todas las Transacciones',
      zero: 'Todas las Transacciones',
    );
    return '$_temp0 ($count)';
  }

  @override
  String get realTimeAccountActivityLabel => 'DESCRIPCIÓN DE LA ACTIVIDAD';

  @override
  String get serviceRequestNewButton => 'Nueva Solicitud de Servicio';

  @override
  String get serviceRequestSearchHint => 'Buscar por nombre o código...';

  @override
  String get serviceRequestFilterAll => 'Todas';

  @override
  String get serviceRequestFilterActive => 'Abiertas';

  @override
  String get serviceRequestFilterClosed => 'Cerradas';

  @override
  String serviceRequestHeadingAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todas las Solicitudes de Servicio ($count)',
      one: 'Toda la Solicitud de Servicio ($count)',
      zero: 'Toda la Solicitud de Servicio ($count)',
    );
    return '$_temp0';
  }

  @override
  String serviceRequestHeadingActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solicitudes de Servicio Abiertas ($count)',
      one: 'Solicitud de Servicio Abierta ($count)',
      zero: 'Solicitud de Servicio Abierta ($count)',
    );
    return '$_temp0';
  }

  @override
  String serviceRequestHeadingClosed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solicitudes de Servicio Cerradas ($count)',
      one: 'Solicitud de Servicio Cerrada ($count)',
      zero: 'Solicitud de Servicio Cerrada ($count)',
    );
    return '$_temp0';
  }

  @override
  String get serviceRequestSectionActive => 'Abiertas';

  @override
  String get serviceRequestSectionClosed => 'Cerradas';

  @override
  String get serviceRequestEmpty => 'No se encontraron solicitudes de servicio';

  @override
  String get serviceRequestEmptySearch => 'No hay solicitudes de servicio que coincidan';

  @override
  String get serviceRequestView => 'Ver';

  @override
  String get serviceRequestDateToday => 'Hoy';

  @override
  String get serviceRequestDateYesterday => 'Ayer';

  @override
  String get serviceRequestDateTomorrow => 'Mañana';

  @override
  String get serviceRequestDetailFinancialAccountLabel => 'Número de Cuenta :';

  @override
  String get serviceRequestDetailFinancialAccountTypeLabel => 'Tipo de Cuenta :';

  @override
  String get serviceRequestDetailRecordId => 'ID SR :';

  @override
  String get serviceRequestDetailStatus => 'Estado Actual';

  @override
  String get serviceRequestDetailActionPending => 'Acción Pendiente';

  @override
  String get serviceRequestDetailNoPendingAction => 'Sin acción pendiente';

  @override
  String get serviceRequestDetailDueDateLabel => 'Fecha de Vencimiento :';

  @override
  String get serviceRequestDetailWorkflowStatus => 'Estado del Flujo de Trabajo';

  @override
  String get serviceRequestDetailStepSubmitted => 'Enviado';

  @override
  String get serviceRequestDetailStepCompleted => 'Completado';

  @override
  String get serviceRequestDetailOwner => 'Propietario';

  @override
  String get serviceRequestDetailAssignedTo => 'Asignado A';

  @override
  String get serviceRequestDetailDueDate => 'Fecha de Vencimiento';

  @override
  String get serviceRequestDetailComments => 'Comentarios';

  @override
  String get serviceRequestDetailViewMore => 'Ver más';

  @override
  String get serviceRequestDetailClose => 'Cerrar';

  @override
  String get serviceRequestSuccessTitle => 'Solicitud Enviada';

  @override
  String get serviceRequestSuccessRecordLabel => 'Tu ID de solicitud de servicio';

  @override
  String get serviceRequestSuccessConfirmation => 'Creada exitosamente';

  @override
  String get serviceRequestSuccessCopied => 'ID de registro copiado al portapapeles';

  @override
  String get serviceRequestSuccessRedirectPrefix =>
      'Serás redirigido a la página de Inicio de Solicitudes de Servicio en ';

  @override
  String get serviceRequestSuccessRedirectSuffix => 's.';

  @override
  String get serviceRequestSuccessGoButton => 'Ir a Solicitud de Servicio';
}
