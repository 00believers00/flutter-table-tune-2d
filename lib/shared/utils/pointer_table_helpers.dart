import '../../data/models/enum_types.dart';

class PointerTableHelpers {
  static final shared = PointerTableHelpers();

  double callLocation({
    required double data,
    required double sizeBoxAlone,
    required double sizeSpace,
    required List<double> labels,
    required DataSortType sortType,
  }) {

    late int index;
    late double process,max, min;

    switch(sortType){
      case DataSortType.des:
        max = labels[0];
        min = labels[labels.length - 1];
        process = _checkDataMinMax(min: min, max: max, data: data);

        index = labels.indexWhere((element) => process >= element);
        break;
      case DataSortType.asc:
        max = labels[labels.length - 1];
        min = labels[0];
        process = _checkDataMinMax(min: min, max: max, data: data);

        index = labels.indexWhere((element) => process <= element);
        break;
    }



    return _location(
      process: process,
      index: index,
      sizeBoxAlone: sizeBoxAlone,
      sizeSpace: sizeSpace,
      labels: labels,
    );
  }

  double _location({
    required double process,
    required int index,
    required double sizeBoxAlone,
    required double sizeSpace,
    required List<double> labels,
  }) {
    double lastLocation = _calLocationPoint(sizeBoxAlone, index);

    int idxPrevious = index - 1;
    if (idxPrevious > 0) {
      double pointNowData = labels[index];
      double pointPreviousData = labels[index - 1];
      double dif = pointPreviousData - pointNowData;
      double locationNow = _calLocationPoint(sizeBoxAlone, index);
      double locationPrevious = _calLocationPoint(sizeBoxAlone, index - 1);
      double difLocation = locationPrevious - locationNow;
      double partOverData = process - pointNowData;
      double location = (difLocation * partOverData) / dif;
      lastLocation += (location - (sizeSpace * index));
    }

    return lastLocation;
  }

  double _calLocationPoint(double sizeBoxAlone, int index) {
    return (sizeBoxAlone * index) + (sizeBoxAlone / 2);
  }

  double _checkDataMinMax({
    required double min,
    required double max,
    required double data,
  }) {
    double process = data;
    if (process > max) {
      process = max;
    }

    if (process <= min) {
      process = min;
    }
    return process;
  }
}
