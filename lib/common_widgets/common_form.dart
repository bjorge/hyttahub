// Copyright (c) 2025 bjorge

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

abstract class BaseTextFormField<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends StatefulWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;

  const BaseTextFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    this.obscureText,
    this.maxLines = 1,
    this.suffixIcon,
    required this.eventFactory,
  });

  @override
  State<BaseTextFormField<B, E, T>> createState() =>
      _BaseTextFormFieldState<B, E, T>();

  /// Implement in subclasses to extract the field's value from the payload.
  String getValueFromPayload(T payload);

  /// Implement in subclasses to update the payload with the new value.
  T updatePayload(T originalPayload, String newValue);

  /// Implement in subclasses to provide validation logic.
  String? validator(BuildContext context, String value);
}

class _BaseTextFormFieldState<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends State<BaseTextFormField<B, E, T>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final payload = context.read<B>().state.payload;
    _controller = TextEditingController(
      text: payload != null ? widget.getValueFromPayload(payload) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, BaseSubmitState<T>>(
      listener: (context, state) {
        final newText = widget.getValueFromPayload(state.payload!);
        if (_controller.text != newText) {
          // Using .text directly resets the selection to the end, preventing
          // range errors when the text is shortened (e.g., by trim()).
          // Using copyWith() preserves the old selection, which can be invalid.
          _controller.text = newText;
        }
      },
      buildWhen: (previous, current) =>
          previous.submissionState.state != current.submissionState.state,
      builder: (context, state) {
        final readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _controller,
            maxLines: widget.maxLines,
            obscureText: widget.obscureText ?? false,
            readOnly: readOnly,
            style: readOnly
                ? Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey)
                : Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: widget.labelText,
              suffixIcon: widget.suffixIcon,
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String value) {
              final isFormCurrentlyValid =
                  widget.formKey.currentState?.validate() ?? false;

              final currentPayload = context.read<B>().state.payload!;
              final updatedPayload = widget.updatePayload(
                currentPayload,
                value,
              );

              final event = widget.eventFactory(
                updatedPayload: updatedPayload,
                submission: CommonSubmitBlocEvent(
                  isFormValid: isFormCurrentlyValid,
                ),
              );
              context.read<B>().add(event);
            },
            validator: (value) {
              final localizations = HyttaHubLocalizations.of(context)!;
              if (value != null && value.contains(RegExp(r'[\[\]]'))) {
                return localizations.disallowedCharactersError;
              }

              if (value != null &&
                  value.trim().isNotEmpty &&
                  value.trim().length != value.length) {
                return localizations.leadingTrailingSpacesError;
              }
              return widget.validator(context, value ?? '');
            },
          ),
        );
      },
    );
  }
}

abstract class BaseCodeFormField<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends StatefulWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;

  const BaseCodeFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.eventFactory,
  });

  @override
  State<BaseCodeFormField<B, E, T>> createState() =>
      BaseCodeFormFieldState<B, E, T>();

  /// Implement in subclasses to extract the field's value from the payload.
  String getValueFromPayload(T payload);

  /// Implement in subclasses to update the payload with the new value.
  T updatePayload(T originalPayload, String newValue);

  /// Implement in subclasses to provide validation logic.
  String? validator(BuildContext context, String value);
}

class BaseCodeFormFieldState<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends State<BaseCodeFormField<B, E, T>> {
  String _code = '';
  bool _didInit = false;
  String? _errorText;

  final List<String> gridItems = [
    '1',
    '2',
    '3',
    'A',
    '4',
    '5',
    '6',
    'B',
    '7',
    '8',
    '9',
    'C',
    'D',
    'E',
    'F',
    'G',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final payload = context.read<B>().state.payload;
      if (payload != null) {
        _code = widget.getValueFromPayload(payload);
      }
      _errorText = widget.validator(context, _code);
      _didInit = true;
    }
  }

  void _updateCodeAndNotifyBloc(String newCode) {
    if (_code == newCode) return;

    setState(() {
      _code = newCode;
      _errorText = widget.validator(context, _code);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isFormCurrentlyValid =
          widget.formKey.currentState?.validate() ?? false;

      final currentPayload = context.read<B>().state.payload!;
      final updatedPayload = widget.updatePayload(currentPayload, _code);

      final event = widget.eventFactory(
        updatedPayload: updatedPayload,
        submission: CommonSubmitBlocEvent(isFormValid: isFormCurrentlyValid),
      );
      context.read<B>().add(event);
    });
  }

  void _onGridButtonPressed(String value) {
    if (_code.length < 8) {
      _updateCodeAndNotifyBloc(_code + value);
    }
  }

  void _onBackspace() {
    if (_code.isNotEmpty) {
      _updateCodeAndNotifyBloc(_code.substring(0, _code.length - 1));
    }
  }

  void backspace() => _onBackspace();

  void paste(String value) {
    final upperValue = value.toUpperCase().replaceAll(RegExp(r'[^1-9A-G]'), '');
    final finalValue = upperValue.length > 8
        ? upperValue.substring(0, 8)
        : upperValue;
    _updateCodeAndNotifyBloc(finalValue);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, BaseSubmitState<T>>(
      listener: (context, state) {
        final newCode = widget.getValueFromPayload(state.payload!);
        if (_code != newCode) {
          setState(() {
            _code = newCode;
            _errorText = widget.validator(context, _code);
          });
        }
      },
      buildWhen: (previous, current) =>
          previous.submissionState.state != current.submissionState.state,
      builder: (context, state) {
        final readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // This hidden TextFormField is to hook into the Form's validation
                  SizedBox(
                    height: 0,
                    width: 0,
                    child: TextFormField(
                      key: ValueKey(_code), // To rebuild on code change
                      initialValue: _code,
                      enabled: false,
                      validator: (value) {
                        return widget.validator(context, value ?? '');
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                    ),
                  ),
                  Text(
                    widget.labelText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _errorText != null
                            ? Theme.of(context).colorScheme.error
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _code.padRight(8, '_'),
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8.0,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: gridItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: readOnly
                            ? null
                            : () => _onGridButtonPressed(gridItems[index]),
                        child: Text(
                          gridItems[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

abstract class BaseCheckboxFormField<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends StatefulWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;
  final bool showErrorMessage;

  const BaseCheckboxFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.eventFactory,
    this.showErrorMessage = false,
  });

  @override
  State<BaseCheckboxFormField<B, E, T>> createState() =>
      _BaseCheckboxFormFieldState<B, E, T>();

  /// Implement in subclasses to extract the field's value from the payload.
  bool getValueFromPayload(T payload);

  /// Implement in subclasses to update the payload with the new value.
  T updatePayload(T originalPayload, bool newValue);

  /// Implement in subclasses to provide validation logic.
  String? validator(BuildContext context, bool value);
}

class _BaseCheckboxFormFieldState<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends State<BaseCheckboxFormField<B, E, T>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, BaseSubmitState<T>>(
      builder: (context, state) {
        final bool currentValue = widget.getValueFromPayload(state.payload!);
        final bool readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return FormField<bool>(
          key: ValueKey(currentValue),
          initialValue: currentValue,
          autovalidateMode: AutovalidateMode.always,
          validator: (value) => widget.validator(context, value ?? false),
          builder: (formFieldState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: Text(widget.labelText),
                    value: currentValue,
                    onChanged: readOnly
                        ? null
                        : (bool? value) {
                            if (value != null) {
                              formFieldState.didChange(value);
                              final isFormCurrentlyValid =
                                  widget.formKey.currentState?.validate() ??
                                  false;

                              final originalPayload = state.payload!;
                              final updatedPayload = widget.updatePayload(
                                originalPayload,
                                value,
                              );

                              context.read<B>().add(
                                widget.eventFactory(
                                  updatedPayload: updatedPayload,
                                  submission: CommonSubmitBlocEvent(
                                    isFormValid: isFormCurrentlyValid,
                                  ),
                                ),
                              );
                            }
                          },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: formFieldState.hasError
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                  if (formFieldState.hasError && widget.showErrorMessage)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        formFieldState.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

abstract class BaseConfirmationCheckbox<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends StatelessWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;

  const BaseConfirmationCheckbox({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.eventFactory,
  });

  @override
  Widget build(BuildContext context) {
    // Override build to control form validity based on checkbox state.
    return BlocBuilder<B, BaseSubmitState<T>>(
      builder: (context, state) {
        final bool readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CheckboxListTile(
            title: Text(labelText),
            // The `isFormValid` property is not part of the state, but an event
            // property. The BLoC uses it to transition between `ready` and
            // `canSubmit`. So, we check the state to determine the value.
            value:
                state.submissionState.state ==
                CommonSubmitBlocState_State.canSubmit,
            onChanged: readOnly
                ? null
                : (bool? boxValue) {
                    final value = boxValue ?? false;
                    // if (kDebugMode) {
                    //   print(
                    //     "Checkbox value is ${value ? 'checked' : 'unchecked'}",
                    //   );
                    // }

                    context.read<B>().add(
                      eventFactory(
                        submission: CommonSubmitBlocEvent(isFormValid: value),
                      ),
                    );
                  },
          ),
        );
      },
    );
  }
}

/// A helper class to represent an item in a reorderable list.
class ReorderableItem {
  final int id;
  final String title;
  final Widget leading;

  const ReorderableItem({
    required this.id,
    required this.title,
    required this.leading,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReorderableItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

abstract class BaseReorderableFormField<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends StatefulWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;

  const BaseReorderableFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.eventFactory,
  });

  @override
  State<BaseReorderableFormField<B, E, T>> createState() =>
      _BaseReorderableFormFieldState<B, E, T>();

  /// Implement in subclasses to extract the list of items from the payload.
  List<ReorderableItem> getItemsFromPayload(BuildContext context, T payload);

  /// Implement in subclasses to update the payload with the new list of items.
  T updatePayload(T originalPayload, List<ReorderableItem> newItems);
}

class _BaseReorderableFormFieldState<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage
>
    extends State<BaseReorderableFormField<B, E, T>> {
  late List<ReorderableItem> _items;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final payload = context.read<B>().state.payload;
      _items = payload != null
          ? widget.getItemsFromPayload(context, payload)
          : [];
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, BaseSubmitState<T>>(
      listener: (context, state) {
        final newItems = widget.getItemsFromPayload(context, state.payload!);
        if (!listEquals(_items, newItems)) {
          setState(() {
            _items = newItems;
          });
        }
      },
      buildWhen: (previous, current) =>
          previous.submissionState.state != current.submissionState.state,
      builder: (context, state) {
        final readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListTile(
                key: Key('${item.id}'),
                leading: item.leading,
                title: Text(item.title),
                trailing: readOnly
                    ? null
                    : ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);

                final bloc = context.read<B>();
                final updatedPayload = widget.updatePayload(
                  bloc.state.payload!,
                  _items,
                );
                bloc.add(
                  widget.eventFactory(
                    updatedPayload: updatedPayload,
                    submission: CommonSubmitBlocEvent(
                      isFormValid:
                          widget.formKey.currentState?.validate() ?? false,
                    ),
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }
}

SnackBar commonSnackBar(
  BuildContext context,
  Text content, {
  int durationSeconds = 1,
}) {
  final localizations = HyttaHubLocalizations.of(context)!;

  return SnackBar(
    duration: Duration(seconds: durationSeconds),
    content: content,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height / 2,
      left: 20.0,
      right: 20.0,
    ),
    action: SnackBarAction(
      label: localizations.loginDismissSnackbar,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
}

abstract class BaseDropdownFormField<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage,
  V
>
    extends StatefulWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final E Function({
    T? updatedPayload,
    required CommonSubmitBlocEvent submission,
  })
  eventFactory;
  final List<DropdownMenuItem<V>> items;
  final V? value;
  final V? initialValue;

  const BaseDropdownFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.eventFactory,
    required this.items,
    this.value,
    this.initialValue,
  });

  @override
  State<BaseDropdownFormField<B, E, T, V>> createState() =>
      _BaseDropdownFormFieldState<B, E, T, V>();

  T updatePayload(T originalPayload, V? newValue);
  String? validator(BuildContext context, V? value);
  V? getValueFromPayload(T payload);
}

class _BaseDropdownFormFieldState<
  B extends BaseSubmitBloc<T>,
  E extends BaseSubmitEvent<T>,
  T extends GeneratedMessage,
  V
>
    extends State<BaseDropdownFormField<B, E, T, V>> {
  V? _currentValue;

  @override
  void initState() {
    super.initState();
    final payload = context.read<B>().state.payload;
    _currentValue = payload != null
        ? widget.getValueFromPayload(payload)
        : widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, BaseSubmitState<T>>(
      listener: (context, state) {
        final newValue = widget.getValueFromPayload(state.payload!);
        if (_currentValue != newValue) {
          setState(() {
            _currentValue = newValue;
          });
        }
      },
      buildWhen: (previous, current) =>
          previous.submissionState.state != current.submissionState.state,
      builder: (context, state) {
        final readOnly =
            !(state.submissionState.state ==
                    CommonSubmitBlocState_State.ready ||
                state.submissionState.state ==
                    CommonSubmitBlocState_State.canSubmit);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<V>(
            value: _currentValue,
            hint: Text(widget.labelText),
            items: widget.items,
            onChanged: readOnly
                ? null
                : (V? value) {
                    setState(() {
                      _currentValue = value;
                    });
                    final isFormCurrentlyValid =
                        widget.formKey.currentState?.validate() ?? false;

                    final currentPayload = context.read<B>().state.payload!;
                    final updatedPayload = widget.updatePayload(
                      currentPayload,
                      value,
                    );

                    final event = widget.eventFactory(
                      updatedPayload: updatedPayload,
                      submission: CommonSubmitBlocEvent(
                        isFormValid: isFormCurrentlyValid,
                      ),
                    );
                    context.read<B>().add(event);
                  },
            validator: (value) => widget.validator(context, value),
          ),
        );
      },
    );
  }
}

String? emailValidator(String elementValue, BuildContext context) {
  final value = elementValue.trim().toLowerCase();
  final localizations = HyttaHubLocalizations.of(context)!;
  if (value.isEmpty) {
    return localizations.loginEmailEmptyError;
  }

  if (value.toLowerCase() != elementValue) {
    return localizations.emailLowercaseError;
  }

  if (value.trim().length != elementValue.length) {
    return localizations.emailLeadingTrailingSpacesError;
  }

  if (value.length > 254) {
    return localizations.loginEmailTooLongError;
  }
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  if (!emailRegex.hasMatch(value)) {
    return localizations.loginEmailInvalidFormatError;
  }

  final firebaseReservedPattern = RegExp(r"^__.*__$");
  if (firebaseReservedPattern.hasMatch(value)) {
    return localizations.loginEmailReservedError;
  }

  return null;
}
