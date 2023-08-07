import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/icons/icons.dart';

class MessageProfilPhoto extends StatelessWidget {
  const MessageProfilPhoto({
    required this.isMe,
    required this.user,
    required this.photo,
    Key? key,
  }) : super(key: key);
  final bool isMe;
  final User user;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: isMe
            ? UzchatColors.colorSendMessage
            : UzchatColors.colorRecieveMessage,
      ),
      child: photo.isEmpty
          ? Image.asset(
              UzchatIcons.defaultProfilePhoto,
              width: 40,
              height: 40,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                imageUrl: photo,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: UzchatColors.colorBlack,
                    ),
                  ),
                  baseColor: UzchatColors.colorMilk,
                  highlightColor: UzchatColors.colorGrey.withOpacity(.2),
                ),
              ),
            ),
    );
  }
}
