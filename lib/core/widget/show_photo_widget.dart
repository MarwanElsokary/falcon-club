import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../helpers/spacing.dart';

showPhotoDialog({
  required BuildContext context,
  required String image,
  required String name,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: context.displayWidth / 1.3,
                  width: context.displayWidth / 1.3,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox(
                      height: context.displayWidth / 1.3,
                      width: context.displayWidth / 1.3,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Skeletonizer(
                          enabled: true,
                          child: Container(
                            height: context.displayWidth / 1.3,
                            width: context.displayWidth / 1.3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/193064 1.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                verticalSpace(20),
                CenterTextUtils(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: name,
                ),
                verticalSpace(40),
              ],
            ),
          ),
        ),
      );
    },
  );
}
