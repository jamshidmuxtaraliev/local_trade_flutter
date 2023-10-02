import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:money_input_formatter/money_input_controller.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../screens/models/event_model.dart';
import '../screens/models/product_model.dart';
import '../services/event_bus.dart';
import '../services/providers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/pref_utils.dart';
import '../utils/utils.dart';

class ProductItemView extends StatefulWidget {
  final ProductModel item;
  Function updateFav;

  ProductItemView(this.updateFav, {required this.item, Key? key}) : super(key: key);

  @override
  State<ProductItemView> createState() => _ProductItemViewState();
}

class _ProductItemViewState extends State<ProductItemView> {
  var cartCount = 0.0;
  var cartPrice = 0.0;
  var totalPrice = 0.0;
  var cartCountController = TextEditingController();
  var cartPriceController = MoneyInputController();
  var totalPriceController = MoneyInputController();
  StreamSubscription? busEventListener;

  @override
  void initState() {
    cartCount = PrefUtils.getCartCount(widget.item.tovarId);

    busEventListener = eventBus.on<EventModel>().listen((event) {
      if (event.event == EVENT_UPDATE_CART) {
        if (mounted) {
          setState(() {
            cartCount = PrefUtils.getCartCount(widget.item.tovarId);
            if (cartCount != 0.0) {
              cartCountController.text = cartCount.formattedAmountString();
              cartPriceController.text = widget.item.cartPrice.formattedAmountString();
              totalPriceController.text = (cartCount * widget.item.cartPrice).formattedAmountString();
            } else {
              cartCountController.text = "1";
              cartPriceController.text = (widget.item.sena ?? 0).formattedAmountString();
              totalPriceController.text = (widget.item.sena ?? 0).formattedAmountString();
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    busEventListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(builder: (context, provider, child) {
      return InkWell(
        onTap: () {
          showAdd2CartSheet(provider);
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 8),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox.fromSize(
                        size: const Size(120, 120),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: "${PrefUtils.getBaseImageUrl()}${widget.item.foto}",
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
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.item.favorite = !widget.item.favorite;
                          setState(() {
                            provider.setFav(widget.item);
                          });
                          widget.updateFav();
                        },
                        icon: Icon(
                          widget.item.favorite ? Icons.favorite_rounded : Icons.favorite_border,
                          color: AppColors.COLOR_BDM_DARK,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.tovar,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.LIGHT_BLACK),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Kod: ",
                            style: TextStyle(fontSize: 16, color: AppColors.GREY_TEXT_COLOR),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.item.tovarId.toString(),
                            style: const TextStyle(fontSize: 16, color: AppColors.GRAY_COLOR),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Optom Narxi: ",
                            style: TextStyle(fontSize: 16, color: AppColors.GREY_TEXT_COLOR),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            (widget.item.optom_narx ?? 0).toStringAsFixed(PrefUtils.getPriceType() == 1 ? 0 : 6),
                            style: const TextStyle(fontSize: 16, color: AppColors.LIGHT_BLACK),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  (widget.item.sena ?? 0).formattedAmountString(),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.LIGHT_BLACK),
                                ),
                                (PrefUtils.getPriceType() == 1)
                                    ? const RotationTransition(
                                        turns: AlwaysStoppedAnimation(270 / 360),
                                        child: Text(
                                          "so'm",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.LIGHT_BLACK,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        " \$",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.LIGHT_BLACK,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.LIGHT_BLACK,
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(18)),
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(minWidth: 50),
                            child: Text(
                              cartCount == 0.0 ? "+" : cartCount.formattedAmountString(),
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void showAdd2CartSheet(Providers provider) {
    cartCount = PrefUtils.getCartCount(widget.item.tovarId);
    print(cartCount);
    if (cartCount != 0.0) {
      cartCountController.text = cartCount.formattedAmountString();
      cartPriceController.text = widget.item.cartPrice.formattedAmountString();
      totalPriceController.text = (cartCount * widget.item.cartPrice).formattedAmountString();
    } else {
      cartCountController.text = "1";
      cartPriceController.text = (widget.item.sena ?? 0).formattedAmountString();
      totalPriceController.text = (widget.item.sena ?? 0).formattedAmountString();
    }
    showMyBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setState2) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(16))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox.fromSize(
                        size: const Size.fromHeight(180),
                        child: CachedNetworkImage(
                          fit: BoxFit.scaleDown,
                          imageUrl: "${PrefUtils.getBaseImageUrl()}${widget.item.foto}",
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
                                    fit: BoxFit.cover,
                                  )))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.tovar,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Narxi: ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: 36,
                            child: TextField(
                              controller: cartPriceController,
                              inputFormatters: [MoneyInputFormatter()],
                              textAlign: TextAlign.start,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(contentPadding: EdgeInsets.all(0)),
                              scrollPadding: const EdgeInsets.all(0),
                              onChanged: (value) {
                                setState2(() {
                                  cartPrice = double.parse(value.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  totalPriceController.text = (cartPrice *
                                          double.parse(cartCountController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "")))
                                      .formattedAmountString();
                                });
                              },
                            ),
                          )),
                          Text(
                            (PrefUtils.getPriceType() == 1) ? "so'm" : "\$",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.LIGHT_BLACK,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            "Ostatka: ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            (widget.item.ostatka).formattedAmountString(),
                            style: const TextStyle(fontSize: 16, color: AppColors.LIGHT_BLACK),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                setState2(() {
                                  cartCount =
                                      double.parse(cartCountController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  if (cartCount > 0) {
                                    cartCount--;
                                    cartCountController.text = cartCount.formattedAmountString();
                                    totalPrice = cartCount *
                                        double.parse(cartPriceController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                    totalPriceController.text = totalPrice.formattedAmountString();
                                    print(cartCount);
                                  } else {
                                    Fluttertoast.showToast(msg: "Maksimal miqdordan ortiq zakaz berib bo'lmaydi !");
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.indeterminate_check_box_outlined,
                                size: 30,
                                color: Colors.grey,
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 60,
                            child: TextFormField(
                              controller: cartCountController,
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(contentPadding: EdgeInsets.all(0)),
                              scrollPadding: const EdgeInsets.all(0),
                              onChanged: (value) {
                                cartCount = double.parse(value.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                if (cartCount > 0 && cartCount < widget.item.ostatka) {
                                  totalPrice = cartCount *
                                      double.parse(cartPriceController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  totalPriceController.text = totalPrice.formattedAmountString();
                                  print(cartCount);
                                } else {
                                  Fluttertoast.showToast(msg: "Maksimal miqdordan ortiq zakaz berib bo'lmaydi !");
                                }
                              },
                            ),
                          ),
                          Text(
                            widget.item.yedIzm,
                            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                          InkWell(
                              onTap: () {
                                setState2(() {
                                  cartCount =
                                      double.parse(cartCountController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  if (cartCount < widget.item.ostatka) {
                                    cartCount++;
                                    cartCountController.text = cartCount.formattedAmountString();
                                    totalPrice = cartCount *
                                        double.parse(cartPriceController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                    totalPriceController.text = totalPrice.formattedAmountString();
                                    print(cartCount);
                                  } else {
                                    Fluttertoast.showToast(msg: "Maksimal miqdordan ortiq zakaz berib bo'lmaydi !");
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.add_box_outlined,
                                size: 30,
                                color: Colors.grey,
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: totalPriceController,
                              inputFormatters: [MoneyInputFormatter()],
                              textAlign: TextAlign.end,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(contentPadding: EdgeInsets.all(0)),
                              scrollPadding: const EdgeInsets.all(0),
                              onChanged: (value) {
                                setState2(() {
                                  cartPrice =
                                      double.parse(cartPriceController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  totalPrice = double.parse(value.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  cartCountController.text = (totalPrice / cartPrice).toStringAsFixed(1);
                                });
                              },
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Umumiy optom narxi: ",
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            (widget.item.optom_narx ?? 0.0).formattedAmountString(),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: getScreenWidth(context),
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.COLOR_GREY,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                          child: const Text("Savatga saqlash",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                          onPressed: () {
                            cartCount = double.parse(cartCountController.text);
                            cartPrice = double.parse(cartPriceController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));

                            if (double.parse(cartCountController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "")) >
                                widget.item.ostatka) {
                              Fluttertoast.showToast(msg: "Mahsulot miqdori ombordagidan kop korsatilgan");
                              return;
                            } else if (cartPrice < (widget.item.optom_narx ?? 0)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Mahsulot narxi tannarxdan past bo'lmasligi kerak. \n Tannarx: ${(widget.item.optom_narx ?? 0).formattedAmountString()}");
                              return;
                            }

                            setState(() {
                              widget.item.cartCount = cartCount;
                              widget.item.cartPrice = cartPrice;
                            });

                            provider.addToCart(
                                widget.item.tovarId, cartCount, cartPrice, cartCount * widget.item.cartPrice);
                            int countBadge = PrefUtils.getCartList().length;
                            eventBus.fire(EventModel(event: EVENT_UPDATE_BADGE, data: countBadge));
                            Navigator.of(context).pop();
                            setState(() {
                              cartCount = 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
