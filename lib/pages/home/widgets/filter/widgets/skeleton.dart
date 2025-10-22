import 'package:flutter/material.dart';  
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width / (index % 2 == 0 ? 1.5 : 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}