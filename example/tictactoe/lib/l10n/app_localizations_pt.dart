// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_unexpectedError =>
      'Erro inesperado; verifique a internet, volte e tente novamente';

  @override
  String get app_appTitle => 'Exemplo de formulário do Hytta Hub';

  @override
  String get app_nightMode => 'Modo noturno';

  @override
  String get app_themeSettingsAlwaysOff => 'Sempre desativado';

  @override
  String get app_themeSettingsAlwaysOn => 'Sempre ativado';

  @override
  String get app_themeSettingsAutomatic => 'Automático';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versão $appVersion-$appBuildNumber';
  }

  @override
  String get app_selectLanguage => 'Selecionar idioma';

  @override
  String get app_english => 'Inglês';

  @override
  String get app_italian => 'Italiano';

  @override
  String get app_spanish => 'Espanhol';

  @override
  String get app_norwegian => 'Norueguês';

  @override
  String get app_dutch => 'Holandês';

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_serviceLoginButton => 'Login do serviço';

  @override
  String get app_permissionDenied =>
      'Você não tem permissão para realizar esta ação.';

  @override
  String get app_appEventsOption => 'Eventos do aplicativo';

  @override
  String app_eventMove(int player, int x, int y) {
    return 'O jogador $player moveu para ($x, $y)';
  }

  @override
  String app_eventStartGame(String vsBot) {
    return 'Partida iniciada (contra o bot: $vsBot)';
  }

  @override
  String get app_eventPlayAgain => 'Jogar novamente';

  @override
  String get app_draw => 'Empate!';

  @override
  String app_playerWins(String name) {
    return '$name venceu!';
  }

  @override
  String get app_startMultiplayerGame => 'Iniciar partida multijogador';

  @override
  String get app_startBotGame => 'Iniciar partida contra o bot';

  @override
  String app_playerYou(String name) {
    return '$name (você)';
  }

  @override
  String get app_botName => 'Bot';

  @override
  String app_unknownPlayer(int id) {
    return 'Desconhecido ($id)';
  }

  @override
  String app_submissionErrorSnack(String errorCode) {
    return 'Erro no envio: $errorCode';
  }

  @override
  String get app_appSpecificEvent => 'Evento específico do aplicativo';

  @override
  String get app_appEventsTitle => 'Eventos do aplicativo';

  @override
  String get app_appStateTitle => 'Estado do aplicativo';

  @override
  String get app_platformLabel => 'Plataforma';
}
