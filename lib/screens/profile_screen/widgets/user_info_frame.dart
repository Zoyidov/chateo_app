import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/icons/icons.dart';
import '../../../utils/style/style.dart';

class UserInfoFrame extends StatelessWidget {
  final User user;
  const UserInfoFrame({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: UzchatColors.colorWhite,
      ),
      child: Row(
        children: [
          user.photoURL == null
              ? Image.asset(
                  UzchatIcons.defaultProfilePhoto,
                  width: 154.0,
                  height: 229.0,
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: user.photoURL!,
                      width: 154.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Shimmer.fromColors(
                        baseColor: UzchatColors.colorMilk,
                        highlightColor: UzchatColors.colorGrey.withOpacity(.2),
                        child: Container(
                          width: 154.0,
                          height: 200.0,
                          color: UzchatColors.colorBlack,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline_outlined),
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName!,
                  style: UzchatStyle.w600.copyWith(
                    color: UzchatColors.colorProfileText,
                    fontSize: 35.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Email",
                  style: UzchatStyle.w500.copyWith(
                    color: UzchatColors.colorProfileTitle,
                  ),
                ),
                Text(
                  user.email!,
                  style: UzchatStyle.w600.copyWith(
                    color: UzchatColors.colorProfileText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
