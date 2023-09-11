import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth/auth_service.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/cloud_storage_exceptions.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../utilities/dialogs/delete_dialog.dart';
import '../../utilities/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
  }

  void _textControllerListener() async {
    final note = _note;

    if (note == null) {
      return;
    }

    final text = _textController.text;

    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;

      return widgetNote;
    }

    final existingNote = _note;

    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(
      ownerUserId: userId,
    );
    _note = newNote;

    return newNote;
  }

  void _deleteNote() {
    final note = _note;

    if (note != null) {
      _notesService.deleteNote(
        documentId: note.documentId,
      );
    }
  }

  void _saveNoteOrDiscardItIfIsEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (note != null) {
      if (_textController.text.isEmpty) {
        _notesService.deleteNote(
          documentId: note.documentId,
        );
      } else {
        await _notesService.updateNote(
          documentId: note.documentId,
          text: text,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _saveNoteOrDiscardItIfIsEmpty();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade400,
      appBar: AppBar(
        title: Text(
          'LvL Up',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 6.0,
            ),
            child: Text(
              'Note',
              style: GoogleFonts.notoSans(
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);

              if (shouldDelete) {
                _deleteNote();
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  minLines: 15,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.amberAccent.shade100,
                    hintText: 'Type your note here',
                  ),
                ),
              );
            default:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.indigo.shade200,
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
