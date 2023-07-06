import 'package:flutter/material.dart';


class HeaderTextCustom extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String headerText;
  final String? afterText;
  final TextStyle? textStyle;
  final Widget? widget;
  final bool isShowSeeMore;
  final Function()? onPress;
  const HeaderTextCustom({
    super.key,
    this.padding,
    this.textStyle,
    this.isShowSeeMore = false,
    required this.headerText,
    this.onPress,
    this.widget, this.afterText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              headerText,
              style: textStyle ??
                  Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
            ),
          ),
          if (widget != null) widget!,
          if (isShowSeeMore)
            TextButton(
              onPressed: onPress ?? () {},
              child: Text(
                afterText ?? 'See more',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            )
        ],
      ),
    );
  }
}
