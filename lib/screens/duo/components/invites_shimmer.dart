import 'package:flutter/cupertino.dart';
import 'package:moeen/common/presentation/atoms/skeleton.dart';

class InvitesShimmer extends StatelessWidget {
  const InvitesShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Skeleton(
              height: 20,
              width: 150,
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
        SizedBox(
          width: 10,
        ),
        const Skeleton(
          height: 20,
          width: 50,
          borderRadius: 3,
        ),
      ],
    );
  }
}
