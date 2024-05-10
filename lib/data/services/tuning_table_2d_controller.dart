import '../../tuning_table.dart';
import '../viewModels/tuning_table_2d_view_model.dart';
import '../models/tuning_table_2d_interface.dart';

class TuningTableController extends TuningTable2DInterface {
  TuningTableController({
    required horizontalLabels,
    required verticalLabels,
  }) : super(
          horizontalLabels: horizontalLabels,
          verticalLabels: verticalLabels,
        ) {
    _tuningTable2DViewModel = TuningTable2DViewModel(
      horizontalLabels: horizontalLabels,
      verticalLabels: verticalLabels,
    );
  }

  late TuningTable2DViewModel _tuningTable2DViewModel;

  @override
  Stream<UpdateType> get updateData =>
      _tuningTable2DViewModel.updateData.stream;

  @override
  List<double> get horizontalLabels => _tuningTable2DViewModel.horizontalLabels;

  @override
  List<double> get verticalLabels => _tuningTable2DViewModel.verticalLabels;

  @override
  double get widthSizeBoxAlone => _tuningTable2DViewModel.widthSizeBoxAlone;

  @override
  double get heightSizeBoxAlone => _tuningTable2DViewModel.heightSizeBoxAlone;

  @override
  double get sizeSpace => _tuningTable2DViewModel.sizeSpace;

  @override
  bool get isSettingLabel => _tuningTable2DViewModel.isSettingLabel;


  @override
  TuningMinMax get horizontalMinMax => _tuningTable2DViewModel.horizontalMinMax;

  @override
  TuningMinMax get verticalMinMax => _tuningTable2DViewModel.verticalMinMax;

  @override
  TuningMinMax get dataMinMax => _tuningTable2DViewModel.dataMinMax;

  @override
  TuningMinMax get currentMinMax => _tuningTable2DViewModel.currentMinMax;

  @override
  DecimalType get valueDecimal => _tuningTable2DViewModel.valueDecimal;

  @override
  DecimalType get horizontalDecimal =>
      _tuningTable2DViewModel.horizontalDecimal;

  @override
  DecimalType get verticalDecimal => _tuningTable2DViewModel.verticalDecimal;

  @override
  DecimalType get currentDecimal => _tuningTable2DViewModel.currentDecimal;

  @override
  void clearLabels() {
    _tuningTable2DViewModel.clearLabels();
  }

  @override
  void clearSelectData() {
    _tuningTable2DViewModel.clearSelectData();
  }

  @override
  void toggleSettingLabel() {
    _tuningTable2DViewModel.toggleSettingLabel();
  }

  @override
  void calculator(TuningCalculatorType type, double value) {
    _tuningTable2DViewModel.calculator(type, value);
  }

  @override
  void interpolation(TuningAxisType type) {
    _tuningTable2DViewModel.interpolation(type);
  }

  @override
  void setHorizontalLabels(List<double> labels) {
    _tuningTable2DViewModel.setHorizontalLabels(labels);
  }

  @override
  void setLabels(List<double> vertical, List<double> horizontal) {
    _tuningTable2DViewModel.setLabels(vertical, horizontal);
  }

  @override
  void setVerticalLabels(List<double> labels) {
    _tuningTable2DViewModel.setVerticalLabels(labels);
  }

  @override
  void setPosition(TuningPointerOffset start, TuningPointerOffset end) {
    _tuningTable2DViewModel.startPosition = start;
    _tuningTable2DViewModel.endPosition = end;
  }

  @override
  void setLabelActiveAxis(TuningAxisType type) {
    _tuningTable2DViewModel.labelActiveAxis = type;
  }

  @override
  void setMinMax({
    TuningMinMax? horizontal,
    TuningMinMax? vertical,
    TuningMinMax? data,
  }) {

    _tuningTable2DViewModel.horizontalMinMax =
        horizontal ?? _tuningTable2DViewModel.horizontalMinMax;

    _tuningTable2DViewModel.verticalMinMax =
        vertical ?? _tuningTable2DViewModel.verticalMinMax;

    _tuningTable2DViewModel.dataMinMax =
        data ?? _tuningTable2DViewModel.dataMinMax;

    _tuningTable2DViewModel.updateCurrentMinMax();
  }

  @override
  void setTableOffset(
    TuningPointerOffset start,
    TuningPointerOffset end,
  ) {
    _tuningTable2DViewModel.startTable = start;
    _tuningTable2DViewModel.endTable = end;
  }

  @override
  List<TuningPointerOffset> convertPosition({
    required TuningPointerOffset start,
    required TuningPointerOffset end,
  }) {
    return _tuningTable2DViewModel.convertPosition(
        startPosition: start, endPosition: end);
  }

  @override
  Map<String, TuningPointModel> get data => _tuningTable2DViewModel.data;

  @override
  void setData(Map<String, TuningPointModel> data) {
    _tuningTable2DViewModel.setData(data);
  }

  @override
  List<double> get dataList => _tuningTable2DViewModel.dataList;

  @override
  void setDataWithList(List<double> data) {
    _tuningTable2DViewModel.setDataWithList(data);
  }

  @override
  void setScaleTable({
    required double width,
    required double height,
    required double sizeSpace,
  }) {
    _tuningTable2DViewModel.setScaleTable(
        width: width, height: height, sizeSpace: sizeSpace);
  }

  @override
  void setDecimal({
    DecimalType? horizontal,
    DecimalType? vertical,
    DecimalType? value,
  }) {
    _tuningTable2DViewModel.horizontalDecimal =
        horizontal ?? _tuningTable2DViewModel.horizontalDecimal;

    _tuningTable2DViewModel.verticalDecimal =
        vertical ?? _tuningTable2DViewModel.verticalDecimal;

    _tuningTable2DViewModel.valueDecimal =
        value ?? _tuningTable2DViewModel.valueDecimal;
  }

  @override
  void refresh() {
    _tuningTable2DViewModel.updateData.add(UpdateType.action);
  }

  @override
  void setSettingLabelOff() {
    _tuningTable2DViewModel.isSettingLabel = false;
  }
}
