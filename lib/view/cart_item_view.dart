import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_trade_flutter/services/providers.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../screens/models/product_model.dart';
import '../utils/colors.dart';
import '../utils/pref_utils.dart';

class CartItemView extends StatefulWidget {
  ProductModel item;
  Function updateCart;
  Function deleteCart;

  CartItemView({Key? key, required this.item, required this.updateCart, required this.deleteCart}) : super(key: key);

  @override
  _CartItemViewState createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  var cartCount = 0.0;
  var totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    var cartCount = PrefUtils.getCartCount(widget.item.tovarId);

    return Consumer<Providers>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: PrefUtils.getBaseImageUrl() + (widget.item.foto ?? ""),
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
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
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.tovar,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              provider.addToCart(widget.item.tovarId, 0, 0.0, 0.0);
                              widget.deleteCart();
                            },
                            child: const Icon(CupertinoIcons.delete_simple))
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Narxi: ",
                          style: TextStyle(color: AppColors.BLUE, fontSize: 15),
                        ),
                        Text(
                          (widget.item.cartPrice ?? 0).formattedAmountString(),
                          style: const TextStyle(color: AppColors.BLUE, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.item.cartTotalPrice.formattedAmountString() +
                              ((PrefUtils.getPriceType() == 1) ? "so'm" : "\$"),
                          style: const TextStyle(color: AppColors.BLUE, fontSize: 15),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                            onTap: () {
                              setState(() {
                                --cartCount;
                                if (cartCount > 0) {
                                  totalPrice = cartCount * widget.item.cartPrice;
                                  provider.addToCart(widget.item.tovarId, cartCount, widget.item.cartPrice, totalPrice);
                                } else {
                                  provider.addToCart(widget.item.tovarId, 0, 0.0, 0.0);
                                  cartCount = 0.0;
                                  widget.deleteCart();
                                }
                              });

                              widget.updateCart();
                            },
                            child: const Icon(
                              Icons.indeterminate_check_box_outlined,
                              size: 30,
                              color: Colors.grey,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            cartCount.formattedAmountString(),
                            style: const TextStyle(color: AppColors.BLACK, fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                ++cartCount;
                                if (cartCount > widget.item.ostatka) {
                                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
                                      content: Text(
                                          "Ombordagidan mahsulot kam!. Qoldiq : ${widget.item.ostatka.formattedAmountString()} dona")));
                                  --cartCount;
                                } else {
                                  totalPrice = cartCount * widget.item.cartPrice;
                                  provider.addToCart(widget.item.tovarId, cartCount, widget.item.cartPrice, totalPrice);
                                }
                                widget.updateCart();
                              });
                            },
                            child: const Icon(
                              Icons.add_box_outlined,
                              size: 30,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ],
                ))
              ],
            ),
            const Divider(
              color: Colors.blueGrey,
            )
          ],
        );
      },
    );
  }
}
