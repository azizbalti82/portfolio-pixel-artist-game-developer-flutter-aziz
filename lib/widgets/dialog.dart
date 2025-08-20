import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/theme_data.dart';


class Confirm extends Widget {
  const Confirm(this.t, {super.key, required this.type, required this.callback});
  final void Function() callback;
  final String type;
  final theme t;


  @override
  SystemUiStyleWrapper build(BuildContext context) {
    return SystemUiStyleWrapper(
      t:t,
      child: AlertDialog(
        backgroundColor: t.cardColor,
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Center(
          child: Text(
            (type == 'room_deactivate')
                ? "Deactivate this room"
                : (type == 'room_changePrivacy_public')
                ? "Change to public"
                : (type == 'room_changePrivacy_private')
                ? "Change to private"
                : (type == 'block')
                ? "Block Member"
                : (type == 'removeMember')
                ? "Kick Member"
                : (type == 'removeHost')
                ? "Remove Room"
                : "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: t.textColor),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: t.textColor,
                  weight: 0.5,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    (type == 'room_changePrivacy_public' ||
                            type == 'room_changePrivacy_private')
                        ? "Only new members will be affected.\nexisting ones will remain unchanged."
                        : (type == 'room_deactivate')
                        ? "Deactivate this room?\nYou can reactivate it anytime."
                        : (type == 'removeMember')
                        ? "This member can always join,\nunless the room is public or the code changes."
                        : (type == 'removeHost')
                        ? "You're the only member in this room. Removing yourself will permanently delete it."
                        :"",
                    style: TextStyle(fontSize: 14, color: t.textColor),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: t.surfaceColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              color: t.textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            callback();

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: t.errorColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          child: Text(
                            (type == 'removeHost')? "DELETE ROOM" :"Continue",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}