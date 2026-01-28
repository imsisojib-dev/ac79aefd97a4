class RequestRegisterDevice{
  String? model;
  String? brand;
  String? osName;
  String? osVersion;
  String? androidId;
  String? identifierForVendor;

  RequestRegisterDevice({
    this.model,
    this.brand,
    this.osName,
    this.osVersion,
    this.androidId,
    this.identifierForVendor,
});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['brand'] = brand;
    data['osName'] = osName;
    data['osVersion'] = osVersion;
    data['androidId'] = androidId;
    data['identifierForVendor'] = identifierForVendor;
    return data;
  }

}