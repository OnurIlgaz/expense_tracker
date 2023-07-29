import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget{
  const ChartBar({required this.fill, super.key});
  final double fill;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    print(fill);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: isDarkMode ?
              Theme.of(context).colorScheme.secondary :
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
            )
          ),
        ),
      ),
    );
  }

}