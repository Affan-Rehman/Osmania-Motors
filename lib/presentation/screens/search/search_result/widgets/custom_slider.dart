import 'package:flutter/material.dart';

class SliderContainer extends StatefulWidget {
  SliderContainer({
    Key? key,
    required this.sliderValue,
    required this.onChanged,
    this.type,
  }) : super(key: key);

  final double sliderValue;
  static double _lowerValue = 0;
  String? type;
  final Function(double, double) onChanged;

  @override
  State<SliderContainer> createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  late RangeValues values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // widget to show the selected range of values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              values.start.toInt().toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              values.end.toInt().toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              // activeTrackColor: Colors.white,
              // inactiveTrackColor: Colors.white,
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 3.0,
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 12.0,
                elevation: 10,
              ),

              overlappingShapeStrokeColor: Colors.blue,
              thumbColor: Colors.white,
              overlayColor: Colors.blue,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: const RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.blue,
              inactiveTickMarkColor: Colors.blue,
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            child: RangeSlider(
              values: values,
              min: SliderContainer._lowerValue,
              max: widget.sliderValue,
              divisions: widget.sliderValue.toInt(),
              labels: RangeLabels(
                values.start.toStringAsFixed(0),
                values.end.toStringAsFixed(0),
              ),
              onChanged: (RangeValues v) {
                setState(() {
                  v.start.toInt();
                  v.end.toInt();
                  values = v;
                });

                widget.onChanged(values.start, values.end);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    SliderContainer._lowerValue = widget.type == 'model_year' ? 1800 : 0;
    values = RangeValues(SliderContainer._lowerValue, widget.sliderValue);
    super.initState();
  }
}
