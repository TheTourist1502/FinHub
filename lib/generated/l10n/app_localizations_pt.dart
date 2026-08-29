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

  @override
  String get appErrorWidgetEmptyDescription => 'Não há dados para mostrar no momento.';

  @override
  String get appErrorWidgetEmptyTitle => 'Ainda Não Há Nada Aqui';

  @override
  String get appErrorWidgetForbiddenDescription => 'Você não tem permissão para realizar esta ação.';

  @override
  String get appErrorWidgetForbiddenTitle => 'Acesso Negado';

  @override
  String get appErrorWidgetMaintenanceDescription =>
      'Este recurso está temporariamente indisponível enquanto fazemos melhorias.';

  @override
  String get appErrorWidgetMaintenanceTitle => 'Em Manutenção';

  @override
  String get appErrorWidgetNetworkDescription => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get appErrorWidgetNetworkTitle => 'Sem Conexão';

  @override
  String get appErrorWidgetNotFoundDescription => 'O item que você procura não existe ou foi movido.';

  @override
  String get appErrorWidgetNotFoundTitle => 'Não Encontrado';

  @override
  String get appErrorWidgetServerDescription => 'Algo deu errado do nosso lado. Tente novamente mais tarde.';

  @override
  String get appErrorWidgetServerTitle => 'Erro no Servidor';

  @override
  String get appErrorWidgetServiceUnavailableDescription =>
      'O serviço está temporariamente indisponível. Tente novamente em instantes.';

  @override
  String get appErrorWidgetServiceUnavailableTitle => 'Serviço Indisponível';

  @override
  String get appErrorWidgetTimeoutDescription => 'A solicitação demorou muito para responder. Tente novamente.';

  @override
  String get appErrorWidgetTimeoutTitle => 'Tempo Esgotado';

  @override
  String get appErrorWidgetUnauthorizedDescription => 'Sua sessão expirou. Faça login novamente.';

  @override
  String get appErrorWidgetUnauthorizedTitle => 'Sessão Expirada';

  @override
  String get appErrorWidgetUnknownDescription => 'Ocorreu um erro inesperado. Tente novamente.';

  @override
  String get appErrorWidgetUnknownTitle => 'Algo Deu Errado';

  @override
  String get appErrorWidgetValidationDescription =>
      'Algumas informações fornecidas não são válidas. Revise e tente novamente.';

  @override
  String get appErrorWidgetValidationTitle => 'Informações Inválidas';

  @override
  String get commonBrowseFile => 'Procurar Arquivo';

  @override
  String get commonButtonCancel => 'Cancelar';

  @override
  String get commonButtonClear => 'Limpar';

  @override
  String get commonButtonOk => 'OK';

  @override
  String get commonButtonRetry => 'Tentar novamente';

  @override
  String commonDuplicateFile(String fileName) {
    return 'Já existe um arquivo com $fileName.';
  }

  @override
  String get commonFilePickFailed => 'Não foi possível abrir o seletor de arquivos. Tente novamente.';

  @override
  String commonFileTooLarge(String limit) {
    return 'O arquivo deve ter menos de $limit.';
  }

  @override
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed) {
    String _temp0 = intl.Intl.pluralLogic(
      allowedCount,
      locale: localeName,
      other: 'Os tipos de arquivo permitidos são',
      one: 'O tipo de arquivo permitido é',
    );
    return 'O tipo de arquivo $rejected não é permitido. $_temp0 $allowed !';
  }

  @override
  String get commonInputHint => 'Digite...';

  @override
  String commonMaxFilesReached(int count) {
    return 'O número máximo de arquivos é $count.';
  }

  @override
  String get commonNoRecordFound => 'Nenhum registro encontrado!';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonSearchClear => 'Limpar pesquisa';

  @override
  String get commonUnsupportedFileType => 'Tipo de arquivo não compatível. Escolha um arquivo compatível.';

  @override
  String get commonUploadedDocumentsTitle => 'Documentos Enviados';

  @override
  String selectNSelected(int count) {
    return '$count selecionados';
  }

  @override
  String get selectSearchHint => 'Pesquisar…';

  @override
  String get statusApproved => 'Aprovado';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get statusEscalated => 'Escalado';

  @override
  String get statusInProgress => 'Em Andamento';

  @override
  String get statusNone => 'Nenhum';

  @override
  String get statusRejected => 'Rejeitado';

  @override
  String get allocationChartRoundingNote =>
      'ⓘ Os valores são arredondados para duas casas decimais e as porcentagens para uma casa decimal.';

  @override
  String get assetAllocationLabel => 'Alocação de Ativos';

  @override
  String get assetClassLongAlternativeInvestment => 'Investimento Alternativo';

  @override
  String get assetClassLongAlternativeInvestments => 'Investimentos Alternativos';

  @override
  String get assetClassLongAlts => 'Alternativos';

  @override
  String get assetClassLongAnnuities => 'Anuidades';

  @override
  String get assetClassLongBonds => 'Obrigações';

  @override
  String get assetClassLongCash => 'Caixa e Equivalentes';

  @override
  String get assetClassLongDebentures => 'Debêntures';

  @override
  String get assetClassLongDerivatives => 'Derivativos';

  @override
  String get assetClassLongEquity => 'Ações';

  @override
  String get assetClassLongFixedIncome => 'Renda Fixa';

  @override
  String get assetClassLongMutualFunds => 'Fundos Mútuos';

  @override
  String get assetClassLongOthers => 'Outros';

  @override
  String get assetClassLongRealEstate => 'Imóveis';

  @override
  String get assetClassLongRest => 'Restante';

  @override
  String get assetClassLongStructuredProducts => 'Produtos Estruturados';

  @override
  String get assetClassMediumAlternativeInvestment => 'Inv. Alt.';

  @override
  String get assetClassMediumAlternativeInvestments => 'Invs. Alt.';

  @override
  String get assetClassMediumAlts => 'Alt';

  @override
  String get assetClassMediumAnnuities => 'Anuidades';

  @override
  String get assetClassMediumBonds => 'Obrigações';

  @override
  String get assetClassMediumCash => 'Caixa';

  @override
  String get assetClassMediumDebentures => 'Debêntures';

  @override
  String get assetClassMediumDerivatives => 'Derivativos';

  @override
  String get assetClassMediumEquity => 'Ações';

  @override
  String get assetClassMediumFixedIncome => 'Renda Fixa';

  @override
  String get assetClassMediumMutualFunds => 'Fundos Mútuos';

  @override
  String get assetClassMediumOthers => 'Outros';

  @override
  String get assetClassMediumRealEstate => 'Imóveis';

  @override
  String get assetClassMediumRest => 'Restante';

  @override
  String get assetClassMediumStructuredProducts => 'Prod. Estrut.';

  @override
  String get assetClassShortAlternativeInvestment => 'Invest. Alt.';

  @override
  String get assetClassShortAlts => 'Alt';

  @override
  String get assetClassShortAnnuities => 'Anuid.';

  @override
  String get assetClassShortBonds => 'Obrig.';

  @override
  String get assetClassShortCash => 'Caixa';

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
  String get assetClassShortOthers => 'Outros';

  @override
  String get assetClassShortRealEstate => 'IM';

  @override
  String get assetClassShortRest => 'Restante';

  @override
  String get assetClassShortStructuredProducts => 'Prod. Estrut.';

  @override
  String get commonButtonChange => 'Alterar';

  @override
  String get commonSortBy => 'Ordenar por';

  @override
  String get historyChartBreadcrumbSeparator => ' > ';

  @override
  String get historyChartChangeRowSeparator => ' • ';

  @override
  String historyChartCommissionDataAsOf(String date) {
    return 'ⓘ Este gráfico é baseado nos dados até $date. Os valores de comissão YTD são provisórios e estão sujeitos a validação pendente.';
  }

  @override
  String historyChartDataAsOf(String date) {
    return 'ⓘ Este gráfico é baseado nos dados até $date.';
  }

  @override
  String get riskProfileConservative => 'Conservador';

  @override
  String get riskProfileGrowth => 'Crescimento';

  @override
  String get riskProfileHighRisk => 'Risco Alto';

  @override
  String get riskProfileLowRisk => 'Risco Baixo';

  @override
  String get riskProfileModerate => 'Moderado';

  @override
  String get riskProfileModerateRisk => 'Risco Moderado';

  @override
  String get riskProfileModeratelyAggressive => 'Moderadamente Agressivo';

  @override
  String get riskProfileModeratelyConservative => 'Moderadamente Conservador';

  @override
  String get riskProfileSignificantRisk => 'Risco Significativo';

  @override
  String get riskProfileSpeculative => 'Especulativo';
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

  @override
  String get appErrorWidgetEmptyDescription => 'Não há dados para mostrar no momento.';

  @override
  String get appErrorWidgetEmptyTitle => 'Ainda Não Há Nada Aqui';

  @override
  String get appErrorWidgetForbiddenDescription => 'Você não tem permissão para realizar esta ação.';

  @override
  String get appErrorWidgetForbiddenTitle => 'Acesso Negado';

  @override
  String get appErrorWidgetMaintenanceDescription =>
      'Este recurso está temporariamente indisponível enquanto fazemos melhorias.';

  @override
  String get appErrorWidgetMaintenanceTitle => 'Em Manutenção';

  @override
  String get appErrorWidgetNetworkDescription => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get appErrorWidgetNetworkTitle => 'Sem Conexão';

  @override
  String get appErrorWidgetNotFoundDescription => 'O item que você procura não existe ou foi movido.';

  @override
  String get appErrorWidgetNotFoundTitle => 'Não Encontrado';

  @override
  String get appErrorWidgetServerDescription => 'Algo deu errado do nosso lado. Tente novamente mais tarde.';

  @override
  String get appErrorWidgetServerTitle => 'Erro no Servidor';

  @override
  String get appErrorWidgetServiceUnavailableDescription =>
      'O serviço está temporariamente indisponível. Tente novamente em instantes.';

  @override
  String get appErrorWidgetServiceUnavailableTitle => 'Serviço Indisponível';

  @override
  String get appErrorWidgetTimeoutDescription => 'A solicitação demorou muito para responder. Tente novamente.';

  @override
  String get appErrorWidgetTimeoutTitle => 'Tempo Esgotado';

  @override
  String get appErrorWidgetUnauthorizedDescription => 'Sua sessão expirou. Faça login novamente.';

  @override
  String get appErrorWidgetUnauthorizedTitle => 'Sessão Expirada';

  @override
  String get appErrorWidgetUnknownDescription => 'Ocorreu um erro inesperado. Tente novamente.';

  @override
  String get appErrorWidgetUnknownTitle => 'Algo Deu Errado';

  @override
  String get appErrorWidgetValidationDescription =>
      'Algumas informações fornecidas não são válidas. Revise e tente novamente.';

  @override
  String get appErrorWidgetValidationTitle => 'Informações Inválidas';

  @override
  String get commonBrowseFile => 'Procurar Arquivo';

  @override
  String get commonButtonCancel => 'Cancelar';

  @override
  String get commonButtonClear => 'Limpar';

  @override
  String get commonButtonOk => 'OK';

  @override
  String get commonButtonRetry => 'Tentar novamente';

  @override
  String commonDuplicateFile(String fileName) {
    return 'Já existe um arquivo com $fileName.';
  }

  @override
  String get commonFilePickFailed => 'Não foi possível abrir o seletor de arquivos. Tente novamente.';

  @override
  String commonFileTooLarge(String limit) {
    return 'O arquivo deve ter menos de $limit.';
  }

  @override
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed) {
    String _temp0 = intl.Intl.pluralLogic(
      allowedCount,
      locale: localeName,
      other: 'Os tipos de arquivo permitidos são',
      one: 'O tipo de arquivo permitido é',
    );
    return 'O tipo de arquivo $rejected não é permitido. $_temp0 $allowed !';
  }

  @override
  String get commonInputHint => 'Digite...';

  @override
  String commonMaxFilesReached(int count) {
    return 'O número máximo de arquivos é $count.';
  }

  @override
  String get commonNoRecordFound => 'Nenhum registro encontrado!';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonSearchClear => 'Limpar pesquisa';

  @override
  String get commonUnsupportedFileType => 'Tipo de arquivo não compatível. Escolha um arquivo compatível.';

  @override
  String get commonUploadedDocumentsTitle => 'Documentos Enviados';

  @override
  String selectNSelected(int count) {
    return '$count selecionados';
  }

  @override
  String get selectSearchHint => 'Pesquisar…';

  @override
  String get statusApproved => 'Aprovado';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get statusEscalated => 'Escalado';

  @override
  String get statusInProgress => 'Em Andamento';

  @override
  String get statusNone => 'Nenhum';

  @override
  String get statusRejected => 'Rejeitado';

  @override
  String get allocationChartRoundingNote =>
      'ⓘ Os valores são arredondados para duas casas decimais e as porcentagens para uma casa decimal.';

  @override
  String get assetAllocationLabel => 'Alocação de Ativos';

  @override
  String get assetClassLongAlternativeInvestment => 'Investimento Alternativo';

  @override
  String get assetClassLongAlternativeInvestments => 'Investimentos Alternativos';

  @override
  String get assetClassLongAlts => 'Alternativos';

  @override
  String get assetClassLongAnnuities => 'Anuidades';

  @override
  String get assetClassLongBonds => 'Obrigações';

  @override
  String get assetClassLongCash => 'Caixa e Equivalentes';

  @override
  String get assetClassLongDebentures => 'Debêntures';

  @override
  String get assetClassLongDerivatives => 'Derivativos';

  @override
  String get assetClassLongEquity => 'Ações';

  @override
  String get assetClassLongFixedIncome => 'Renda Fixa';

  @override
  String get assetClassLongMutualFunds => 'Fundos Mútuos';

  @override
  String get assetClassLongOthers => 'Outros';

  @override
  String get assetClassLongRealEstate => 'Imóveis';

  @override
  String get assetClassLongRest => 'Restante';

  @override
  String get assetClassLongStructuredProducts => 'Produtos Estruturados';

  @override
  String get assetClassMediumAlternativeInvestment => 'Inv. Alt.';

  @override
  String get assetClassMediumAlternativeInvestments => 'Invs. Alt.';

  @override
  String get assetClassMediumAlts => 'Alt';

  @override
  String get assetClassMediumAnnuities => 'Anuidades';

  @override
  String get assetClassMediumBonds => 'Obrigações';

  @override
  String get assetClassMediumCash => 'Caixa';

  @override
  String get assetClassMediumDebentures => 'Debêntures';

  @override
  String get assetClassMediumDerivatives => 'Derivativos';

  @override
  String get assetClassMediumEquity => 'Ações';

  @override
  String get assetClassMediumFixedIncome => 'Renda Fixa';

  @override
  String get assetClassMediumMutualFunds => 'Fundos Mútuos';

  @override
  String get assetClassMediumOthers => 'Outros';

  @override
  String get assetClassMediumRealEstate => 'Imóveis';

  @override
  String get assetClassMediumRest => 'Restante';

  @override
  String get assetClassMediumStructuredProducts => 'Prod. Estrut.';

  @override
  String get assetClassShortAlternativeInvestment => 'Invest. Alt.';

  @override
  String get assetClassShortAlts => 'Alt';

  @override
  String get assetClassShortAnnuities => 'Anuid.';

  @override
  String get assetClassShortBonds => 'Obrig.';

  @override
  String get assetClassShortCash => 'Caixa';

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
  String get assetClassShortOthers => 'Outros';

  @override
  String get assetClassShortRealEstate => 'IM';

  @override
  String get assetClassShortRest => 'Restante';

  @override
  String get assetClassShortStructuredProducts => 'Prod. Estrut.';

  @override
  String get commonButtonChange => 'Alterar';

  @override
  String get commonSortBy => 'Ordenar por';

  @override
  String get historyChartBreadcrumbSeparator => ' > ';

  @override
  String get historyChartChangeRowSeparator => ' • ';

  @override
  String historyChartCommissionDataAsOf(String date) {
    return 'ⓘ Este gráfico é baseado nos dados até $date. Os valores de comissão YTD são provisórios e estão sujeitos a validação pendente.';
  }

  @override
  String historyChartDataAsOf(String date) {
    return 'ⓘ Este gráfico é baseado nos dados até $date.';
  }

  @override
  String get riskProfileConservative => 'Conservador';

  @override
  String get riskProfileGrowth => 'Crescimento';

  @override
  String get riskProfileHighRisk => 'Risco Alto';

  @override
  String get riskProfileLowRisk => 'Risco Baixo';

  @override
  String get riskProfileModerate => 'Moderado';

  @override
  String get riskProfileModerateRisk => 'Risco Moderado';

  @override
  String get riskProfileModeratelyAggressive => 'Moderadamente Agressivo';

  @override
  String get riskProfileModeratelyConservative => 'Moderadamente Conservador';

  @override
  String get riskProfileSignificantRisk => 'Risco Significativo';

  @override
  String get riskProfileSpeculative => 'Especulativo';
}
