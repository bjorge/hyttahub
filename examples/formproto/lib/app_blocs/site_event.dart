part of 'site_bloc.dart';

abstract class SiteEvent extends Equatable {
  const SiteEvent();

  @override
  List<Object> get props => [];
}

class SiteTextChanged extends SiteEvent {
  const SiteTextChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

class SiteSubmittedChanged extends SiteEvent {
  const SiteSubmittedChanged(this.submitted);

  final bool submitted;

  @override
  List<Object> get props => [submitted];
}

class _SiteDocumentChanged extends SiteEvent {
  const _SiteDocumentChanged(this.form);

  final FormModel form;

  @override
  List<Object> get props => [form];
}
