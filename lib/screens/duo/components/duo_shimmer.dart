import 'package:flutter/cupertino.dart';
import 'package:moeen/components/skeleton.dart';

class DuoShimmer extends StatelessWidget {
  const DuoShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(
          height: 80,
          width: 80,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Skeleton(
              height: 20,
              width: 100,
              borderRadius: 3,
            ),
            SizedBox(
              height: 10,
            ),
            Skeleton(
              height: 20,
              width: 50,
              borderRadius: 3,
            ),
          ],
        ),
        Spacer(),
        const Skeleton(
          height: 20,
          width: 50,
          borderRadius: 3,
        ),
      ],
    );
  }
}
