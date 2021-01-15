import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NumberStepper extends StatefulWidget {
  NumberStepper({
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.stepValue,
    @required this.value,
    @required this.valueChanged,
    @required this.suffix
  });

  final int lowerLimit;
  final int upperLimit;
  final int stepValue;
  final double iconSize = 16;
  int value;
  final ValueChanged<int> valueChanged;
  final String suffix;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<NumberStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          iconSize: widget.iconSize,
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.lowerLimit
                  ? widget.lowerLimit
                  : widget.value -= widget.stepValue;
            });
            widget.valueChanged(widget.value);
          },
        ),
        Container(
          //width: widget.iconSize*2,
          child: Text(
            '${widget.value} ${widget.suffix}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          iconSize: widget.iconSize,
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.upperLimit
                  ? widget.upperLimit
                  : widget.value += widget.stepValue;
            });
            widget.valueChanged(widget.value);
          },
        ),
      ],
    );
  }
}
