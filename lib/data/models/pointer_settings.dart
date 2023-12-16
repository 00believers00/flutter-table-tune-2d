import 'package:flutter/material.dart';

import 'enum_types.dart';

class PointerSettings extends ChangeNotifier{
  final bool vertical;
  final bool horizontal;
  final bool circle;
  final bool verticalTriangle;
  final bool horizontalTriangle;
  final DataSortType sortHorizontalLabels;
  final DataSortType sortVerticalLabels;

  double? _dataVertical;
  double? get dataVertical => _dataVertical;
  set dataVertical(v){
    _dataVertical = v;
    notifyListeners();
  }

  double? _dataHorizontal;
  double? get dataHorizontal => _dataHorizontal;
  set dataHorizontal(v){
    _dataHorizontal = v;
    notifyListeners();
  }

  void setData({double? vertical, double? horizontal}){
    _dataVertical = vertical;
    _dataHorizontal = horizontal;
  }

  PointerSettings({
    this.circle = true,
    this.horizontal = true,
    this.vertical = true,
    this.verticalTriangle = false,
    this.horizontalTriangle = false,
    this.sortHorizontalLabels = DataSortType.asc,
    this.sortVerticalLabels = DataSortType.des,
    double? dataHorizontal,
    double? dataVertical,
  }){
    this.dataHorizontal = dataHorizontal;
    this.dataVertical = dataVertical;
  }

  @override
  String toString() {
    return 'PointerSettings{vertical: $vertical, horizontal: $horizontal, circle: $circle, sortHorizontalLabels: $sortHorizontalLabels, sortVerticalLabels: $sortVerticalLabels, dataVertical: $_dataVertical, dataHorizontal: $_dataHorizontal}';
  }
}