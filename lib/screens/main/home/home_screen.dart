import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:local_trade_flutter/api/main_viewmodel.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';
import 'package:local_trade_flutter/services/boxes.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:local_trade_flutter/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../services/event_bus.dart';
import '../../../services/providers.dart';
import '../../../utils/utils.dart';
import '../../../view/category_item_view.dart';
import '../../models/event_model.dart';
import '../products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  StreamSubscription? _busEventListener;
  List<CategoryModel> filteredBrands = [];
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, provider, child) {
        return ViewModelBuilder.reactive(
          viewModelBuilder: () {
            return MainViewModel();
          },
          builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
            return WillPopScope(
              onWillPop: () async {
                if (searchController.text.isEmpty) {
                  return true;
                } else {
                  searchController.clear();
                  setState(() {
                    filteredBrands = viewModel.dbCategoryList;
                  });
                }
                return false;
              },
              child: Scaffold(body: LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      viewModel.getCategoriesByKeyword();
                      searchController.clear();
                      clearFocus(context);
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                                      // shadow
                                      spreadRadius: .5,
                                      // set effect of extending the shadow
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
                                      filteredBrands = viewModel.dbCategoryList;
                                    }
                                    filteredBrands = viewModel.dbCategoryList
                                        .where((element) =>
                                            (element.Kategoriya.toLowerCase().contains(keyword.toLowerCase())))
                                        .toList();
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0),
                                    hintText: "Kategoriyani qidiring...",
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
                                            filteredBrands = viewModel.dbCategoryList;
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
                            (filteredBrands.isNotEmpty)
                                ? GridView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: filteredBrands.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 0,
                                        childAspectRatio: 0.74,
                                        crossAxisCount: 3),
                                    itemBuilder: (_, index) {
                                      var item = filteredBrands[index];
                                      return InkWell(
                                        onTap: () {
                                          startScreenF(
                                              context,
                                              ProductsScreen(
                                                categoryItem: item,
                                              ));
                                        },
                                        child: CategoryCircleItemView(item: item),
                                      );
                                    },
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Assets.imagesEmptyProduct,
                                        width: 150,
                                        height: 150,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Text(
                                          "Mahsulotlar mavjud emas !",
                                          style: TextStyle(color: Colors.blueGrey),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
            );
          },
          onViewModelReady: (viewModel) {
            viewModel.errorData.listen((event) {
              showError(context, event);
            });

            viewModel.getCategoriesByKeyword();

            viewModel.categoryDBData.listen((event) {
              setState(() {
                filteredBrands = event;
                provider.setIndex(provider.getIndex());
              });
              viewModel.getCategoriesFromAPI();
              Fluttertoast.showToast(msg: "bbbbbbbbb");
            });

            viewModel.categoryData.listen((event) async {
              setState(() {
                filteredBrands = event;
                provider.setIndex(provider.getIndex());
              });
              Fluttertoast.showToast(msg: "aaaaaaaaa");
            });

            _busEventListener = eventBus.on<EventModel>().listen((event) async {});
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _busEventListener?.cancel();
    super.dispose();
  }
}
