// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'GoRoute';

  @override
  String get signIn => 'Entrar';

  @override
  String get signInSubtitle =>
      'Conta profissional · sessão armazenada com segurança no aparelho';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get signingIn => 'Entrando…';

  @override
  String get signOut => 'Sair';

  @override
  String get mfaTitle => 'Código de dois fatores';

  @override
  String get mfaHeadline => 'Digite o código do autenticador';

  @override
  String get mfaBody =>
      'Use o TOTP de 6 dígitos do app autenticador ou um código de backup.';

  @override
  String get code => 'Código';

  @override
  String get verify => 'Verificar';

  @override
  String get verifying => 'Verificando…';

  @override
  String get roadmapTitle => 'Trilha';

  @override
  String get progress => 'Progresso';

  @override
  String get nodes => 'Nós';

  @override
  String get etaWeeks => 'ETA (semanas)';

  @override
  String get nextFocus => 'Próximo foco';

  @override
  String get yourTrack => 'Sua trilha';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get loading => 'Carregando…';

  @override
  String get unexpectedError => 'Erro inesperado';

  @override
  String get connectionError =>
      'Não foi possível conectar ao servidor. Verifique o Wi‑Fi e se a API está no ar.';

  @override
  String get emptyTitle => 'Nada por aqui ainda';

  @override
  String get emptyBody =>
      'Quando houver conteúdo nesta seção, ele aparecerá aqui.';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get brandTagline => 'Planeje o próximo passo da carreira com clareza.';

  @override
  String get navHome => 'Início';

  @override
  String get navRoadmap => 'Trilha';

  @override
  String get navWeekly => 'Semana';

  @override
  String get navJobs => 'Vagas';

  @override
  String get navMore => 'Mais';

  @override
  String get homeSubtitle => 'Seu próximo passo de carreira, em um olhar.';

  @override
  String get homeNoNext => 'Nenhum nó recomendado ainda — abra sua trilha.';

  @override
  String get homeOpenNode => 'Abrir próximo marco';

  @override
  String get homeCtaRoadmap => 'Abrir trilha';

  @override
  String get homeCtaWeekly => 'Plano da semana';

  @override
  String get roadmapEmptyTitle => 'Nenhum nó na sua trilha';

  @override
  String get roadmapEmptyBody =>
      'Conclua o onboarding na web se a trilha estiver vazia.';

  @override
  String get nodeDetailTitle => 'Marco';

  @override
  String get nodeStateCompleted => 'Concluído';

  @override
  String get nodeStateInProgress => 'Em andamento';

  @override
  String get nodeStateAvailable => 'Disponível';

  @override
  String get nodeStateRecommended => 'Recomendado';

  @override
  String get nodeStateLocked => 'Bloqueado';

  @override
  String get nodeStateUnknown => 'Desconhecido';

  @override
  String get nodeLockedHint =>
      'Este marco está bloqueado. Conclua os pré-requisitos primeiro.';

  @override
  String get prerequisites => 'Pré-requisitos';

  @override
  String get startNode => 'Começar';

  @override
  String get completeNode => 'Marcar concluído';

  @override
  String get working => 'Trabalhando…';

  @override
  String get actionSuccess => 'Atualizado';

  @override
  String get nodeNoAction => 'Nenhuma ação disponível para este marco agora.';

  @override
  String get premiumRequired => 'O plano semanal exige assinatura ativa.';

  @override
  String get premiumRequiredTitle => 'Recurso premium';

  @override
  String get weeklyEmptyTitle => 'Sem plano semanal ainda';

  @override
  String get weeklyEmptyBody =>
      'Recalcule para gerar o foco e as tarefas desta semana.';

  @override
  String get completeTask => 'Feito';

  @override
  String get skipWeek => 'Pular esta semana';

  @override
  String get recalculateWeek => 'Recalcular';

  @override
  String get jobsEmptyTitle => 'Nenhuma vaga com match';

  @override
  String get jobsEmptyBody =>
      'Quando houver vagas publicadas alinhadas ao seu perfil, elas aparecem aqui.';

  @override
  String get jobDetailTitle => 'Vaga';

  @override
  String get jobSkills => 'Skills exigidas';

  @override
  String get whyThisMatch => 'Por que este %?';

  @override
  String get closingSkills => 'Skills para fechar o gap';

  @override
  String get applyJob => 'Candidatar';

  @override
  String get applySuccess => 'Candidatura enviada';

  @override
  String get jobApplyNotEligible =>
      'É necessário 100% de match para se candidatar.';

  @override
  String get mentorTitle => 'Mentor';

  @override
  String get mentorHint =>
      'Pergunte sobre o próximo passo, o que aprender ou no que focar.';

  @override
  String get mentorPlaceholder => 'Pergunte ao mentor…';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsEmptyTitle => 'Sem notificações';

  @override
  String get notificationsEmptyBody =>
      'Atualizações da trilha e ofertas aparecem aqui.';

  @override
  String get markAllRead => 'Marcar todas lidas';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get profileSection => 'Perfil';

  @override
  String get nameReadOnlyHint =>
      'Nome legal é gerido no billing / settings web.';

  @override
  String get headlineLabel => 'Headline';

  @override
  String get saveProfile => 'Salvar perfil';

  @override
  String get aiSection => 'Mentor IA';

  @override
  String get mentorModeLabel => 'Modo do mentor';

  @override
  String get mentorModeOff => 'Desligado';

  @override
  String get mentorModeManaged => 'Gerenciado (GoRoute)';

  @override
  String get mentorModeByok => 'BYOK';

  @override
  String get lgpdConsentLabel =>
      'Autorizo o processamento de dados de carreira por IA (LGPD).';

  @override
  String get byokWebHint =>
      'Cadastre a API key no settings web; no mobile só se troca o modo.';

  @override
  String get saveAi => 'Salvar IA';

  @override
  String get privacySection => 'Privacidade';

  @override
  String get exportPrivacy => 'Exportar meus dados';

  @override
  String get exportCopied => 'JSON de exportação copiado';

  @override
  String get eraseSection => 'Excluir conta';

  @override
  String get eraseBody =>
      'Isso apaga permanentemente sua conta. Digite DELETE para confirmar.';

  @override
  String get eraseConfirmLabel => 'Digite DELETE';

  @override
  String get eraseConfirmHint => 'Digite DELETE exatamente para confirmar.';

  @override
  String get eraseAccount => 'Apagar conta';

  @override
  String get jobsSearchHint => 'Buscar por título ou empresa';

  @override
  String get homeCtaJobs => 'Ver vagas';

  @override
  String get homeCtaMentor => 'Perguntar ao mentor';

  @override
  String get askMentor => 'Perguntar ao mentor';

  @override
  String get clearChat => 'Limpar chat';

  @override
  String get openInTrack => 'Abrir na trilha';

  @override
  String get viewPlans => 'Ver planos';

  @override
  String get premiumCtaBody =>
      'Faça upgrade na web para liberar o plano semanal.';

  @override
  String get connectionHelpTitle => 'Não conecta?';

  @override
  String get connectionHelpBody =>
      'Use o mesmo Wi‑Fi do computador e um APK debug com o IP LAN do PC (não o release de produção).';

  @override
  String get connectionTip =>
      'Dica: mesmo Wi‑Fi do PC · APK debug com IP LAN · API no ar.';

  @override
  String mentorPrefillNext(String label) {
    return 'No que devo focar em seguida para $label?';
  }

  @override
  String mentorPrefillNode(String label) {
    return 'Como avanço em $label?';
  }

  @override
  String mentorPrefillJob(String label) {
    return 'Como fecho o gap de skills para $label?';
  }

  @override
  String get aboutTitle => 'Sobre o GoRoute';

  @override
  String get asoTitle => 'GoRoute: Plano de Carreira';

  @override
  String get asoSubtitle => 'Trilha, skills e vagas com match';

  @override
  String get asoPromise =>
      'Veja o próximo passo concreto da carreira — trilha, semana e vagas com match — sem adivinhar sozinho o que estudar.';

  @override
  String get connectionHelpShort => 'Dicas de Wi‑Fi, APK debug e API';

  @override
  String get appearanceSection => 'Aparência';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeSystem => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSystem => 'Auto';

  @override
  String get languagePt => 'Português';

  @override
  String get languageEn => 'English';

  @override
  String get greetingMorning => 'Bom dia';

  @override
  String get greetingAfternoon => 'Boa tarde';

  @override
  String get greetingEvening => 'Boa noite';

  @override
  String get dashboardOverview => 'Painel da carreira';

  @override
  String get dashboardShortcuts => 'Atalhos';

  @override
  String get dashboardNodes => 'Marcos';

  @override
  String get sessionExpired =>
      'Sua sessão expirou. Entre de novo para continuar.';

  @override
  String get signInAgain => 'Entrar de novo';

  @override
  String get weeklyHeroTitle => 'Esta semana';

  @override
  String weeklyTasksDone(int done, int total) {
    return '$done de $total concluídas';
  }

  @override
  String get weeklyTip =>
      'Dica: faça o estudo primeiro e depois o projeto prático.';

  @override
  String get weeklyFocusSection => 'Foco da semana';

  @override
  String get weeklyChecklist => 'Checklist';

  @override
  String get weeklyActions => 'Ações da semana';

  @override
  String get taskTypeStudy => 'Estudo';

  @override
  String get taskTypeProject => 'Projeto';

  @override
  String get taskTypePractice => 'Prática';

  @override
  String get taskTypeOther => 'Tarefa';

  @override
  String get aboutWhatTitle => 'O que o GoRoute faz';

  @override
  String get aboutWhatBody =>
      'Transforma um objetivo de carreira em trilha com marcos, plano semanal executável, vagas com match e mentor para a próxima decisão.';

  @override
  String get aboutHowTitle => 'Como usar o app';

  @override
  String get aboutHow1 => 'Início — veja progresso e o próximo foco.';

  @override
  String get aboutHow2 => 'Trilha — abra marcos, inicie e conclua.';

  @override
  String get aboutHow3 => 'Semana — complete o checklist da semana.';

  @override
  String get aboutHow4 => 'Vagas — explore matches e feche gaps de skill.';

  @override
  String get aboutHow5 => 'Mais — mentor, notificações, tema e idioma.';

  @override
  String get aboutPrivacyTitle => 'Privacidade';

  @override
  String get aboutPrivacyBody =>
      'Seus dados ficam na sua sessão. Exporte ou apague em Configurações. Modos do mentor respeitam consentimento LGPD.';

  @override
  String aboutVersion(String version) {
    return 'Versão $version';
  }

  @override
  String nodeHours(int logged, int estimated) {
    return '$logged / $estimated h registradas';
  }

  @override
  String get nodeNotes => 'Notas';
}
