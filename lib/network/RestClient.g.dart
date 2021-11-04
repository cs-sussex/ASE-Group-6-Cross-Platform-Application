// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://3.9.171.61:8080/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<RegistrationPOJO> registerUser(registrationPOJO) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(registrationPOJO.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationPOJO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/auth/signup',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationPOJO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginPOJO> loginUser(loginPOJO) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginPOJO.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginPOJO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/auth/signin',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginPOJO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LocationPOJO> getAllLocation(locationPOJO) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(locationPOJO.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LocationPOJO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/location/add',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LocationPOJO.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
