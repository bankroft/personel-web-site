import 'dart:convert';
import 'package:intl/intl.dart';

import "package:dio/dio.dart";
import 'package:crypto/crypto.dart';

const _host = 'lighthouse.tencentcloudapi.com';
// const _host = 'tencentcloudapi.bankroft.cn:58443';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  void reset({
    required String secretID,
    required String secretKey,
  }) {
    dio.interceptors.clear();
    dio.interceptors.add(CustomInterceptors(
      secretID: secretID,
      secretKey: secretKey,
    ));
  }

  static final BaseOptions _baseOptions = BaseOptions(
    method: 'Post',
    baseUrl: 'https://$_host',
    connectTimeout: 5000,
    receiveTimeout: 100000,
    headers: {
      // 'Content-Type': 'application/json; charset=utf-8',
      'content-type': 'application/json; charset=utf-8',
      'Host': _host,
      'X-TC-Region': 'ap-shanghai',
      'X-TC-Version': '2020-03-24',
      'X-TC-Language': 'zh-CN',
      // 'Authorization': 'TC3-HMAC-SHA256 Credential=$_secretID/2021-01-30/lighthouse/tc3_request, SignedHeaders=content-type;host, Signature=c2a4f4863eb3f7f7cbbfb5bb2e1a34cd0c40b0826b1a073ccf6c98396da6373d' 签名
      // 'X-TC-Timestamp': '1612021133' 时间戳
      // 'X-TC-Action': '' 操作的接口名称
    },
  );
  Dio dio = Dio(_baseOptions);

  Future<Response> post(
      {String url = '',
      Map<String, String> params = const {},
      dynamic body = '',
      String action = ''}) {
    return dio.post(
      url,
      queryParameters: params,
      data: body,
      options: Options(
        headers: {
          'X-TC-Action': action,
        },
      ),
    );
  }
}

class CustomInterceptors extends InterceptorsWrapper {
  final String secretID;
  final String secretKey;

  CustomInterceptors({
    required this.secretID,
    required this.secretKey,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    options.headers['X-TC-Timestamp'] = '$timestamp';
    options.headers['Authorization'] =
        _getAuthorization(formattedDate, timestamp, json.encode(options.data));
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  String _getAuthorization(String date, int timestamp, String payload) {
    const service = 'lighthouse';
    var hashedRequestPayload = sha256hex(payload);
    final canonicalRequest =
        'POST\n/\n\ncontent-type:application/json; charset=utf-8\nhost:$_host\n\ncontent-type;host\n$hashedRequestPayload';
    final credentialScope = '$date/$service/tc3_request';
    final hashedCanonicalRequest = sha256hex(canonicalRequest);
    final stringToSign =
        'TC3-HMAC-SHA256\n$timestamp\n$credentialScope\n$hashedCanonicalRequest';
    final secretDate = hmacsha256Int(date, utf8.encode("TC3$secretKey"));
    final secretService = hmacsha256Int(service, secretDate);
    final secretSigning = hmacsha256Int('tc3_request', secretService);
    final signature = hmacsha256Hex(stringToSign, secretSigning);
    return 'TC3-HMAC-SHA256 Credential=$secretID/$credentialScope, SignedHeaders=content-type;host, Signature=$signature';
  }

  String sha256hex(String s) {
    return sha256.convert(utf8.encode(s)).toString();
  }

  String hmacsha256Hex(String s, List<int> key) {
    return Hmac(sha256, key).convert(utf8.encode(s)).toString();
  }

  List<int> hmacsha256Int(String s, List<int> key) {
    return Hmac(sha256, key).convert(utf8.encode(s)).bytes;
  }
}
