class ApiResponse {
  late final int err;
  late final dynamic data;
  late final dynamic raw;
  ApiResponse({
    required this.err,
    this.data,
    this.raw,
  });

  ApiResponse.fromJson(dynamic data) {
    raw = data;
    if (data?["Response"] != null) {
      data = data["Response"];
      this.data = data;
      if (data?["Error"] == null) {
        err = 0;
        return;
      }
    } else {
      this.data = null;
    }
    err = 1;
  }

  bool isOk() {
    return err == 0;
  }
}
