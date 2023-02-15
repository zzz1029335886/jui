library bundle_jui_component;

import 'package:flutter/material.dart';
import 'package:jieluoxuan_bundle_base/jieluoxuan_bundle_base.dart';

import 'src/common/jui_refresh.dart';

class JUIComponentBundle extends IBundleRegister {
  @override
  String get bundleName => "JUIComponentBundle";

  @override
  List<GetPage>? bundleGetPageRegister() {
    return null;
  }

  @override
  Future? onBundleLoad() {
    FunctionRegistry.register<State<PagingListWidget>, RequestAction>(
        AppComponentConfig.PagingListWidgetState, (action) {
      return JUIPagingListWidgetState(action);
    });

    return super.onBundleLoad();
  }
}
