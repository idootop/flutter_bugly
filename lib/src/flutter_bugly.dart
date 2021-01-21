import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'bean/init_result_info.dart';

class FlutterBugly {
  FlutterBugly._();

  static const MethodChannel _channel =
      const MethodChannel('crazecoder/flutter_bugly');

  ///初始化
  static Future<InitResultInfo> init({
    String androidAppId,
    String iOSAppId,
    String channel, //自定义渠道标识
    int initDelay = 0, //延迟初始化,单位秒
  }) async {
    assert((Platform.isAndroid && androidAppId != null) ||
        (Platform.isIOS && iOSAppId != null));
    Map<String, Object> map = {
      "appId": Platform.isAndroid ? androidAppId : iOSAppId,
      "channel": channel,
      "initDelay": initDelay,
    };
    final String result = await _channel.invokeMethod('initBugly', map);
    Map resultMap = json.decode(result);
    var resultBean = InitResultInfo.fromJson(resultMap);
    return resultBean;
  }

  ///自定义渠道标识
  static Future<Null> setAppChannel(String channel) async {
    Map<String, Object> map = {
      "channel": channel,
    };
    await _channel.invokeMethod('setAppChannel', map);
  }

  ///设置用户标识
  static Future<Null> setUserId(String userId) async {
    Map<String, Object> map = {
      "userId": userId,
    };
    await _channel.invokeMethod('setUserId', map);
  }

  ///设置标签
  ///userTag 标签ID，可在网站生成
  static Future<Null> setUserTag(int userTag) async {
    Map<String, Object> map = {
      "userTag": userTag,
    };
    await _channel.invokeMethod('setUserTag', map);
  }

  ///设置关键数据，随崩溃信息上报
  static Future<Null> putUserData(
      {@required String key, @required String value}) async {
    assert(key != null && key.isNotEmpty);
    assert(value != null && value.isNotEmpty);
    Map<String, Object> map = {
      "key": key,
      "value": value,
    };
    await _channel.invokeMethod('putUserData', map);
  }

  ///上报自定义异常信息，data为文本附件
  static Future<Null> uploadException(
      {String message, String stack, String tag}) async {
    var map = {};
    map.putIfAbsent("crash_message", () => message ?? '');
    map.putIfAbsent("crash_detail", () => stack ?? '');
    map.putIfAbsent("crash_tag", () => tag ?? '');
    await _channel.invokeMethod('postCatchedException', map);
  }
}
