import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../data/models/image_info_model.dart';

class HeroLayoutItem extends StatelessWidget {
  const HeroLayoutItem({
    super.key,
    required this.imageInfo,
  });

  final ImageInfoModel imageInfo;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).width;



    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              child: OverflowBox(
                minHeight: height * 0.6,
                maxWidth: width ,
                maxHeight: height * 0.6,
                minWidth: width * 7 / 8,
                child: Image.asset(
                  imageInfo.image.toString(),
                  package: imageInfo.package,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  imageInfo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  imageInfo.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
