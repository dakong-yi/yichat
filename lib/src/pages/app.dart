// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, unused_import,  prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_service_implement.dart';
import 'package:yichat/utils/init_step.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:yichat/src/chat.dart';
import 'package:yichat/src/config.dart';
import 'package:yichat/src/pages/home_page.dart';
import 'package:yichat/src/pages/login.dart';
import 'package:yichat/src/provider/custom_sticker_package.dart';
import 'package:yichat/src/provider/local_setting.dart';
import 'package:yichat/src/provider/login_user_Info.dart';
import 'package:yichat/src/provider/theme.dart';
import 'package:yichat/src/routes.dart';
import 'package:yichat/utils/constant.dart';
import 'package:yichat/utils/push/channel/channel_push.dart';
import 'package:yichat/utils/push/push_constant.dart';
import 'package:yichat/utils/theme.dart';
import 'package:yichat/utils/toast.dart';
import 'package:yichat/utils/unicode_emoji.dart';
import 'package:uni_links/uni_links.dart';
import 'package:yichat/src/launch_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:yichat/yiim/yiim_manager.dart';

bool isInitScreenUtils = false;

class YiChatApp extends StatefulWidget {
  const YiChatApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _YiChatAppState();
}

class _YiChatAppState extends State<YiChatApp> with WidgetsBindingObserver {
  var subscription;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final YIIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  final TUIChatGlobalModel tuiChatViewModel =
      serviceLocator<TUIChatGlobalModel>();
  bool _initialURILinkHandled = false;
  bool _isInitIMSDK = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (PlatformUtils().isIOS) {
      return;
    }
    print("--" + state.toString());
    int? unreadCount = await _getTotalUnreadCount();
    switch (state) {
      case AppLifecycleState.inactive:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        if (unreadCount != null) {
          ChannelPush.setBadgeNum(unreadCount);
        }
        break;
      case AppLifecycleState.resumed:
        await _checkIfConnected();
        _coreInstance.setOfflinePushStatus(status: AppStatus.foreground);
        break;
      case AppLifecycleState.paused:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        break;
      case AppLifecycleState.detached:
        // ignore: todo
        // TODO: Handle this case.
        break;
    }
  }

  Future<int?> _getTotalUnreadCount() async {
    final res = await _sdkInstance
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (res.code == 0) {
      return res.data ?? 0;
    }
    return null;
  }

  Future<void> _checkIfConnected() async {
    final res = await _sdkInstance.getLoginUser();
    if (res.data != null && res.data!.isNotEmpty) {
      return;
    } else if (res.data == null) {
      await initIMSDKAndAddIMListeners();
      InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
      return;
    } else if (res.data!.isEmpty) {
      InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
      return;
    } else {
      return;
    }
  }

  onKickedOffline() async {
// 被踢下线
    try {
      InitStep.directToLogin(context);
      // 去掉存的一些数据
      InitStep.removeLocalSetting();
      // ignore: empty_catches
    } catch (err) {}
  }

  Future<String> getLanguage() async {
    final String? deviceLocale =
        WidgetsBinding.instance.window.locale.toLanguageTag();
    final AppLocale appLocale = I18nUtils.findDeviceLocale(deviceLocale);
    switch (appLocale) {
      case AppLocale.zhHans:
        return "zh-Hans";
      case AppLocale.zhHant:
        return "zh-Hant";
      case AppLocale.en:
        return "en";
      case AppLocale.ja:
        return "ja";
      case AppLocale.ko:
        return "ko";
    }
  }

  getLoginUserInfo() async {
    final res = await _sdkInstance.getLoginUser();
    if (res.code == 0) {
      final result = await _sdkInstance.getUsersInfo(userIDList: [res.data!]);

      if (result.code == 0) {
        Provider.of<LoginUserInfo>(context, listen: false)
            .setLoginUserInfo(result.data![0]);
      }
    }
  }

  WebSocketChannel? _channel;

  bool initWebSocket() {
    if (_channel == null) {
      _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8081/ws'));
      _channel?.sink.add('{"action":"login","data":{"user_id":"user1"}}');
      _channel?.stream.listen((message) {
        message =
            '{"msgID":"1","timestamp":1635993600,"userID":"user1","sender":"user1","nickName":"John","faceUrl":"https://www.bugela.com/cjpic/frombd/1/253/1943132031/773911012.jpg","elemType":1,"textElem":{"text":"Hello, this is a mock text message"}}';
        V2TimMessage msg = V2TimMessage.fromJson(jsonDecode(message));
        tuiChatViewModel.advancedMsgListener.onRecvNewMessage(msg);
        print(message);
      });
      return true;
    }

    // WebSocket 已经被初始化，返回 false
    return false;
  }

  initIMSDKAndAddIMListeners() async {
    if (_isInitIMSDK) return;
    final LocalSetting localSetting =
        Provider.of<LocalSetting>(context, listen: false);
    await localSetting.loadSettingsFromLocal();
    final language = localSetting.language ?? await getLanguage();
    localSetting.updateLanguageWithoutWriteLocal(language);
    final isInitSuccess = await _sdkInstance.initSDK(
        sdkAppID: 0,
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        listener: V2TimSDKListener(
          onConnectFailed: (code, error) {
            ToastUtils.toast(TIM_t("即时通信 SDK 初始化失败"));
          },
          onConnecting: () {
            ToastUtils.toast(TIM_t("即时通信 SDK 正在初始化"));
          },
          onConnectSuccess: () {
            ToastUtils.toast(TIM_t("即时通信 SDK 初始化成功"));
          },
        ));
    if (isInitSuccess.code != 0) {
      ToastUtils.toast(TIM_t("即时通信 SDK初始化失败"));
      return;
    } else {}
    _isInitIMSDK = true;
  }

  initApp() {
    // 检测登录状态
    InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
  }

  initScreenUtils() {
    if (isInitScreenUtils) return;

    ScreenUtil.init(
      context,
      designSize: const Size(750, 1624),
      minTextAdapt: true,
    );
    isInitScreenUtils = true;
  }

  initRouteListener() {
    final routes = Routes();
    routes.addListener(() {
      final pageType = routes.pageType;
      if (pageType == "loginPage") {
        InitStep.directToLogin(context);
      }

      if (pageType == "homePage") {
        InitStep.directToHomePage(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initApp();
    initRouteListener();
  }

  @override
  dispose() {
    super.dispose();
    print("========isDispose-=========");
    WidgetsBinding.instance.removeObserver(this);
    Routes().dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtils();
    ToastUtils.init(context);
    return const LaunchPage();
  }
}
