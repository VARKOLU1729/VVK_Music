import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class favouriteItemsProvider extends ChangeNotifier
{
  Map<String, List<dynamic>> favourite_items = new Map();
  void addToFavourite({required String id, required List<dynamic> details})
  {
    favourite_items[id] = details;
    notifyListeners();
  }

  void removeFromFavourite({required String id})
  {
    favourite_items.remove(id);
    print(favourite_items);
    notifyListeners();
  }

  bool checkInFav({required String id})
  {
    if(favourite_items.containsKey(id)) return true;
    return false;
  }

}
