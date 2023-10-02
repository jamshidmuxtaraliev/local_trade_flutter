import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_trade_flutter/api/main_viewmodel.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';
import 'package:local_trade_flutter/utils/extensions.dart';
import 'package:money_input_formatter/money_input_controller.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:badges/badges.dart' as badge;

import '../../../generated/assets.dart';
import '../../../services/event_bus.dart';
import '../../../services/providers.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/pref_utils.dart';
import '../../../utils/utils.dart';
import '../../models/event_model.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  var barcodeController = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isOpened = false;
  var badgeCount = 0;

  StreamSubscription? busEventListener;

  @override
  void dispose() {
    controller?.dispose();
    busEventListener?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();

    super.reassemble();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        eventBus.fire(EventModel(event: EVENT_BARCODE, data: scanData.code));
        await controller.pauseCamera();
      });
      vibrateLight();
      print("scandata = ${scanData.code}");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null && mounted) {
      setState(() {
        controller!.resumeCamera();
      });
    }
    return Consumer<Providers>(
      builder: (context, provider, child) {
        badgeCount = provider.getCartItems().length;
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
                  "BDM Local Savdo",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                actions: [
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
              body: Column(
                children: [
                  TextField(
                    maxLength: 15,
                    controller: barcodeController,
                    style: TextStyle(
                      color: AppColors.BLACK.withOpacity(.9),
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      counterText: "",
                      prefixIcon: const Icon(CupertinoIcons.barcode),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (barcodeController.text == "") {
                            return;
                          }
                          viewModel.getProductsByBarcode(barcodeController.text);
                          clearFocus(context);
                        },
                        child: const Icon(Icons.done_all),
                      ),
                      border: InputBorder.none,
                      hintMaxLines: 1,
                      hintText: "Shtrix kod...",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: getScreenHeight(context),
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              setState(() async {
                                Fluttertoast.showToast(msg: "Resume camera");
                                await controller?.resumeCamera();
                                setState(() {
                                  barcodeController.clear();
                                });
                              });
                            },
                            child: SizedBox(
                              width: getScreenWidth(context),
                              height: getScreenHeight(context),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          onViewModelReady: (viewModel) {
            viewModel.errorData.listen((event) {
              showError(context, event);
            });

            viewModel.dbProductStreamData.listen((event) {
              if (event.length > 0) {
                showAdd2CartSheet(provider, event.first);
              } else {
                showWarning(context, "Mahsulot topilmadi");
              }
            });

            busEventListener = eventBus.on<EventModel>().listen((event) {
              if (event.event == EVENT_UPDATE_CART) {
                setState(() {
                  badgeCount = event.data;
                });
              } else if (event.event == EVENT_BARCODE) {
                viewModel.getProductsByBarcode(event.data);
                barcodeController.text = event.data;
                print("barcode: " + event.data);
              }
            });
          },
        );
      },
    );
  }

  void showAdd2CartSheet(Providers provider, ProductModel productModel) {
    var cartCount = 0.0;
    var cartPrice = 0.0;
    var totalPrice = 0.0;
    var cartCountController = TextEditingController();
    var cartPriceController = MoneyInputController();
    var totalPriceController = MoneyInputController();
    cartCount = PrefUtils.getCartCount(productModel.tovarId);
    print(cartCount);
    if (cartCount != 0.0) {
      cartCountController.text = cartCount.formattedAmountString();
      cartPriceController.text = productModel.cartPrice.formattedAmountString();
      totalPriceController.text = (cartCount * productModel.cartPrice).formattedAmountString();
    } else {
      cartCountController.text = "1";
      cartPriceController.text = (productModel.sena ?? 0).formattedAmountString();
      totalPriceController.text = (productModel.sena ?? 0).formattedAmountString();
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
                          imageUrl: "${PrefUtils.getBaseImageUrl()}${productModel.foto}",
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
                        productModel.tovar,
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
                            (productModel.ostatka).formattedAmountString(),
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
                                if (cartCount > 0 && cartCount < productModel.ostatka) {
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
                            productModel.yedIzm,
                            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                          InkWell(
                              onTap: () {
                                setState2(() {
                                  cartCount =
                                      double.parse(cartCountController.text.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                                  if (cartCount < productModel.ostatka) {
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
                            (productModel.optom_narx ?? 0.0).formattedAmountString(),
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
                                productModel.ostatka) {
                              Fluttertoast.showToast(msg: "Mahsulot miqdori ombordagidan kop korsatilgan");
                              return;
                            } else if (cartPrice < (productModel.optom_narx ?? 0)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Mahsulot narxi tannarxdan past bo'lmasligi kerak. \n Tannarx: ${(productModel.optom_narx ?? 0).formattedAmountString()}");
                              return;
                            }

                            setState(() {
                              productModel.cartCount = cartCount;
                              productModel.cartPrice = cartPrice;
                            });

                            provider.addToCart(
                                productModel.tovarId, cartCount, cartPrice, cartCount * productModel.cartPrice);
                            int countBadge = PrefUtils.getCartList().length;
                            eventBus.fire(EventModel(event: EVENT_UPDATE_BADGE, data: countBadge));
                            Navigator.of(context).pop();
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
