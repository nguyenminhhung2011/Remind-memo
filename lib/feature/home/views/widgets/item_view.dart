import 'package:flutter/material.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemView extends StatelessWidget {
  final String name;
  final DateTime time;
  final double price;
  final bool isPay;
  final Function() onPress;
  const ItemView({
    super.key,
    required this.name,
    required this.time,
    required this.price,
    required this.isPay, required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              name[0].toUpperCase(),
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  timeago.format(time),
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).hintColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Text(
            price.toString(),
            style: context.titleMedium.copyWith(
              color: isPay ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
