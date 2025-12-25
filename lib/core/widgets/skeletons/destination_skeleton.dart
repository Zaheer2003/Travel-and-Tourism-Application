import 'package:flutter/material.dart';
import 'skeleton_item.dart';

class DestinationSkeleton extends StatelessWidget {
  const DestinationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          const SkeletonItem(
            height: 400,
            width: 280,
            borderRadius: 24,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonItem(height: 24, width: 150),
                  const SizedBox(height: 8),
                  const SkeletonItem(height: 16, width: 100),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SkeletonItem(height: 20, width: 80),
                      SkeletonItem(height: 36, width: 36, borderRadius: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
