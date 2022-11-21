import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class HTTPRequestService {
  static final HTTPRequestService _instance = HTTPRequestService._internal();
  factory HTTPRequestService() => _instance;
  bool _isInit = false;

  static final BaseOptions _baseOptions = BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 100000,
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0',
      'Accept-Encoding': 'gzip, deflate',
      'Accept': '*/*',
      'Connection': 'keep-alive'
    },
  );
  Dio dio = Dio(_baseOptions);

  HTTPRequestService._internal() {
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  void init() async {
    await requestCookie().then((value) {
      if (value) {
        _isInit = true;
      }
    });
  }

  Future<bool> requestCookie() async {
    final response = await dio.post(
      "https://passport.weibo.com/visitor/genvisitor",
      data: FormData.fromMap({
        "cb": "gen_callback",
        "fp": {
          "os": "1",
          "browser": "Gecko60,0,0,0",
          "fonts": "undefined",
          "screenInfo": "1536*864*24",
          "plugins": ""
        }
      }),
    );
    if (response.statusCode != 200) {
      return false;
    }
    RegExp regExp = RegExp(r"\((.*)\)");
    final matchResult = regExp.firstMatch(response.data);
    if (matchResult == null) {
      return false;
    }
    final tidData = json.decode(matchResult[1]!)["data"];
    final tid = tidData['tid'] as String;
    String confidence = tidData['confidence'] ?? "";
    final newTid = tidData['new_tid'] as bool;
    int where = 2;
    if (newTid) {
      where = 3;
    }
    while (confidence.length < 3) {
      confidence = '0' + confidence;
    }
    tid.replaceAll("+", "%2b");
    tid.replaceAll("=", "%3d");
    final response2 = await dio
        .get("https://passport.weibo.com/visitor/visitor", queryParameters: {
      "a": "incarnate",
      "t": tid,
      "w": where.toString(),
      "c": confidence,
      "gc": "",
      "cb": "cross_domain",
      "from": "weibo",
    });
    if (response2.statusCode != 200) {
      return false;
    }
    final matchResult2 = regExp.firstMatch(response2.data);
    if (matchResult2 == null) {
      return false;
    }
    final subData = json.decode(matchResult2[1]!) as Map;
    if (!(subData["msg"] ?? "").contains("succ")) {
      // tid 不合法
      return false;
    }
    final tmp = subData["data"] as Map;
    await dio
        .get("https://login.sina.com.cn/visitor/visitor", queryParameters: {
      "a": "crossdomain",
      "cb": "return_back",
      "s": tmp["sub"],
      "sp": tmp["subp"],
      "from": "weibo",
    });
    return true;
  }

  Future<Response> get({
    required String url,
    Map<String, String> params = const {},
  }) async {
    if (!_isInit) {
      await requestCookie();
    }
    return dio.get(
      url,
      queryParameters: params,
    );
  }
}
