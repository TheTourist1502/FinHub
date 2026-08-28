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
}
