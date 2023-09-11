import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import 'notes_listview.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();

    _notesService = FirebaseCloudStorage();
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
              'Notes list',
              style: GoogleFonts.notoSans(
                color: Colors.white,
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(
            10.0,
            4.0,
            10.0,
            4.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.indigo.shade800,
            ),
            child: const Center(
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);

                  if (shouldLogout) {
                    if (mounted) {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
            offset: const Offset(0.0, 40.0),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(
          ownerUserId: userId,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Tap the plus button to add a note',
                  style: TextStyle(
                    color: Colors.grey.shade100,
                  ),
                ),
              );
            // case ConnectionState.done:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;

                if (allNotes.isEmpty) {
                  return Center(
                    child: Text(
                      'Tap the plus button to add a note',
                      style: TextStyle(
                        color: Colors.grey.shade100,
                      ),
                    ),
                  );
                } else {
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                        documentId: note.documentId,
                      );
                    },
                  );
                }
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo.shade200,
                    ),
                  ),
                );
              }
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
