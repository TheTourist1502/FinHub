// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'FinHub';

  @override
  String get errorNetwork => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String errorServer(String statusCode) {
    return 'Erro no servidor ($statusCode). Por favor, tente novamente mais tarde.';
  }

  @override
  String get errorUnauthorized => 'Sua sessão expirou. Por favor, faça login novamente.';

  @override
  String get errorForbidden => 'Você não tem permissão para realizar esta ação.';

  @override
  String get errorNotFound => 'O recurso solicitado não foi encontrado.';

  @override
  String get errorUnknown => 'Ocorreu um erro inesperado. Por favor, tente novamente.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'FinHub';

  @override
  String get errorNetwork => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String errorServer(String statusCode) {
    return 'Erro no servidor ($statusCode). Por favor, tente novamente mais tarde.';
  }

  @override
  String get errorUnauthorized => 'Sua sessão expirou. Por favor, faça login novamente.';

  @override
  String get errorForbidden => 'Você não tem permissão para realizar esta ação.';

  @override
  String get errorNotFound => 'O recurso solicitado não foi encontrado.';

  @override
  String get errorUnknown => 'Ocorreu um erro inesperado. Por favor, tente novamente.';
}
