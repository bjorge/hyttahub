// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String app_submissionError(Object error) {
    return 'Erro no envio: $error';
  }

  @override
  String get app_unexpectedError =>
      'Erro inesperado; verifique a internet, volte e tente novamente';

  @override
  String get app_appTitle => 'Exemplo de formulário do Hytta Hub';

  @override
  String app_versionInfo(String appVersion, int appBuildNumber) {
    return 'Versão $appVersion-$appBuildNumber';
  }

  @override
  String get app_enterButton => 'Entrar';

  @override
  String get app_pickPhotosButton => 'Escolher fotos';

  @override
  String get app_permissionDenied =>
      'Você não tem permissão para realizar esta ação.';

  @override
  String get app_appEventsOption => 'Eventos do aplicativo';

  @override
  String get app_editModeTitle => 'Modo de edição';

  @override
  String get app_adminPrivileges =>
      'Você tem privilégios de administrador neste hub.';

  @override
  String get app_howToProceed => 'Como deseja continuar?';

  @override
  String get app_viewSite => 'Ver';

  @override
  String get app_editSite => 'Editar';

  @override
  String app_eventUpdateText(String value) {
    return 'Texto atualizado: $value';
  }

  @override
  String get app_eventUpdateCode => 'Código atualizado';

  @override
  String app_eventUpdateCheckbox(String value) {
    return 'Caixa de seleção atualizada: $value';
  }

  @override
  String app_eventUpdateDropdown(String value) {
    return 'Lista suspensa atualizada: $value';
  }

  @override
  String get app_eventUpdateList => 'Lista atualizada';

  @override
  String app_eventUpdatePhoto(String name) {
    return 'Foto atualizada: $name';
  }

  @override
  String get app_eventRemovePhoto => 'Foto removida';

  @override
  String get app_labelText => 'Texto';

  @override
  String get app_labelCode => 'Código';

  @override
  String get app_labelCheckbox => 'Caixa de seleção';

  @override
  String get app_labelDropdown => 'Lista suspensa';

  @override
  String get app_labelList => 'Lista';

  @override
  String get app_labelPhoto => 'Foto';

  @override
  String get app_reorderList => 'Reordenar lista';

  @override
  String app_updateLabel(String label) {
    return 'Atualizar $label';
  }

  @override
  String get app_noPhoto => 'Nenhuma foto';

  @override
  String get app_selectedPhoto => 'Foto selecionada';

  @override
  String get app_deletePhoto => 'Apagar foto';

  @override
  String get app_deletePhotoTitle => 'Apagar foto';

  @override
  String get app_deletePhotoConfirmation => 'Confirme que deseja apagar a foto';

  @override
  String get app_appSpecificEvent => 'Evento específico do aplicativo';

  @override
  String get app_updateTextTitle => 'Atualizar texto';

  @override
  String get app_textValueLabel => 'Valor do texto';

  @override
  String get app_updateCheckboxTitle => 'Atualizar caixa de seleção';

  @override
  String get app_checkboxValueLabel => 'Valor da caixa de seleção';

  @override
  String get app_updateCodeTitle => 'Atualizar código';

  @override
  String get app_codeValueLabel => 'Valor do código';

  @override
  String get app_updateDropdownTitle => 'Atualizar lista suspensa';

  @override
  String get app_dropdownValueLabel => 'Valor da lista suspensa';

  @override
  String get app_dropdownOption1 => 'Opção 1';

  @override
  String get app_dropdownOption2 => 'Opção 2';

  @override
  String get app_updateListTitle => 'Atualizar lista';

  @override
  String get app_reorderableListLabel => 'Lista reordenável';

  @override
  String get app_updatePhotoTitle => 'Atualizar foto';

  @override
  String get app_appEventsTitle => 'Eventos do aplicativo';

  @override
  String get app_appStateTitle => 'Estado do aplicativo';
}
