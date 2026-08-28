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

  @override
  String get commonInvalidEmail => 'Informe um endereço de e-mail válido.';

  @override
  String commonInvalidMobileNumber(int min, int max) {
    return 'Deve ter entre $min e $max dígitos.';
  }

  @override
  String get commonInvalidPostalCode => 'Informe um código postal válido.';

  @override
  String commonMaxLengthExceeded(int max) {
    return 'Máximo de $max caracteres permitidos.';
  }

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName é obrigatório !';
  }

  @override
  String get authLoginTitle => 'Bem-vindo de volta';

  @override
  String get authLoginSubtitle => 'Entre no seu espaço de assessor.';

  @override
  String get authIdentifierLabel => 'Usuário ou e-mail';

  @override
  String get authIdentifierHint => 'ex.: daniel.alvarez';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authPasswordHint => 'Digite sua senha';

  @override
  String get authShowPassword => 'Mostrar senha';

  @override
  String get authHidePassword => 'Ocultar senha';

  @override
  String get authLoginButton => 'Entrar';

  @override
  String get authSignOutButton => 'Sair';

  @override
  String get authInvalidCredentials => 'Usuário ou senha incorretos.';

  @override
  String get validationIdentifierRequired => 'Informe seu usuário ou e-mail.';

  @override
  String get validationPasswordRequired => 'Informe sua senha.';

  @override
  String get accessDeniedTitle => 'Acesso negado';

  @override
  String get accessDeniedMessage => 'Seu perfil não tem acesso a esta área.';

  @override
  String get accessDeniedBackButton => 'Voltar ao início';

  @override
  String get navHome => 'Início';

  @override
  String get navHouseholds => 'Famílias';

  @override
  String get navRealTime => 'Tempo real';

  @override
  String get navServiceRequests => 'Solicitações';

  @override
  String get navCommissions => 'Comissões';

  @override
  String get navInsights => 'Insights';

  @override
  String get roleAdvisor => 'Assessor';

  @override
  String get roleLeadership => 'Liderança';

  @override
  String comingSoonTitle(String tab) {
    return '$tab está a caminho';
  }

  @override
  String get comingSoonMessage => 'Esta aba já está conectada e aguarda suas telas.';

  @override
  String dashboardGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String dashboardSessionSummary(String role, String advisorId) {
    return 'Sessão iniciada como $role · assessor $advisorId';
  }
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

  @override
  String get commonInvalidEmail => 'Informe um endereço de e-mail válido.';

  @override
  String commonInvalidMobileNumber(int min, int max) {
    return 'Deve ter entre $min e $max dígitos.';
  }

  @override
  String get commonInvalidPostalCode => 'Informe um código postal válido.';

  @override
  String commonMaxLengthExceeded(int max) {
    return 'Máximo de $max caracteres permitidos.';
  }

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName é obrigatório !';
  }

  @override
  String get authLoginTitle => 'Bem-vindo de volta';

  @override
  String get authLoginSubtitle => 'Entre no seu espaço de assessor.';

  @override
  String get authIdentifierLabel => 'Usuário ou e-mail';

  @override
  String get authIdentifierHint => 'ex.: daniel.alvarez';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authPasswordHint => 'Digite sua senha';

  @override
  String get authShowPassword => 'Mostrar senha';

  @override
  String get authHidePassword => 'Ocultar senha';

  @override
  String get authLoginButton => 'Entrar';

  @override
  String get authSignOutButton => 'Sair';

  @override
  String get authInvalidCredentials => 'Usuário ou senha incorretos.';

  @override
  String get validationIdentifierRequired => 'Informe seu usuário ou e-mail.';

  @override
  String get validationPasswordRequired => 'Informe sua senha.';

  @override
  String get accessDeniedTitle => 'Acesso negado';

  @override
  String get accessDeniedMessage => 'Seu perfil não tem acesso a esta área.';

  @override
  String get accessDeniedBackButton => 'Voltar ao início';

  @override
  String get navHome => 'Início';

  @override
  String get navHouseholds => 'Famílias';

  @override
  String get navRealTime => 'Tempo real';

  @override
  String get navServiceRequests => 'Solicitações';

  @override
  String get navCommissions => 'Comissões';

  @override
  String get navInsights => 'Insights';

  @override
  String get roleAdvisor => 'Assessor';

  @override
  String get roleLeadership => 'Liderança';

  @override
  String comingSoonTitle(String tab) {
    return '$tab está a caminho';
  }

  @override
  String get comingSoonMessage => 'Esta aba já está conectada e aguarda suas telas.';

  @override
  String dashboardGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String dashboardSessionSummary(String role, String advisorId) {
    return 'Sessão iniciada como $role · assessor $advisorId';
  }
}
