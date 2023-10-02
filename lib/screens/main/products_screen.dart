import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_trade_flutter/api/main_viewmodel.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:local_trade_flutter/utils/utils.dart';
import 'package:local_trade_flutter/view/product_item_view.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:badges/badges.dart' as badge;

import '../../generated/assets.dart';
import '../../services/event_bus.dart';
import '../../services/providers.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../models/event_model.dart';

class ProductsScreen extends StatefulWidget {
  CategoryModel categoryItem;

  ProductsScreen({Key? key, required this.categoryItem}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<ProductModel> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  String keyword = "";
  var badgeCount = 0;

  StreamSubscription? busEventListener;

  @override
  void dispose() {
    busEventListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, provider, child) {
        badgeCount = provider.getCartItems().length;
        return ViewModelBuilder.reactive(
          viewModelBuilder: () {
            return MainViewModel();
          },
          builder: (context, viewModel, child) {
            return WillPopScope(
              onWillPop: () async {
                if (searchController.text.isEmpty) {
                  return true;
                } else {
                  searchController.clear();
                  setState(() {
                    filteredProducts.clear();
                    filteredProducts = viewModel.dbProductList;
                  });
                }
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.LIGHT_BLACK,
                  elevation: 0,
                  title: Text(
                    widget.categoryItem.Kategoriya,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Mahsulotlar yuklanmoqda !");
                          viewModel.getProductsFromURL();
                          setState(() {
                            searchController.clear();
                            clearFocus(context);
                          });
                        },
                        icon: const Icon(
                          Icons.refresh,
                          size: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: InkWell(
                        onTap: () async {
                          provider.setIndex(2);
                          Navigator.pop(context);
                        },
                        child: badge.Badge(
                          badgeAnimation: const badge.BadgeAnimation.scale(),
                          badgeContent: Text(
                            badgeCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          child: const Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                    ),
                  ],
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: RefreshIndicator(
                  onRefresh: ()async{
                    viewModel.getProductsByCategory(widget.categoryItem.KategoriyaId);
                  },
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20.0,
                                spreadRadius: .5,
                                offset: Offset(
                                  0.0,
                                  5.0,
                                ),
                              )
                            ],
                          ),
                          child: TextField(
                            // textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            onSubmitted: (submittedText) {},
                            controller: searchController,
                            onChanged: (v) {
                              keyword = v;
                              if (keyword.isEmpty) {
                                filteredProducts.clear();
                                filteredProducts = viewModel.dbProductList;
                              }
                              filteredProducts =
                                  viewModel.dbProductList
                                  .where((element) =>
                                      (element.tovarId == keyword) ||
                                      (element.kategoriyaid == keyword) ||
                                      (element.tovar.toLowerCase().contains(keyword.toLowerCase())))
                                  .toList();
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              hintText: "Mahsulot qidiring...",
                              hintStyle: const TextStyle(color: AppColors.GRAY_COLOR),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black38,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      filteredProducts.clear();
                                      filteredProducts = viewModel.dbProductList;
                                    });
                                    searchController.clear();
                                    clearFocus(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    size: 20,
                                    color: Colors.black38,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          )),
                      Expanded(
                        child: (filteredProducts.isNotEmpty)?ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 8, top: 0),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: filteredProducts.length,
                          itemBuilder: (_, index) {
                            var item = filteredProducts[index];
                            return ProductItemView(
                              item: item,
                              () {
                                // setState(() {
                                //   provider.getFav().remove(provider.getFav()[index]);
                                // });
                              },
                            );
                          },
                        ):Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.imagesNoProduct,
                              width: (MediaQuery.of(context).viewInsets.bottom > 0) ? 200 : 240,
                              height: (MediaQuery.of(context).viewInsets.bottom > 0) ? 200 : 240,                            ),
                            const SizedBox(height: 12,),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text("So'rovingiz bo'yicha mahsulotlar topilmadi!", style: TextStyle(color: Colors.blueGrey), textAlign: TextAlign.center,),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          onViewModelReady: (viewModel) {
            viewModel.getProductsByCategory(widget.categoryItem.KategoriyaId);

            viewModel.errorData.listen((event) {
              showError(context, event);
            });

            viewModel.dbProductStreamData.listen((event) {
              setState(() {
                filteredProducts.clear();
                filteredProducts = event;
                print("aaaaaaaaaaaaaaaaa");
              });
            });

            busEventListener = eventBus.on<EventModel>().listen((event) {
              if (event.event == EVENT_UPDATE_CART) {
                setState(() {
                  badgeCount = event.data;
                });
              } else if (event.event == EVENT_UPDATE_PRODUCTS) {
                viewModel.getProductsByCategory(widget.categoryItem.KategoriyaId);
                Fluttertoast.showToast(msg: "Mahsulotlar yangilandi.");
              }
            });
          },
        );
      },
    );
  }
}
