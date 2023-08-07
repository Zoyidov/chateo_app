import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/users_model.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/icons/icons.dart';
import '../../../utils/style/style.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
    required this.users,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  final List<UsersModel> users;
  final int index;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: users[index].image.isEmpty
              ? Image.asset(
                  UzchatIcons.defaultProfilePhoto,
                  width: 45.0,
                  height: 45.0,
                )
              : Container(
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CachedNetworkImage(
                      imageUrl: users[index].image,
                      width: 45.0,
                      height: 45.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: UzchatColors.colorMilk,
                        highlightColor: UzchatColors.colorGrey.withOpacity(.3),
                        child: Container(
                          height: 45.0,
                          width: 45.0,
                          color: UzchatColors.colorBlack,
                        ),
                      ),
                    ),
                  ),
                ),
          title: Text(users[index].name,
              style: UzchatStyle.w500.copyWith(fontSize: 16)),
        ),
        const Divider(),
      ],
    );
  }
}
