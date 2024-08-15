import 'package:flutter/material.dart';
import 'package:notes/constants/routers.dart';
import 'package:notes/enum/menu_action.dart';
import 'package:notes/services/auth/auth_services.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/utilities/dialogs/logout_dialog.dart';
import 'package:notes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _notesService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Notes",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CreateOrUpdateNoteRoute);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
            PopupMenuButton<MenuAction>(
                iconColor: Colors.white,
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        await AuthService.firebase().logOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                      }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text('Log Out')),
                  ];
                })
          ],
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: _notesService.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _notesService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allNotes =
                                  snapshot.data as List<DatabaseNote>;

                              return NotesListView(
                                notes: allNotes,
                                onDeleteNote: (note) async {
                                  await _notesService.deleteNote(id: note.id);
                                },
                                onTap: (note) {
                                  Navigator.of(context).pushNamed(
                                    CreateOrUpdateNoteRoute,
                                    arguments: note,
                                  );
                                },
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      });
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
