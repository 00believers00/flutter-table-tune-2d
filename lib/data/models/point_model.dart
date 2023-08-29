class TuningPointModel {
  bool? status;
  double? value;

  TuningPointModel({required this.status, required this.value});

  factory TuningPointModel.init() {
    return TuningPointModel(
      status: false,
      value: 0,
    );
  }

  TuningPointModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['value'] = value;

    return data;
  }

  TuningPointModel copyWith({
    bool? status,
    double? value,
  }) {
    return TuningPointModel(
      status: status ?? this.status,
      value: value ?? this.value,
    );
  }

  static String head({required int horizontal, required int vertical}) {
    return '[$horizontal:$vertical]';
  }

  @override
  String toString() {
    return 'TuningPointModel{status: $status, value: $value}';
  }
}