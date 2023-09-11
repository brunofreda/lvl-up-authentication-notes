import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);

        return Container(
          height: 350,
          margin: const EdgeInsets.fromLTRB(
            15.0,
            15.0,
            15.0,
            5.0,
          ),
          decoration: BoxDecoration(
            color: Colors.amberAccent.shade100,
          ),
          child: ListTile(
            onTap: () async {
              Navigator.of(context).pushNamed(
                createOrUpdateNoteRoute,
                arguments: note,
              );
            },
            title: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                note.text,
                maxLines: 13,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);

                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }
}
