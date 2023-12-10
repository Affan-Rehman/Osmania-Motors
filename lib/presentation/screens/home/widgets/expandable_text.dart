import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText({required this.text, required this.style});
  final String text;
  final TextStyle style;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: isExpanded ? null : 2,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: widget.style,
                maxLines: isExpanded ? null : 2,
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Read less' : 'Read more',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        } else {
          return Text(
            widget.text,
            style: widget.style,
          );
        }
      },
    );
  }
}
