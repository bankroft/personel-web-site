import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      image: null,
      packageImage: PackageImage.Image_2,
      subTitle: '暂无数据~',
      // titleTextStyle: TextStyle(
      //   fontSize: 22,
      //   color: Color(0xff9da9c7),
      //   fontWeight: FontWeight.w500,
      // ),
      // subtitleTextStyle: TextStyle(
      //   fontSize: 14,
      //   color: Color(0xffabb8d6),
      // ),
      hideBackgroundAnimation: true,
    );
  }
}
