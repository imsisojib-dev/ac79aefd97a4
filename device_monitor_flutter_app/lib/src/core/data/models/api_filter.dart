
import 'package:device_monitor/src/core/enums/e_sort_order.dart';

class ApiFilterRequest {
  final Map<String, dynamic> body;
  final ApiMeta meta;
  String? deviceId; //for path variable

  ApiFilterRequest({
    required this.body,
    required this.meta,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "meta": meta.toJson(),
    };
  }
}

class ApiMeta {
  final int page;
  final int limit;
  final List<ApiSort> sort;

  ApiMeta({
    this.page = 0,
    this.limit = 10,
    this.sort = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "sort": sort.map((s) => s.toJson()).toList(),
    };
  }
}

class ApiSort {
  final ESortOrder order;
  final String field;

  ApiSort({required this.order, required this.field});

  Map<String, dynamic> toJson() {
    return {
      "order": order.name,
      "field": field,
    };
  }
}
