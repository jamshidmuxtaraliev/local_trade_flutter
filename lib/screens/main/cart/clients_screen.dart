import 'package:flutter/material.dart';
import 'package:local_trade_flutter/api/main_viewmodel.dart';
import 'package:local_trade_flutter/screens/main/cart/success_screen.dart';
import 'package:local_trade_flutter/screens/models/client_model.dart';
import 'package:local_trade_flutter/screens/models/make_order_model.dart';
import 'package:local_trade_flutter/utils/constants.dart';
import 'package:local_trade_flutter/utils/pref_utils.dart';
import 'package:local_trade_flutter/utils/utils.dart';
import 'package:local_trade_flutter/view/client_item_view.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../services/event_bus.dart';
import '../../../utils/colors.dart';
import '../../models/event_model.dart';

class ClientsScreen extends StatefulWidget {
  MakeOrderModel makeOrderModel;

  ClientsScreen({Key? key, required this.makeOrderModel}) : super(key: key);

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<ClientModel> filteredClients = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () {
        return MainViewModel();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.LIGHT_BLACK,
            elevation: 0,
            title: const Text(
              "Mijozni tanlang..",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Stack(
            children: [
              Column(
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
                          if (v.isEmpty) {
                            filteredClients = viewModel.clientList;
                          }
                          filteredClients = viewModel.clientList
                              .where((element) => (element.client.toLowerCase().contains(v.toLowerCase())))
                              .toList();
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          hintText: "Mijozni qidiring...",
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
                                  filteredClients = viewModel.clientList;
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
                    child: (viewModel.progressData)?Container():(filteredClients.isNotEmpty)
                        ? ListView.builder(
                            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: filteredClients.length,
                            itemBuilder: (_, index) {
                              var item = filteredClients[index];
                              return InkWell(
                                onTap: () {
                                  widget.makeOrderModel.clientId = item.clientID.toString();
                                  viewModel.makeOrder(widget.makeOrderModel);
                                },
                                onLongPress: () {},
                                child: ClientItemView(
                                  item: item,
                                ),
                              );
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.imagesEmptyProduct,
                                width: (MediaQuery.of(context).viewInsets.bottom > 0) ? 160 : 200,
                                height: (MediaQuery.of(context).viewInsets.bottom > 0) ? 160 : 200,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text(
                                  "So'rovingiz bo'yicha mijozlar topilmadi!",
                                  style: TextStyle(color: Colors.blueGrey),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.makeOrder(widget.makeOrderModel);
                    },
                    child: Container(
                      width: getScreenWidth(context),
                      height: 45,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.LIGHT_BLACK),
                      child: Text(
                        (PrefUtils.getTradeVersion() == false) ? "Tekshirish" : "Mijozsiz buyurtma berish",
                        style: TextStyle(
                            color: (PrefUtils.getTradeVersion() == false) ? Colors.yellow : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              if (viewModel.progressData) showMyProgress()
            ],
          ),
        );
      },
      onViewModelReady: (viewModel) {
        viewModel.errorData.listen((event) {
          showError(context, event);
        });

        viewModel.clientStreamData.listen((event) {
          setState(() {
            filteredClients = event;
          });
        });

        viewModel.orderStreamData.listen((event) {
          PrefUtils.clearCart();
          Constants.updateCart = [];
          eventBus.fire(EventModel(event: EVENT_UPDATE_CART, data: 0));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => SuccessScreen()));
        });

        viewModel.getClients();
      },
    );
  }
}
