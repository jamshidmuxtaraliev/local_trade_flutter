import 'package:flutter/material.dart';
import 'package:local_trade_flutter/generated/assets.dart';
import 'package:local_trade_flutter/services/providers.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/pref_utils.dart';
import '../../../utils/utils.dart';
import '../../../view/product_item_view.dart';
import '../../models/product_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<ProductModel> favProductItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(builder: (context, provider, child) {
      List<ProductModel> favProductItems = [];
      favProductItems = provider.getFav();
      return Stack(
        children: [
          (PrefUtils.getFavoriteList().length !=0)?Container(
            color: Colors.white,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: PrefUtils.getFavoriteList().length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  print(favProductItems[index].favorite);
                  return ProductItemView(item: favProductItems[index],
                          () {
                    // setState(() {
                    //   provider.getFav().remove(provider.getFav()[index]);
                    // });
                  }
                  );
                }),
          ): Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesEmpty,
                width: 160,
                height: 160,
              ),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Sizda hozircha tanlanganlar mavjud emas !",
                  style: TextStyle(color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      );
    });
  }

}
