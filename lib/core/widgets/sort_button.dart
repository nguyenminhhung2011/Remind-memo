import 'package:flutter/material.dart';
import 'package:project/core/extensions/context_exntions.dart';

class SortButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPress;
  final double? radius;
  final double? height;
  const SortButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.radius,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 10.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(icon, size: 15.0, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
