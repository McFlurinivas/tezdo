import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: SkeletonAnimation(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            title: SkeletonAnimation(
              child: Container(
                height: 10,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            subtitle: SkeletonAnimation(
              child: Container(
                height: 10,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}
