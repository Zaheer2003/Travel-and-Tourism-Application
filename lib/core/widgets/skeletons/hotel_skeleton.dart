import 'package:flutter/material.dart';
import 'skeleton_item.dart';

class HotelSkeleton extends StatelessWidget {
  const HotelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonItem(
            height: 120,
            width: 200,
            borderRadius: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonItem(height: 16, width: 140),
                const SizedBox(height: 8),
                const SkeletonItem(height: 12, width: 100),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonItem(height: 14, width: 50),
                    SkeletonItem(height: 14, width: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
