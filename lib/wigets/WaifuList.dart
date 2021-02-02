import 'package:flutter/material.dart';

class WaifuWidget extends StatelessWidget {
  const WaifuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Column(
        children: [
          Container(
            height: 80 * rpx,
            child: ListTile(
              leading: Container(
                width: 10 * rpx,
              ),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {},
              ),
              title: Center(child: Text("Waifu List")),
            ),
          )
        ],
      ),
    );
  }
}

class WaifuList extends StatelessWidget {
  const WaifuList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(

    );
  }
}
