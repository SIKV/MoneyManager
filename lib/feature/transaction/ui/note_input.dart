import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';
import 'package:moneymanager/theme/spacings.dart';

const _maxLines = 7;
const _maxLength = 512;

class NoteInput extends ConsumerStatefulWidget {
  const NoteInput({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteInputState();
}

class _NoteInputState extends ConsumerState<NoteInput> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final note = ref.read(transactionMakerControllerProvider
        .selectAsync((state) => state.transaction.note));

    note.then((value) {
      textEditingController.text = value ?? '';
    });

    textEditingController.addListener(() {
      ref.read(transactionMakerControllerProvider.notifier)
          .setNote(textEditingController.text);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacings.four,
        horizontal: Spacings.six,
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.transaction_enterNoteHint,
        ),
        minLines: 1,
        maxLines: _maxLines,
        maxLength: _maxLength,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
