import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';

import '../generated/assets.dart';
import '../utils/colors.dart';
import '../utils/pref_utils.dart';

class CategoryCircleItemView extends StatelessWidget {
  final CategoryModel item;

  CategoryCircleItemView({required this.item, Key? key}) : super(key: key);
  GlobalKey containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("Category rebuild");
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            key: containerKey,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 6.0, offset: Offset(0.0, 1.0), spreadRadius: 0.0)
              ],
            ),
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(size.width / 8),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white,
                child: SizedBox.fromSize(
                  size: Size((size.width / 4), (size.width / 4)),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: PrefUtils.getBaseImageUrl() + (item.foto??""),
                        placeholder: (context, url) => Center(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                ))),
                        errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                                color: Colors.white,
                                child: Center(
                                    child: Image.asset(
                                      Assets.imagesPlaceholder,
                                    )))),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            item.Kategoriya??"",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.LIGHT_BLACK,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
