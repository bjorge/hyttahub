part of 'export_bloc.dart';

abstract class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object> get props => [];
}

class ExportInitial extends ExportState {}

class ExportLoading extends ExportState {}

class ExportSuccess extends ExportState {
  final String message;

  const ExportSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ExportListSuccess extends ExportState {
  final List<ExportFile> files;

  const ExportListSuccess(this.files);

  @override
  List<Object> get props => [files];
}

class ExportDeleteSuccess extends ExportState {}

class ExportDetailsSuccess extends ExportState {
  final String events;

  const ExportDetailsSuccess(this.events);

  @override
  List<Object> get props => [events];
}

class ExportFailure extends ExportState {
  final String error;

  const ExportFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ExportFile extends Equatable {
  final String name;
  final String url;

  const ExportFile({required this.name, required this.url});

  factory ExportFile.fromMap(Map<String, dynamic> map) {
    return ExportFile(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  @override
  List<Object> get props => [name, url];
}