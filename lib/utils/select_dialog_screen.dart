// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
//
// import '../model/item_model.dart';
// import 'colors.dart';
// import 'custom_views.dart';
//
// class SelectDialogScreen extends StatefulWidget {
//   ItemModel? checkedItem;
//   List<ItemModel> items = [];
//   ItemModel? selectedItem;
//
//   SelectDialogScreen(this.checkedItem, {required this.items, Key? key}) : super(key: key);
//
//   @override
//   _SelectDialogScreenState createState() => _SelectDialogScreenState();
// }
//
// class _SelectDialogScreenState extends State<SelectDialogScreen> {
//   var firstLaunch = true;
//   List<ItemModel> lists = [];
//
//   @override
//   void initState() {
//     lists = widget.items;
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     if (firstLaunch) {
//       firstLaunch = false;
//       setState(() {
//         debugPrint("${widget.items.length}");
//         if (widget.checkedItem == null || widget.checkedItem?.id == 0) {
//           widget.selectedItem = widget.items.firstOrNull;
//         } else {
//           for (var element in widget.items) {
//             if (element.id == widget.checkedItem?.id) {
//               widget.selectedItem = element;
//             }
//           }
//         }
//       });
//     }
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Бирини танланг"),
//         ),
//         body: Container(
//           margin: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomViews.buildSearchTextField("Қидирув", onChanged: (text) {
//                 setState(() {
//                   lists =
//                       widget.items.where((element) => element.name.toUpperCase().contains(text.toUpperCase())).toList();
//                 });
//               }),
//               Expanded(
//                   child: ListView.builder(
//                       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//                       itemCount: lists.length,
//                       itemBuilder: (_, position) {
//                         var item = lists[position];
//                         return Container(
//                           margin: EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
//                               borderRadius: BorderRadius.circular(4),
//                               color: AppColors.LIGHT_GRAY_COLOR),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 widget.selectedItem = item;
//                               });
//                             },
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     widget.selectedItem?.id == item.id ? Icons.radio_button_on : Icons.radio_button_off,
//                                     color: widget.selectedItem?.id == item.id ? AppColors.COLOR_PRIMARY : AppColors.HINT_COLOR,
//                                   ),
//                                   SizedBox(width: 16),
//                                   Expanded(
//                                       child: Text(item.name,
//                                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       })),
//               Container(
//                 margin: EdgeInsets.only(top: 16),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context, widget.selectedItem);
//                     },
//                     child: Text("Танлаш")),
//               )
//             ],
//           ),
//         ));
//   }
// }
