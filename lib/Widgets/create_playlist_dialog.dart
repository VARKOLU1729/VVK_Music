import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runo_music/Services/Providers/provider.dart';
import 'package:runo_music/main.dart';

Future<void> showCreatePlaylistDialog({
  required BuildContext context,
  required PlayListProvider playListProvider,
  // required void Function(String) onSave,
}) {
  bool entered = false;
  bool isPrivate = true;
  TextEditingController _controller = TextEditingController();
  final nameKey = GlobalKey<FormState>();
  final imageUrl = 'assets/images/favouritesImage.webp';

  void save({required bool isPrivate})
  {
    if(nameKey.currentState!.validate())
      {
        // onSave(_controller.text);
        playListProvider.createNewPlayList(name: _controller.text, imageUrl: imageUrl, isPrivate: isPrivate);
        Navigator.of(context).pop();
      }
  }

  String? validate(String? name)
  {
    if(name==null || name.isEmpty)
      {
        return "name must not be empty";
      }
    else if(playListProvider.isAlreadyExists(name: name))
      {
        return "Playlist '$name' already Exists";
      }
    return null;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          _controller.addListener((){
            if(_controller.text.length>0)
            {
              setState((){
                entered = true;
              });

            }
          });
          return AlertDialog(
            scrollable: true,
            iconPadding: EdgeInsets.only(left: 200),
            backgroundColor: Colors.black87,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
                ),
                onPressed: () {
                  context.pop();
                },
                child: Text("Close", style: TextStyle(color: Colors.black87)),
              ),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(entered ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiary.withOpacity(0.5)),
                ),
                onPressed: () {
                  save(isPrivate: isPrivate);
                },
                child: Text("Save", style: TextStyle(color: Colors.black87)),
              ),
            ],
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Create New Playlist",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Form(
                    key: nameKey,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      cursorHeight: 20,
                      controller: _controller,
                      validator: validate,
                      decoration: InputDecoration(
                        hintText: "Playlist Name ...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2), // White border when focused
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2), // Grey border when not focused
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Public", style: TextStyle(color: Colors.white),),
                    subtitle: Text("Let people see this playlist on your profile", style: TextStyle(color: Colors.grey),),
                    trailing: Switch(
                        value: !isPrivate,
                        activeTrackColor: Theme.of(context).colorScheme.tertiary,
                        inactiveTrackColor: Colors.grey,
                        thumbColor: WidgetStatePropertyAll(Colors.white),
                        trackOutlineWidth: WidgetStatePropertyAll(0),
                        onChanged: (val)
                        {
                          setState((){
                            isPrivate = !val;
                          });
                        }
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

