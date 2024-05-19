class FinanceRequest {
  final int? type;
  final int? state;
  int? minCost;
  int? maxCost;
  final int? pageSize;
  final int? pageNum;

  FinanceRequest({
    this.type,
    this.state,
    this.minCost,
    this.maxCost,
    this.pageSize,
    this.pageNum,
  });

  FinanceRequest copyWith({
    int? type,
    int? state,
    int? minCost,
    int? maxCost,
    int? pageSize,
    int? pageNum,
  }) {
    FinanceRequest res=FinanceRequest(

    );
    return FinanceRequest(
      type: type ?? this.type,
      state: state ?? this.state,
      minCost: minCost ?? this.minCost,
      maxCost: maxCost ?? this.maxCost,
      pageSize: pageSize ?? this.pageSize,
      pageNum: pageNum ?? this.pageNum,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (type != null) data['type'] = type;
    if (state != null) data['state'] = state;
    if (minCost != null) data['minCost'] = minCost;
    if (maxCost != null) data['maxCost'] = maxCost;
    if (pageSize != null) data['pageSize'] = pageSize;
    if (pageNum != null) data['pageNum'] = pageNum;
    return data;
  }

}
