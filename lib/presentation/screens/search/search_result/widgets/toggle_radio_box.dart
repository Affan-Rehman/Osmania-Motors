import 'package:flutter/material.dart';

class ToggleRadioBox extends StatefulWidget {
  ToggleRadioBox({Key? key, this.selected = false}) : super(key: key);
  bool selected;
  @override
  _ToggleRadioBoxState createState() => _ToggleRadioBoxState();
}

class _ToggleRadioBoxState extends State<ToggleRadioBox> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2.0,
              color: _isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          width: 20.0,
          height: 20.0,
          child: _isSelected
              ? Icon(
                  Icons.check,
                  size: 12.0,
                  color: Colors.blue,
                )
              : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.selected) {
      setState(() {
        _isSelected = true;
      });
    }
    super.initState();
  }
}
