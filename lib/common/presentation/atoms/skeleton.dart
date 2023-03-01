import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? margin;
  const Skeleton(
      {Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor.withOpacity(0.4),
      highlightColor: Theme.of(context).primaryColor.withOpacity(1),
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: margin ?? 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
      ),
    );
  }
}
