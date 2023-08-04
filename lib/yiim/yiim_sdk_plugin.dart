import 'package:yichat/yiim/yiim_manager.dart';

/// TencentImSDKPlugin entry
///
class YiImSDKPlugin {
  static YIIMManager? manager;

  static YIIMManager managerInstance() {
    if (manager == null) {
      manager = YIIMManager();
    }

    return manager!;
  }

  static YIIMManager yiIMManager = YiImSDKPlugin.managerInstance();
}
