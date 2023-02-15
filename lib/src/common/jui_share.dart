import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';
import 'package:jui/jui.dart';

class JUIShare {
  static void sheetShow(BuildContext context) {
    JUIBottomSheet.showPageContent(
      trailingWidget: Container(
        width: 0,
      ),
      context: context,
      expand: false,
      title: '分享给好友',
      contentBuilder: (context) {
        return SizedBox(
          height: 196,
          child: Column(
            children: [
              SizedBox(
                height: 107,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 60,
                  children: [
                    JUIButton(
                      title: '微信',
                      iconWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(75, 198, 48, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          IconsJlx.icon_weixin,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      labelPostion: JUIButtonLabelPostion.labelBottom,
                      onPressed: () {},
                    ),
                    JUIButton(
                      title: '朋友圈',
                      iconWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(75, 198, 48, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          IconsJlx.icon_weixin,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      labelPostion: JUIButtonLabelPostion.labelBottom,
                      onPressed: () {},
                    ),
                    JUIButton(
                      title: '复制链接',
                      iconWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(75, 198, 48, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          IconsJlx.icon_weixin,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      labelPostion: JUIButtonLabelPostion.labelBottom,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                height: 56,
                width: double.infinity,
                color: Colors.white,
                child: JUIButton(
                  title: '取消',
                  fontWeight: FontWeight.w500,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
