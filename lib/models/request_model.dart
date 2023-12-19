import 'package:apidash/consts.dart';
import 'package:apidash/models/form_data_model.dart';
import 'package:apidash/utils/convert_utils.dart';
import 'package:flutter/foundation.dart';

import 'name_value_model.dart';
import 'response_model.dart';

@immutable
class RequestModel {
  const RequestModel({
    required this.id,
    this.method = HTTPVerb.get,
    this.url = "",
    this.name = "",
    this.description = "",
    this.requestTabIndex = 0,
    this.requestHeaders,
    this.requestParams,
    this.requestBodyContentType = ContentType.json,
    this.requestBody,
    this.responseStatus,
    this.message,
    this.responseModel,
    this.formDataList,
  });

  final String id;
  final HTTPVerb method;
  final String url;
  final String name;
  final String description;
  final int requestTabIndex;
  final List<NameValueModel>? requestHeaders;
  final List<NameValueModel>? requestParams;
  final List<FormDataModel>? formDataList;
  final ContentType requestBodyContentType;
  final String? requestBody;
  final int? responseStatus;
  final String? message;
  final ResponseModel? responseModel;

  Map<String, String> get headersMap => rowsToMap(requestHeaders) ?? {};
  Map<String, String> get paramsMap => rowsToMap(requestParams) ?? {};

  RequestModel duplicate({
    required String id,
  }) {
    return RequestModel(
      id: id,
      method: method,
      url: url,
      name: "$name (copy)",
      description: description,
      requestHeaders: requestHeaders != null ? [...requestHeaders!] : null,
      requestParams: requestParams != null ? [...requestParams!] : null,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      formDataList: formDataList != null ? [...formDataList!] : null,
    );
  }

  RequestModel copyWith({
    String? id,
    HTTPVerb? method,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? requestHeaders,
    List<NameValueModel>? requestParams,
    ContentType? requestBodyContentType,
    String? requestBody,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
    List<FormDataModel>? formDataList,
  }) {
    var headers = requestHeaders ?? this.requestHeaders;
    var params = requestParams ?? this.requestParams;
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      description: description ?? this.description,
      requestTabIndex: requestTabIndex ?? this.requestTabIndex,
      requestHeaders: headers != null ? [...headers] : null,
      requestParams: params != null ? [...params] : null,
      requestBodyContentType:
          requestBodyContentType ?? this.requestBodyContentType,
      requestBody: requestBody ?? this.requestBody,
      responseStatus: responseStatus ?? this.responseStatus,
      message: message ?? this.message,
      responseModel: responseModel ?? this.responseModel,
      formDataList: formDataList ?? this.formDataList,
    );
  }

  factory RequestModel.fromJson(Map<String, dynamic> data) {
    HTTPVerb method;
    ContentType requestBodyContentType;
    ResponseModel? responseModel;

    final id = data["id"] as String;
    try {
      method = HTTPVerb.values.byName(data["method"] as String);
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    final url = data["url"] as String;
    final name = data["name"] as String?;
    final description = data["description"] as String?;
    final requestHeaders = data["requestHeaders"];
    final requestParams = data["requestParams"];
    try {
      requestBodyContentType =
          ContentType.values.byName(data["requestBodyContentType"] as String);
    } catch (e) {
      requestBodyContentType = kDefaultContentType;
    }
    final requestBody = data["requestBody"] as String?;
    final responseStatus = data["responseStatus"] as int?;
    final message = data["message"] as String?;
    final responseModelJson = data["responseModel"];
    final formDataList = data["formDataList"];

    if (responseModelJson != null) {
      responseModel =
          ResponseModel.fromJson(Map<String, dynamic>.from(responseModelJson));
    } else {
      responseModel = null;
    }

    return RequestModel(
      id: id,
      method: method,
      url: url,
      name: name ?? "",
      description: description ?? "",
      requestTabIndex: 0,
      requestHeaders: requestHeaders != null
          ? mapToRows(Map<String, String>.from(requestHeaders))
          : null,
      requestParams: requestParams != null
          ? mapToRows(Map<String, String>.from(requestParams))
          : null,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      responseStatus: responseStatus,
      message: message,
      responseModel: responseModel,
      formDataList:
          formDataList != null ? listToFormDataModel(formDataList) : null,
    );
  }

  Map<String, dynamic> toJson({bool includeResponse = true}) {
    return {
      "id": id,
      "method": method.name,
      "url": url,
      "name": name,
      "description": description,
      "requestHeaders": rowsToMap(requestHeaders),
      "requestParams": rowsToMap(requestParams),
      "requestBodyContentType": requestBodyContentType.name,
      "requestBody": requestBody,
      "responseStatus": includeResponse ? responseStatus : null,
      "message": includeResponse ? message : null,
      "responseModel": includeResponse ? responseModel?.toJson() : null,
      "formDataList": rowsToFormDataMap(formDataList)
    };
  }

  @override
  String toString() {
    return [
      "Request Id: $id",
      "Request Method: ${method.name}",
      "Request URL: $url",
      "Request Name: $name",
      "Request Description: $description",
      "Request Tab Index: ${requestTabIndex.toString()}",
      "Request Headers: ${requestHeaders.toString()}",
      "Request Params: ${requestParams.toString()}",
      "Request Body Content Type: ${requestBodyContentType.toString()}",
      "Request Body: ${requestBody.toString()}",
      "Response Status: $responseStatus",
      "Response Message: $message",
      "Response: ${responseModel.toString()}"
          "FormData: ${formDataList.toString()}"
    ].join("\n");
  }

  @override
  bool operator ==(Object other) {
    return other is RequestModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.method == method &&
        other.url == url &&
        other.name == name &&
        other.description == description &&
        other.requestTabIndex == requestTabIndex &&
        listEquals(other.requestHeaders, requestHeaders) &&
        listEquals(other.requestParams, requestParams) &&
        other.requestBodyContentType == requestBodyContentType &&
        other.requestBody == requestBody &&
        other.responseStatus == responseStatus &&
        other.message == message &&
        other.responseModel == responseModel &&
        other.formDataList == formDataList;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      method,
      url,
      name,
      description,
      requestTabIndex,
      requestHeaders,
      requestParams,
      requestBodyContentType,
      requestBody,
      responseStatus,
      message,
      responseModel,
      formDataList,
    );
  }
}
