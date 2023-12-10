import 'package:flutter/material.dart';

class ToggleTextBtns extends StatefulWidget {
  ToggleTextBtns({
    required this.texts,
    required this.selected,
    this.selectedColor = const Color(0xFF6200EE),
    this.stateContained = true,
    this.canUnToggle = false,
    this.multipleSelectionsAllowed = true,
    Key? key,
  });
  final List<Text> texts;
  final bool Function(int) selected;
  final Color selectedColor;
  final bool multipleSelectionsAllowed;
  final bool stateContained;
  final bool canUnToggle;

  @override
  _ToggleTextBtnsState createState() => _ToggleTextBtnsState();
}

class _ToggleTextBtnsState extends State<ToggleTextBtns> {
  late List<bool> isSelected = [];
  @override
  void initState() {
    widget.texts.forEach((e) => isSelected.add(false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            renderBorder: false,
            constraints: BoxConstraints(
              // minWidth: 50,
              minHeight: 40,
            ),
            color: Colors.black.withOpacity(0.60),
            selectedColor: widget.selectedColor,
            selectedBorderColor: Colors.transparent,
            fillColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: widget.selectedColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14.0),
            isSelected: isSelected,
            highlightColor: Colors.transparent,
            onPressed: (index) {
              // send callback
              // widget.selected(index);
              // if you wish to have state:
              if (widget.stateContained) {
                if (!widget.multipleSelectionsAllowed) {
                  final selectedIndex = isSelected[index];
                  isSelected = isSelected.map((e) => e = false).toList();
                  if (widget.canUnToggle) {
                    isSelected[index] = selectedIndex;
                  }
                }
                setState(() {
                  if (widget.selected(index) == true)
                    isSelected[index] = !isSelected[index];
                });
              }
            },
            children: widget.texts
                .map(
                  (e) => Container(
                    // width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: isSelected[widget.texts.indexOf(e)] == true
                          ? Colors.blue[100]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected[widget.texts.indexOf(e)] == true
                            ? Color.fromARGB(255, 255, 0, 0): Colors.grey[100]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected[widget.texts.indexOf(e)] == true
                              ? Colors.blue[100]!
                              : Colors.grey[300]!,
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: e,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
