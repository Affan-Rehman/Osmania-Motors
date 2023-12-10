import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveDialog extends StatefulWidget {
  const AdaptiveDialog({required this.onResult});
  final Function(String?) onResult;

  @override
  _AdaptiveDialogState createState() => _AdaptiveDialogState();
}

class _AdaptiveDialogState extends State<AdaptiveDialog> {
  late Completer<String> _dialogCompleter;

  @override
  void initState() {
    super.initState();
    _dialogCompleter = Completer<String>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAdaptiveDialog();
    });
  }

  void _showAdaptiveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(context);
      },
    ).then((value) {
      if (value != null) {
        widget.onResult(value);
      } else {
        widget.onResult(null);
      }
    });
  }

  Widget _buildDialog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, null); // Dismiss the dialog without a result
      },
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 10, // Add a slight elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, 'add_car');
              },
              child: Text(
                'Add A Car',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '⸺or⸺',
                style: TextStyle(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 10, // Add a slight elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, 'make_request');
              },
              child: Text(
                'Make A Request',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
