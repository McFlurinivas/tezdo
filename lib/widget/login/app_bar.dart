import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      scrolledUnderElevation: 0.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Tezdo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
