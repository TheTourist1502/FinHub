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
}
