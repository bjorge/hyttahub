part of 'cloud_functions_bloc.dart';

abstract class CloudFunctionsState extends Equatable {
  const CloudFunctionsState();

  @override
  List<Object> get props => [];
}

class CloudFunctionsInitial extends CloudFunctionsState {}

class CloudFunctionsLoading extends CloudFunctionsState {}

class ExportSuccess extends CloudFunctionsState {
  final String message;

  const ExportSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ExportListSuccess extends CloudFunctionsState {
  final List<ExportFile> files;

  const ExportListSuccess(this.files);

  @override
  List<Object> get props => [files];
}

class ExportDeleteSuccess extends CloudFunctionsState {}

class ExportDetailsSuccess extends CloudFunctionsState {
  final String events;

  const ExportDetailsSuccess(this.events);

  @override
  List<Object> get props => [events];
}

class CloudFunctionsFailure extends CloudFunctionsState {
  final String error;

  const CloudFunctionsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ExportFile extends Equatable {
  final String name;
  final String url;

  const ExportFile({required this.name, required this.url});

  factory ExportFile.fromMap(Map<String, dynamic> map) {
    return ExportFile(name: map['name'] as String, url: map['url'] as String);
  }

  @override
  List<Object> get props => [name, url];
}
