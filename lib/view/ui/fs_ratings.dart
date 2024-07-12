import 'package:flutter/material.dart';

class FSRating extends StatelessWidget {
  final double rating;

  const FSRating({
    super.key, 
    this.rating = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildStarts(rating);
  }
}

Widget _buildStarts(double rating) {
  List<Widget> list = [];

  for (double i = 1; i <= 5; i++) {
    if (rating >= i) {
      list.add(
        const Icon(
          Icons.star_outlined,
        ),
      );
    } else if (rating >= i - 0.1 && rating <= (i + 1) - 0.9) {
      list.add(
        const Icon(
          Icons.star_half_rounded,
        ),
      );
    } else {
      list.add(
        const Icon(
          Icons.star_border_rounded,
        ),
      );
    }
  }

  if (list.isNotEmpty) {
    return Row(children: list);
  }

  return const Row(
    children: [
      Icon(
        Icons.star_border_rounded,
      ),
      Icon(
        Icons.star_border_rounded,
      ),
      Icon(
        Icons.star_border_rounded,
      ),
      Icon(
        Icons.star_border_rounded,
      ),
      Icon(
        Icons.star_border_rounded,
      ),
    ],
  );
}
