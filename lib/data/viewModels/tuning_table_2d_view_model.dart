import 'dart:async';
import 'dart:developer';

import '../../shared/extensions/decimal.dart';
import '../models/enum_types.dart';
import '../models/min_max.dart';
import '../models/point_model.dart';
import '../models/pointer_offset_model.dart';

class TuningTable2DViewModel {
  TuningTable2DViewModel({
    required List<double> horizontalLabels,
    required List<double> verticalLabels,
  }) {
    _horizontalLabels = horizontalLabels;
    _verticalLabels = verticalLabels;

    _initData();
  }

  bool _isSettingLabel = false;

  bool get isSettingLabel => _isSettingLabel;

  set isSettingLabel(v) {
    _isSettingLabel = v;
    _setUpdateData();
    updateCurrentMinMax();
  }

  TuningAxisType labelActiveAxis = TuningAxisType.none;

  double _width = 0;
  double _height = 0;
  double _sizeSpace = 0.5;
  double get sizeSpace => _sizeSpace;

  double get widthSizeBoxAlone => _widthSizeBoxAlone;

  double get heightSizeBoxAlone => _heightSizeBoxAlone;
  double _widthSizeBoxAlone = 0;
  double _heightSizeBoxAlone = 0;

  TuningMinMax horizontalMinMax = const TuningMinMax(min: 0, max: 20000);
  TuningMinMax verticalMinMax = const TuningMinMax(min: 0, max: 100);
  TuningMinMax dataMinMax = const TuningMinMax(min: -100, max: 100);
  TuningMinMax currentMinMax = const TuningMinMax(min: -100, max: 100);

  DecimalType valueDecimal = DecimalType.none;
  DecimalType horizontalDecimal = DecimalType.none;
  DecimalType verticalDecimal = DecimalType.none;
  DecimalType get currentDecimal => _checkCurrentDecimal();

  TuningPointerOffset startPosition = TuningPointerOffset.zero;
  TuningPointerOffset endPosition = TuningPointerOffset.zero;

  TuningPointerOffset startTable = TuningPointerOffset.zero;
  TuningPointerOffset endTable = TuningPointerOffset.zero;

  final updateData = StreamController<UpdateType>.broadcast();

  List<double> _horizontalLabels = [];

  List<double> get horizontalLabels => _horizontalLabels;

  void setHorizontalLabels(List<double> labels) {
    _horizontalLabels = labels;
    _initData();
  }

  List<double> _verticalLabels = [];

  List<double> get verticalLabels => _verticalLabels;

  void setVerticalLabels(List<double> labels) {
    _verticalLabels = labels;
    _initData();
  }

  void setLabels(List<double> vertical, List<double> horizontal) {
    _verticalLabels = vertical;
    _horizontalLabels = horizontal;
    _initData();
  }

  Map<String, TuningPointModel> _data = {};

  Map<String, TuningPointModel> get data => _data;

  void setData(Map<String, TuningPointModel> data) {
    _data = data;
    updateCurrentMinMax();
    _setUpdateData();
  }

  List<double> get dataList => _getDataWithList();

  List<double> _getDataWithList() {
    List<double> raw = [];
    for (int v = startTable.y; v <= verticalLabels.length; v++) {
      for (int h = startTable.x; h <= horizontalLabels.length; h++) {
        String head = TuningPointModel.head(horizontal: h, vertical: v);
        raw.add(_data[head]?.value ?? 0);
      }
    }
    return raw;
  }

  void setDataWithList(List<double> data) {
    int all = verticalLabels.length * horizontalLabels.length;
    if (data.length < all) {
      log('Tuning-Table: setDataWithList error because length of data(${data.length}) < $all');
      return;
    }
    for (int v = startTable.y; v <= verticalLabels.length; v++) {
      for (int h = startTable.x; h <= horizontalLabels.length; h++) {
        String head = TuningPointModel.head(horizontal: h, vertical: v);
        int idxHorizontal = h - 1;
        int idxVertical = v - 1;
        _data[head] = TuningPointModel(
          status: false,
          value: data[idxHorizontal + (horizontalLabels.length * idxVertical)],
        );
      }
    }
    _setUpdateData();
  }

  void setScaleTable({
    required double width,
    required double height,
    required double sizeSpace,
  }) {
    _width = width;
    _height = height;
    _sizeSpace = sizeSpace;
    _setScaleTable();
  }

  void _setScaleTable() {
    int lengthHorizontal = horizontalLabels.length + 1;
    int lengthVertical = verticalLabels.length + 1;

    _widthSizeBoxAlone = (_width / lengthHorizontal) + _sizeSpace;
    _heightSizeBoxAlone = (_height / lengthVertical) + _sizeSpace;
  }

  DecimalType _checkCurrentDecimal(){
    switch(labelActiveAxis){
      case TuningAxisType.horizontal:
        return horizontalDecimal;
      case TuningAxisType.vertical:
        return verticalDecimal;
      default:
        return valueDecimal;
    }
  }

  void _initData() {
    startTable = const TuningPointerOffset(1, 1);
    endTable = TuningPointerOffset(
      _horizontalLabels.length,
      _verticalLabels.length,
    );
    _setScaleTable();
    for (int v = 0; v <= verticalLabels.length; v++) {
      for (int h = 0; h <= horizontalLabels.length; h++) {
        String head = TuningPointModel.head(horizontal: h, vertical: v);
        if (v == 0 && h == 0) {
          _data[head] = TuningPointModel.init();
        } else if (v == 0 && h != 0) {
          _data[head] = TuningPointModel(
            status: false,
            value: horizontalLabels[h - 1],
          );
        } else if (h == 0 && v != 0) {
          _data[head] = TuningPointModel(
            status: false,
            value: verticalLabels[v - 1],
          );
        }
      }
    }
    _clearSelectAll();
  }

  void toggleSettingLabel() {
    isSettingLabel = !isSettingLabel;
    _clearSelectAll();
    if (!isSettingLabel) {
      _updateDataLabels();
      Future.delayed(const Duration(milliseconds: 300), () {
        updateData.add(UpdateType.setLabels);
      });
    }
  }

  void _updateDataLabels() {
    List<double> rawHorizontalLabels = [];
    List<double> rawVerticalLabels = [];
    for (int v = 0; v <= verticalLabels.length; v++) {
      for (int h = 0; h <= horizontalLabels.length; h++) {
        String head = TuningPointModel.head(horizontal: h, vertical: v);
        if (v == 0 && h != 0) {
          rawHorizontalLabels.add(_data[head]?.value ?? 0);
        } else if (h == 0 && v != 0) {
          rawVerticalLabels.add(_data[head]?.value ?? 0);
        }
      }
    }
    setLabels(rawVerticalLabels, rawHorizontalLabels);
  }

  void _clearSelectAll() {
    data.updateAll((key, value) => value.copyWith(status: false));
    _setUpdateData();
  }

  void clearSelectData() {
    final raw = data;
    for (int v = startTable.y; v <= endTable.y; v++) {
      for (int h = startTable.x; h <= endTable.x; h++) {
        final head = TuningPointModel.head(horizontal: h, vertical: v);
        raw[head] =
            raw[head]?.copyWith(status: false) ?? TuningPointModel.init();
      }
    }
    setData(raw);
  }

  void clearLabels() {
    if (startPosition.y == 0) {
      labelActiveAxis = TuningAxisType.horizontal;
      for (int v = 0; v <= verticalLabels.length; v++) {
        String head = TuningPointModel.head(horizontal: 0, vertical: v);
        data[head] = data[head]?.copyWith(status: false) ??
            TuningPointModel(value: 0, status: false);
      }
    } else if (startPosition.x == 0) {
      labelActiveAxis = TuningAxisType.vertical;
      for (int h = 0; h <= horizontalLabels.length; h++) {
        String head = TuningPointModel.head(horizontal: h, vertical: 0);
        data[head] = data[head]?.copyWith(status: false) ??
            TuningPointModel(value: 0, status: false);
      }
    } else {
      labelActiveAxis = TuningAxisType.none;
    }
  }

  void calculator(TuningCalculatorType type, double value) {
    switch (type) {
      case TuningCalculatorType.step:
        data.updateAll((key, v) {
          if (v.status ?? false) {
            double v1 = v.value ?? 0;
            double cal = v1 + value;
            v = v.copyWith(value: _checkMinMaxData(cal));
          }
          return v;
        });
        break;
      case TuningCalculatorType.percent:
        data.updateAll((key, v) {
          if (v.status ?? false) {
            double v1 = v.value ?? 0;
            double cal = v1 + (v1 * (value / 100));
            v = v.copyWith(value: _checkMinMaxData(cal));
          }
          return v;
        });
        break;
      case TuningCalculatorType.numeric:
        data.updateAll((key, v) {
          if (v.status ?? false) {
            v = v.copyWith(value: _checkMinMaxData(value));
          }
          return v;
        });
        break;
    }
    _setUpdateData();
  }

  void interpolation(TuningAxisType type) {
    switch (type) {
      case TuningAxisType.vertical:
        setData(_interpolationVertical(data));
        break;
      case TuningAxisType.horizontal:
        setData(_interpolationHorizontal(data));
        break;
      case TuningAxisType.cross:
        final d = _interpolationVertical(data);
        setData(_interpolationHorizontal(d));
        break;
      default:
        break;
    }
  }

  Map<String, TuningPointModel> _interpolationVertical(
      Map<String, TuningPointModel> tuning) {
    final point =
        convertPosition(startPosition: startPosition, endPosition: endPosition);
    int h1 = point[0].x;
    int v1 = point[0].y;
    int h2 = point[1].x;
    int v2 = point[1].y;

    int n = 0;
    double dif = 0;

    n = v2 - v1;
    int loop = h2 - h1;
    for (int i = 0; i <= loop; i++) {
      int stepLoop = h1 + i;

      final headV1 = TuningPointModel.head(horizontal: stepLoop, vertical: v1);
      final headV2 = TuningPointModel.head(horizontal: stepLoop, vertical: v2);

      double value1 = tuning[headV1]?.value ?? 0;
      double value2 = tuning[headV2]?.value ?? 0;
      double main = (value1 > value2) ? value1 : value2;
      double sub = (value1 < value2) ? value1 : value2;
      dif = (main - sub) / n;
      for (int j = 1; j < n; j++) {
        int stepLoopV1 = v1 + (j - 1);
        int stepLoopV2 = v1 + j;
        int mul = (value1 > value2) ? -1 : 1;

        final headStepLoopV1 = TuningPointModel.head(
          horizontal: stepLoop,
          vertical: stepLoopV1,
        );
        final headStepLoopV2 = TuningPointModel.head(
          horizontal: stepLoop,
          vertical: stepLoopV2,
        );

        double rawValue1 = (tuning[headStepLoopV1]?.value ?? 0) + (dif * mul);
        rawValue1 = _checkMinMaxData(rawValue1);

        tuning[headStepLoopV2] =
            tuning[headStepLoopV2]?.copyWith(value: rawValue1) ??
                TuningPointModel(status: true, value: 0);
      }
    }
    return tuning;
  }

  Map<String, TuningPointModel> _interpolationHorizontal(
      Map<String, TuningPointModel> tuning) {
    final point =
        convertPosition(startPosition: startPosition, endPosition: endPosition);
    int h1 = point[0].x;
    int v1 = point[0].y;
    int h2 = point[1].x;
    int v2 = point[1].y;

    int n = 0;
    double dif = 0;

    n = h2 - h1;
    int loop = v2 - v1;
    for (int i = 0; i <= loop; i++) {
      int stepLoop = v1 + i;

      final headH1 = TuningPointModel.head(horizontal: h1, vertical: stepLoop);
      final headH2 = TuningPointModel.head(horizontal: h2, vertical: stepLoop);

      double value1 = tuning[headH1]?.value ?? 0;
      double value2 = tuning[headH2]?.value ?? 0;
      double main = (value1 > value2) ? value1 : value2;
      double sub = (value1 < value2) ? value1 : value2;
      dif = (main - sub) / n;
      for (int j = 1; j < n; j++) {
        int stepLoopH1 = h1 + (j - 1);
        int stepLoopH2 = h1 + j;

        final headStepLoopH1 = TuningPointModel.head(
          horizontal: stepLoopH1,
          vertical: stepLoop,
        );
        final headStepLoopH2 = TuningPointModel.head(
          horizontal: stepLoopH2,
          vertical: stepLoop,
        );

        int mul = (value1 > value2) ? -1 : 1;
        double rawValue1 = (tuning[headStepLoopH1]?.value ?? 0) + (dif * mul);
        rawValue1 = _checkMinMaxData(rawValue1);

        tuning[headStepLoopH2] =
            tuning[headStepLoopH2]?.copyWith(value: rawValue1) ??
                TuningPointModel(status: true, value: 0);
      }
    }
    return tuning;
  }

  List<TuningPointerOffset> convertPosition({
    required TuningPointerOffset startPosition,
    required TuningPointerOffset endPosition,
  }) {
    int startPointX = startPosition.x;
    int startPointY = startPosition.y;
    int updatePointX = endPosition.x;
    int updatePointY = endPosition.y;
    int startX = (startPointX < updatePointX) ? startPointX : updatePointX;
    int startY = (startPointY < updatePointY) ? startPointY : updatePointY;
    int updateX = (startPointX > updatePointX) ? startPointX : updatePointX;
    int updateY = (startPointY > updatePointY) ? startPointY : updatePointY;

    if (isSettingLabel) {
      if (labelActiveAxis == TuningAxisType.vertical) {
        startX = 0;
        updateX = 0;
        if (startY <= 0) {
          startY = startTable.y;
        }
      } else if (labelActiveAxis == TuningAxisType.horizontal) {
        startY = 0;
        updateY = 0;
        if (startX <= 0) {
          startX = startTable.x;
        }
      }
    } else {
      if (startX <= 0) {
        startX = startTable.x;
      }
      if (startY <= 0) {
        startY = startTable.y;
      }
    }

    if (updateX >= endTable.x) {
      updateX = endTable.x;
    }
    if (updateY >= endTable.y) {
      updateY = endTable.y;
    }

    return [
      TuningPointerOffset(startX, startY),
      TuningPointerOffset(updateX, updateY)
    ];
  }

  void updateCurrentMinMax(){
    if (isSettingLabel) {
      if(labelActiveAxis == TuningAxisType.vertical){
        currentMinMax = verticalMinMax;
      }else if(labelActiveAxis == TuningAxisType.horizontal){
        currentMinMax = horizontalMinMax;
      }
    }else{
      currentMinMax = dataMinMax;
    }
    _setUpdateData();
  }

  double _checkMinMaxData(double data) {
    if (isSettingLabel) {
      if (labelActiveAxis == TuningAxisType.vertical) {
        return _checkMinMaxInput(verticalMinMax, data);
      } else if (labelActiveAxis == TuningAxisType.horizontal) {
        return _checkMinMaxInput(horizontalMinMax, data);
      }
    }
    return _checkMinMaxInput(dataMinMax, data);
  }

  double _checkMinMaxInput(TuningMinMax minMax, double data) {
    if (data <= minMax.min) {
      data = minMax.min;
    }

    if (data >= minMax.max) {
      data = minMax.max;
    }
    return data;
  }

  void _setUpdateData() {
    updateData.add(UpdateType.action);
  }
}
