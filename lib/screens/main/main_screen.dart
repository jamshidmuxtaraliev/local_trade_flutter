import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_trade_flutter/screens/main/cart/cart_screen.dart';
import 'package:local_trade_flutter/screens/main/favorite/favorite_screen.dart';
import 'package:local_trade_flutter/screens/main/products_screen.dart';
import 'package:local_trade_flutter/screens/main/qr_code/scanner_screen.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:badges/badges.dart' as badge;

import '../../api/main_viewmodel.dart';
import '../../generated/assets.dart';
import '../../services/event_bus.dart';
import '../../services/providers.dart';
import '../../utils/constants.dart';
import '../../utils/pref_utils.dart';
import '../../utils/utils.dart';
import '../models/event_model.dart';
import '../splash/splash_screen.dart';
import 'home/home_screen.dart';

List<Widget> screens = [HomeScreen(), FavoriteScreen(), CartScreen()];

class MainScreen extends StatefulWidget {
  final int selectedIndex;

  MainScreen({this.selectedIndex = 0, Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var selectedScreenIndex = 0;
  var badgeCount = 0;
  StreamSubscription? busEventListener;

  final _advancedDrawerController = AdvancedDrawerController();
  PackageInfo? _packageInfo;

  @override
  void didChangeDependencies() {
    getPackageInfo();
    selectedScreenIndex = widget.selectedIndex;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    badgeCount = PrefUtils.getCartList().length;
    super.initState();
  }

  void getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, provider, child) {
        selectedScreenIndex = provider.getIndex();

        return ViewModelBuilder<MainViewModel>.reactive(
          viewModelBuilder: () {
            return MainViewModel();
          },
          builder: (context, viewModel, _) {
            return AdvancedDrawer(
              backdropColor: AppColors.COLOR_PRIMARY,
              controller: _advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 500),
              animateChildDecoration: true,
              rtlOpening: false,
              // openScale: 1.0,
              disabledGestures: false,
              childDecoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 0.0,
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              drawer: SafeArea(
                child: ListTileTheme(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        Assets.iconsLogo1,
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          PrefUtils.getUser()?.name ?? "Xodimi",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "semibold"),
                        ),
                      ),
                      Text(
                        PrefUtils.getUser()?.phone ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "semibold"),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ListTile(
                        onTap: () async {
                          if (provider.getCartItems().isNotEmpty) {
                            showWarning(context, "To'lov turini almashtirishdan oldin Savatni bo'shating !");
                            return;
                          }
                          showMyBottomSheet(context, StatefulBuilder(builder: (ctx, setState2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To'lov turi",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    var item = viewModel.priceTypeList[index];
                                    return InkWell(
                                      onTap: () {
                                        setState2(() {
                                          PrefUtils.setPriceType(item.id);
                                          loadData(viewModel);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: ListTile(
                                        leading: (PrefUtils.getPriceType() == item.id)
                                            ? const Icon(Icons.radio_button_checked)
                                            : const Icon(Icons.radio_button_off),
                                        title: Text(item.name),
                                      ),
                                    );
                                  },
                                  itemCount: viewModel.priceTypeList.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 12),
                                )
                              ],
                            );
                          }));
                        },
                        leading: const Icon(Icons.monetization_on_outlined),
                        title: const Text("To'lov turi"),
                      ),
                      ListTile(
                        onTap: () async {
                          showMyBottomSheet(context, StatefulBuilder(builder: (ctx, setState2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Savdo jarayoni",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                GestureDetector(
                                  child: ListTile(
                                    leading: (PrefUtils.getTradeVersion() == true)
                                        ? const Icon(Icons.radio_button_checked)
                                        : const Icon(Icons.radio_button_off),
                                    title: Text("Savdo"),
                                  ),
                                  onTap: () {
                                    if (provider.getCartItems().isNotEmpty) {
                                      showWarning(context, "Savat bo'shatilishiga rozimisiz ?", pressOk: () {
                                        PrefUtils.clearCart();
                                        eventBus.fire(EventModel(event: EVENT_UPDATE_CART, data: 0));
                                        PrefUtils.setTradeVersion(true);
                                        provider.setIndex(provider.getIndex());
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      setState2(() {
                                        PrefUtils.setTradeVersion(true);
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: ListTile(
                                    leading: (PrefUtils.getTradeVersion() == false)
                                        ? const Icon(Icons.radio_button_checked)
                                        : const Icon(Icons.radio_button_off),
                                    title: const Text("Tekshirish"),
                                  ),
                                  onTap: () {
                                    setState2(() {
                                      eventBus.fire(EventModel(event: EVENT_UPDATE_CART, data: 0));
                                      PrefUtils.setTradeVersion(false);
                                      provider.setIndex(provider.getIndex());
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            );
                          }));
                        },
                        leading: const Icon(Icons.shopping_basket_outlined),
                        title: const Text('Savdo jarayoni'),
                      ),
                      ListTile(
                        onTap: () {
                          showMyBottomSheet(context, StatefulBuilder(builder: (ctx, setState2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tilni o'zgartirish",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                InkWell(
                                  onTap: () {
                                    PrefUtils.setLang("uz");
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        Assets.imagesUzFlag,
                                        width: 80,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Text(
                                        "O'zbek tili",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    PrefUtils.setLang("ru");
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        Assets.imagesRuFlag,
                                        width: 80,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Text(
                                        "Русский язык",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                )
                              ],
                            );
                          }));
                        },
                        leading: const Icon(Icons.g_translate),
                        title: const Text("Tilni o'zgartirish"),
                      ),
                      ListTile(
                        onTap: () {
                          showConfirmDialog(context, "Tizimdan chiqishga ishonchingiz komilmi ?", pressOk: () {
                            PrefUtils.setToken("");
                            PrefUtils.clearAll();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => SplashScreen()),
                            );
                          }, noButton: true, forSingOut: true);
                        },
                        leading: const Icon(Icons.logout),
                        title: Text('Tizimdan chiqish'),
                      ),
                      const Spacer(),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: Text('Biznes Dasturlash Markazi\n'
                              '${_packageInfo?.appName}'
                              'v${_packageInfo?.version} ${_packageInfo?.buildNumber},'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: DefaultTabController(
                initialIndex: 0,
                length: 4,
                child: Scaffold(
                    backgroundColor: AppColors.LIGHT_GRAY_COLOR,
                    appBar: AppBar(
                      backgroundColor: AppColors.LIGHT_BLACK,
                      elevation: 0,
                      title: const Text(
                        "Bdm Local Trade +",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      leading: IconButton(
                        onPressed: _handleMenuButtonPressed,
                        icon: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: _advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                value.visible ? Icons.clear : Icons.menu,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              loadData(viewModel);
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 20,
                            )),
                        IconButton(onPressed: () {
                          startScreenF(context, const ScannerScreen());
                        }, icon: const Icon(Icons.qr_code_scanner_outlined, size: 20)),
                        IconButton(
                            onPressed: () {
                              startScreenF(
                                  context, ProductsScreen(categoryItem: CategoryModel("", "Barcha Mahsulotlar", "")));
                            },
                            icon: const Icon(Icons.search, size: 20)),
                      ],
                      iconTheme: const IconThemeData(color: Colors.white),
                    ),
                    body: IndexedStack(index: selectedScreenIndex, children: screens),
                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black45.withOpacity(0.3),
                            offset: const Offset(1, 1),
                            blurRadius: 5,
                            spreadRadius: 3)
                      ]),
                      child: SalomonBottomBar(
                        currentIndex: selectedScreenIndex,
                        backgroundColor: AppColors.LIGHT_GRAY_COLOR,
                        onTap: (index) => setState(() {
                          selectedScreenIndex = index;
                          provider.setIndex(selectedScreenIndex);
                        }),
                        items: [
                          SalomonBottomBarItem(
                            icon: const Icon(Icons.home),
                            title: const Text("Asosiy"),
                            selectedColor: AppColors.COLOR_PRIMARY,
                          ),
                          SalomonBottomBarItem(
                            icon: const Icon(Icons.favorite),
                            title: const Text("Saqlanganlar"),
                            selectedColor: AppColors.COLOR_PRIMARY,
                          ),
                          SalomonBottomBarItem(
                            icon: badge.Badge(
                              showBadge: (provider.getCartItems().isNotEmpty),
                                badgeAnimation: const badge.BadgeAnimation.scale(),
                                badgeContent: Text(
                                  badgeCount.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                child: const Icon(Icons.shopping_cart)),
                            title: const Text("Savat"),
                            selectedColor: AppColors.COLOR_PRIMARY,
                          ),
                        ],
                      ),
                    )
                    // drawer: DrawerScreen(),
                    ),
              ),
            );
          },
          onViewModelReady: (viewModel) {
            viewModel.getUser();
            loadData(viewModel);

            viewModel.errorData.listen((event) {
              showError(context, event);
            });

            viewModel.getUserData.listen((event) {
              PrefUtils.setUser(event);
            });

            busEventListener = eventBus.on<EventModel>().listen((event) {
              if (event.event == EVENT_UPDATE_CART) {
                setState(() {
                  badgeCount = event.data;
                });
              }
            });
          },
        );
      },
    );
  }

  Future<void> loadData(MainViewModel viewModel) async {
    Fluttertoast.showToast(msg: "Mahsulotlar yuklanmoqda...");
    viewModel.getProductsFromURL();
    viewModel.getType();
    Fluttertoast.showToast(msg: "Mahsulotlar yangilandi !");
  }
}
