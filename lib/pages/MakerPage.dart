import 'package:cyber_waves/wigets/MakerMain.dart';
import 'package:flutter/material.dart';

class MakerPage extends StatelessWidget {
  const MakerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: MakerMain(rpx: MediaQuery.of(context).size.width / 750),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
