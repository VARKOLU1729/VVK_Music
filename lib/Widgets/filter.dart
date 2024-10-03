import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Helper/deviceParams.dart';

void Filter({required BuildContext context, required void Function(String) onSubmit}) async
{
  print("HI");
  return await showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Colors.black87,
      context: context,
      builder:(context) {
        String selectedVal  = 'None';
        bool isSelected = false;
        return StatefulBuilder(builder: (context, setState) {
          void onChanged(val) {
            setState(() {
              selectedVal = val;
              isSelected = true;
            });
          }
          void reset()
          {
            setState((){
              isSelected = false;
              selectedVal = 'None';
            });
          }
          return SizedBox(
              width: getWidth(context),
              height: 350,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sort", style: TextStyle(color: Colors.white,height: 0, fontSize: 20, fontWeight: FontWeight.bold),),
                        FilledButton(
                            onPressed: reset,
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size.fromHeight(20)),
                              backgroundColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.4)),
                            ),
                            child: Text("Reset", style: TextStyle(color: Colors.white),))
                      ],
                    ),
                    RadioTile(
                        value: 'artistName',
                        selectedValue: selectedVal,
                        title: "Artist Name",
                        onChanged: onChanged
                    ),
                    Divider(height: 0,thickness: 0,),
                    RadioTile(
                        value: 'trackName',
                        selectedValue: selectedVal,
                        title: "Track Name",
                        onChanged: onChanged
                    ),
                    Divider(height: 0,thickness: 0,),
                    RadioTile(
                        value: 'albumName',
                        selectedValue: selectedVal,
                        title: "Album Name",
                        onChanged: onChanged
                    ),
                    FilledButton(
                      onPressed:(){
                        if(isSelected) {
                          // favProvider.sortFavourites(selectedVal);
                          onSubmit(selectedVal);
                          context.pop();
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size.fromWidth(getWidth(context))),
                        backgroundColor: WidgetStatePropertyAll(isSelected ? Theme.of(context).colorScheme.tertiary :Theme.of(context).colorScheme.tertiary.withOpacity(0.5)),
                      ),
                      child: Text("Apply", style: TextStyle(color: Colors.black),),
                    ),
                    FilledButton(
                      onPressed:(){
                        context.pop();
                      },
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size.fromWidth(getWidth(context))),
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      child: Text("Dismiss", style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              )
          );
        }
        );
      }
  );
}
Widget RadioTile({required String title,required String selectedValue, required String value, required void Function(String?) onChanged})
{
  return RadioListTile(
    contentPadding: EdgeInsets.zero,
    value: value,
    groupValue: selectedValue,
    title:  Text("$title", style: TextStyle(color: Colors.white),),
    onChanged: onChanged,
    activeColor: Colors.orange,
    controlAffinity: ListTileControlAffinity.trailing,
    tileColor: Colors.transparent,
    // contentPadding: EdgeInsets.zero,
    // visualDensity: VisualDensity(horizontal: -4),
  );
}