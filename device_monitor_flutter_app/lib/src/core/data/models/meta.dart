class Meta {
  int? page;
  int? prevPage;
  int? nextPage;
  int? limit;
  int? totalRecords;
  int? resultCount;
  int? totalPageCount;

  Meta({
    this.page,
    this.prevPage,
    this.nextPage,
    this.limit,
    this.totalRecords,
    this.resultCount,
    this.totalPageCount,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
    limit = json['limit'];
    totalRecords = json['totalRecords'];
    resultCount = json['resultCount'];
    totalPageCount = json['totalPageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['prevPage'] = prevPage;
    data['nextPage'] = nextPage;
    data['limit'] = limit;
    data['totalRecords'] = totalRecords;
    data['resultCount'] = resultCount;
    data['totalPageCount'] = totalPageCount;
    return data;
  }
}
