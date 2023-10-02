import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:local_trade_flutter/api/main_viewmodel.dart';
import 'package:local_trade_flutter/screens/models/make_order_model.dart';
import 'package:local_trade_flutter/screens/models/make_order_product.dart';
import 'package:local_trade_flutter/services/boxes.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:local_trade_flutter/utils/pref_utils.dart';
import 'package:local_trade_flutter/utils/utils.dart';
import 'package:local_trade_flutter/view/cart_item_view.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../services/event_bus.dart';
import '../../../services/providers.dart';
import '../../../utils/constants.dart';
import '../../models/event_model.dart';
import '../../models/product_model.dart';
import 'clients_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription? _busEventListener;

  @override
  void dispose() {
    _busEventListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, provider, child) {
        return ViewModelBuilder.reactive(
          viewModelBuilder: () {
            return MainViewModel();
          },
          builder: (context, viewModel, child) {
            return (provider.getCartItems().isNotEmpty)
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: provider.getCartItems().length,
                          itemBuilder: (_, index) {
                            return CartItemView(
                              item: provider.getCartItems()[index],
                              updateCart: () {
                                if (provider.getCartItems().isEmpty) {
                                  setState(() {
                                    provider.cartItems = [];
                                  });
                                }
                              },
                              deleteCart: () {
                                setState(() {
                                  provider.getCartItems();
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              startScreenF(
                                  context,
                                  ClientsScreen(
                                    makeOrderModel: MakeOrderModel(
                                        "",
                                        provider
                                            .getCartItems()
                                            .map((e) =>
                                                MakeOrderProduct(e.tovarId, e.cartCount, e.sena ?? 0, e.cartTotalPrice))
                                            .toList(),
                                        PrefUtils.getTradeVersion()),
                                  ));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.LIGHT_BLACK),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Umumiy summa : ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        provider.getTotalSum().formattedAmountString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    (PrefUtils.getTradeVersion() == false) ? "Tekshirish" : "Buyurtma berish",
                                    style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                      color: (PrefUtils.getTradeVersion() == false) ? Colors.yellow : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesEmptyCart,
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "Hozircha savat bo'sh !",
                            style: TextStyle(color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  );
          },
          onViewModelReady: (viewModel) {
            viewModel.errorData.listen((event) {
              showError(context, event);
            });

            _busEventListener = eventBus.on<EventModel>().listen((event) async {
              if (event.event == EVENT_UPDATE_CART) {
                setState(() {

                });
              }
            });
          },
        );
      },
    );
  }
}
