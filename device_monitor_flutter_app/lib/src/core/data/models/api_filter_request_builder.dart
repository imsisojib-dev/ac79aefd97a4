import 'package:device_monitor/src/core/enums/e_sort_order.dart';

import 'api_filter.dart';

class ApiFilterRequestBuilder {
  final Map<String, dynamic> _body = {};
  int _page = 0;
  int _limit = 20;
  final List<ApiSort> _sort = [];
  String? _deviceId;

  ApiFilterRequestBuilder setPage(int page) {
    _page = page;
    return this;
  }

  ApiFilterRequestBuilder setLimit(int limit) {
    _limit = limit;
    return this;
  }

  ApiFilterRequestBuilder setDeviceId(String deviceId) {
    _deviceId = deviceId;
    return this;
  }

  ApiFilterRequestBuilder addSort(String field, {ESortOrder order = ESortOrder.desc}) {
    _sort.add(ApiSort(order: order, field: field));
    return this;
  }

  ApiFilterRequestBuilder addFilter(String key, dynamic value) {
    _body[key] = value;
    return this;
  }

  ApiFilterRequest build() {
    return ApiFilterRequest(
      body: _body,
      meta: ApiMeta(
        page: _page,
        limit: _limit,
        sort: _sort,
      ),
      deviceId: _deviceId,
    );
  }
}
