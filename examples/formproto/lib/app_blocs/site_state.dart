part of 'site_bloc.dart';

class FormModel extends Equatable {
  const FormModel({this.text = '', this.submitted = false});

  final String text;
  final bool submitted;

  FormModel copyWith({String? text, bool? submitted}) {
    return FormModel(
      text: text ?? this.text,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  List<Object> get props => [text, submitted];
}


class SiteState extends Equatable {
  const SiteState({this.form = const FormModel()});

  final FormModel form;

  SiteState copyWith({FormModel? form}) {
    return SiteState(
      form: form ?? this.form,
    );
  }

  @override
  List<Object> get props => [form];
}
