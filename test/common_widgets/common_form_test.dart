import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package.hyttahub/proto/common_blocs.pb.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSubmitBloc extends MockBloc<BaseSubmitEvent<CommonSubmitBlocState>,
    BaseSubmitState<CommonSubmitBlocState>> implements BaseSubmitBloc<CommonSubmitBlocState> {}

class MockSubmitEvent extends Mock
    implements BaseSubmitEvent<CommonSubmitBlocState> {}

class MyTextFormField
    extends BaseTextFormField<MockSubmitBloc, MockSubmitEvent, CommonSubmitBlocState> {
  MyTextFormField({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
        );

  @override
  String getValueFromPayload(CommonSubmitBlocState payload) {
    return '';
  }

  @override
  CommonSubmitBlocState updatePayload(
      CommonSubmitBlocState originalPayload, String newValue) {
    return originalPayload..deepCopy();
  }

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }
}

class MyCodeFormField extends BaseCodeFormField<MockSubmitBloc, MockSubmitEvent,
    CommonSubmitBlocState> {
  MyCodeFormField({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
        );

  @override
  String getValueFromPayload(CommonSubmitBlocState payload) {
    return '';
  }

  @override
  CommonSubmitBlocState updatePayload(
      CommonSubmitBlocState originalPayload, String newValue) {
    return originalPayload..deepCopy();
  }

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }
}

class MyCheckboxFormField extends BaseCheckboxFormField<MockSubmitBloc,
    MockSubmitEvent, CommonSubmitBlocState> {
  MyCheckboxFormField({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
        );

  @override
  bool getValueFromPayload(CommonSubmitBlocState payload) {
    return false;
  }

  @override
  CommonSubmitBlocState updatePayload(
      CommonSubmitBlocState originalPayload, bool newValue) {
    return originalPayload..deepCopy();
  }

  @override
  String? validator(BuildContext context, bool value) {
    return null;
  }
}

class MyConfirmationCheckbox extends BaseConfirmationCheckbox<MockSubmitBloc,
    MockSubmitEvent, CommonSubmitBlocState> {
  MyConfirmationCheckbox({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
        );
}

class MyReorderableFormField extends BaseReorderableFormField<MockSubmitBloc,
    MockSubmitEvent, CommonSubmitBlocState> {
  MyReorderableFormField({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
        );

  @override
  List<ReorderableItem> getItemsFromPayload(
      BuildContext context, CommonSubmitBlocState payload) {
    return [
      const ReorderableItem(id: 1, title: 'Item 1', leading: Icon(Icons.ac_unit)),
      const ReorderableItem(id: 2, title: 'Item 2', leading: Icon(Icons.ac_unit)),
    ];
  }

  @override
  CommonSubmitBlocState updatePayload(
      CommonSubmitBlocState originalPayload, List<ReorderableItem> newItems) {
    return originalPayload..deepCopy();
  }
}

class MyDropdownFormField extends BaseDropdownFormField<MockSubmitBloc,
    MockSubmitEvent, CommonSubmitBlocState, String> {
  MyDropdownFormField({
    required GlobalKey<FormState> formKey,
  }) : super(
          labelText: 'Test',
          formKey: formKey,
          eventFactory: ({
            updatedPayload,
            required submission,
          }) =>
              MockSubmitEvent(),
          items: const [
            DropdownMenuItem(value: '1', child: Text('Item 1')),
            DropdownMenuItem(value: '2', child: Text('Item 2')),
          ],
        );

  @override
  String? getValueFromPayload(CommonSubmitBlocState payload) {
    return null;
  }

  @override
  CommonSubmitBlocState updatePayload(
      CommonSubmitBlocState originalPayload, String? newValue) {
    return originalPayload..deepCopy();
  }

  @override
  String? validator(BuildContext context, String? value) {
    return null;
  }
}

void main() {
  group('BaseTextFormField', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when text is changed',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyTextFormField(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test');
      verify(mockSubmitBloc.add(any)).called(1);
    });
  });

  group('BaseCodeFormField', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when code is changed',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyCodeFormField(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.tap(find.text('1'));
      verify(mockSubmitBloc.add(any)).called(1);
    });
  });

  group('BaseCheckboxFormField', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when checkbox is changed',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyCheckboxFormField(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      verify(mockSubmitBloc.add(any)).called(1);
    });
  });

  group('BaseConfirmationCheckbox', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when checkbox is changed',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyConfirmationCheckbox(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckboxListTile));
      verify(mockSubmitBloc.add(any)).called(1);
    });
  });

  group('BaseReorderableFormField', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when list is reordered',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyReorderableFormField(formKey: formKey),
            ),
          ),
        ),
      );

      final TestGesture gesture =
          await tester.startGesture(tester.getCenter(find.text('Item 1')));
      await gesture.moveBy(const Offset(0, 100));
      await gesture.up();
      await tester.pump();

      verify(mockSubmitBloc.add(any)).called(1);
    });
  });

  group('BaseDropdownFormField', () {
    late MockSubmitBloc mockSubmitBloc;
    late GlobalKey<FormState> formKey;

    setUp(() {
      mockSubmitBloc = MockSubmitBloc();
      formKey = GlobalKey<FormState>();
    });

    testWidgets('calls add on bloc when value is changed',
        (WidgetTester tester) async {
      when(mockSubmitBloc.state).thenReturn(
        BaseSubmitState(
          payload: CommonSubmitBlocState(),
          submissionState: CommonSubmitBlocState(
            state: CommonSubmitBlocState_State.ready,
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<MockSubmitBloc>.value(
            value: mockSubmitBloc,
            child: Form(
              key: formKey,
              child: MyDropdownFormField(formKey: formKey),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      verify(mockSubmitBloc.add(any)).called(1);
    });
  });
}
