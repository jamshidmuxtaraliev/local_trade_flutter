import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';
import 'package:local_trade_flutter/screens/splash/splash_screen.dart';
import 'package:local_trade_flutter/services/boxes.dart';
import 'package:local_trade_flutter/services/providers.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:local_trade_flutter/utils/pref_utils.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils.initInstance();
  await Hive.initFlutter();

  // Registering the adapter
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // Opening the box
  await Hive.openBox<ProductModel>('products_table');
  await Hive.openBox<CategoryModel>('brands_table');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final alice = Alice(showNotification: true);

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Providers>(create: (_) {
          return Providers();
        }),
      ],
      child: MaterialApp(
        navigatorKey: MyApp.alice.getNavigatorKey(),
        title: 'LOCAL TRADE +',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.BLACK),
            headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.BLACK),
            bodyMedium: TextStyle(fontSize: 16, color: AppColors.BLACK),
            bodySmall: TextStyle(fontSize: 14, color: AppColors.LIGHT_GRAY_COLOR),
          ),
          primaryColor: AppColors.COLOR_PRIMARY,
          primaryColorDark: AppColors.COLOR_PRIMARY_DARK,
          backgroundColor: Colors.white,
          primarySwatch: Colors.indigo,
          appBarTheme: const AppBarTheme(color: AppColors.COLOR_PRIMARY, elevation: 1),),
        home: SplashScreen(),
        builder: (context, child) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
        },
      ),
    );
  }
}
