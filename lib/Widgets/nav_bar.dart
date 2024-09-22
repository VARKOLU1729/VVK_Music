import 'package:flutter/material.dart';

enum Layout { vertical, horizontal }

class CustomNavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  CustomNavBarItem(
      {required this.icon, required this.activeIcon, required this.label});
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<CustomNavBarItem> items;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final double iconSize;
  final double selectedFontSize;
  final double unselectedFontSize;
  final Layout layout;
  final bool showLabel;
  final TextStyle? labelStyle;

  CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
    this.showLabel = false,
    this.labelStyle,
    this.layout = Layout.horizontal,
    this.backgroundColor = Colors.black,
    this.selectedItemColor = Colors.teal,
    this.unselectedItemColor = Colors.white70,
    this.iconSize = 24.0,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
  }):assert(showLabel==false || labelStyle!=null, 'If showLabel is true , then labelStyle must not be null');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((navItem) {
          int index = items.indexOf(navItem);
          bool isSelected = index == selectedIndex;

          return InkWell(
              onTap: () => onTap(index),
              child: layout == Layout.vertical
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                      ? Icon(navItem.activeIcon, color: selectedItemColor)
                      : Icon(navItem.icon, color: unselectedItemColor),
                  if (showLabel)
                  const SizedBox(height: 4.0), // Spacing between icon and label
                  if (showLabel)
                    Text(
                      navItem.label,
                      style: TextStyle(
                        color: isSelected
                            ? selectedItemColor
                            : unselectedItemColor,
                        fontSize: labelStyle!.fontSize,
                        fontWeight: labelStyle!.fontWeight,
                      ),
                    ),
                ],
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                      ? Icon(navItem.activeIcon, color: selectedItemColor)
                      : Icon(navItem.icon, color: unselectedItemColor),
                  if (showLabel)
                    SizedBox(
                        width: 4.0), // Spacing between icon and label
                  if (showLabel)
                    Text(
                      navItem.label,
                      style: TextStyle(
                        color: isSelected
                            ? selectedItemColor
                            : unselectedItemColor,
                        fontSize: labelStyle!.fontSize,
                        fontWeight: labelStyle!.fontWeight,
                      ),
                    ),
                ],
              ));
        }).toList(),
      ),
    );
  }
}