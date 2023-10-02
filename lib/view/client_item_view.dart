import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_trade_flutter/screens/models/client_model.dart';
import 'package:local_trade_flutter/utils/extensions.dart';

class ClientItemView extends StatefulWidget {
  ClientModel item;
  ClientItemView({Key? key, required this.item}) : super(key: key);

  @override
  _ClientItemViewState createState() => _ClientItemViewState();
}

class _ClientItemViewState extends State<ClientItemView> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onLongPress: (){
        setState(() {
          widget.item.isOpen =! widget.item.isOpen;
        });
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(CupertinoIcons.person_circle, size: 45, color: Colors.grey,),
              ),
              const SizedBox(width: 12,),
              Text(widget.item.client, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),)
            ],
          ),
          if(widget.item.isOpen) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            const Text("Dollar: "),
            Text((widget.item.dollar == "") ? "0":widget.item.dollar)
          ],),
          if(widget.item.isOpen) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            const Text("So'm: "),
            Text((widget.item.sum == "") ? "0":widget.item.sum)
          ],),
          const Divider(color: Colors.blueGrey,)
        ],
      ),
    );
  }
}
