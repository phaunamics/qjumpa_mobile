class PaystackApiResponse {
  String? message;
  int? statusCode;
  Object? data;
  Object? error;

  PaystackApiResponse({this.message, this.statusCode, this.data, this.error});

  @override
  String toString() =>
      "ApiResponse:: message => $message, statusCode => $statusCode, data => $data, error => $error";
}
