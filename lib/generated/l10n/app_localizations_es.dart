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
}
