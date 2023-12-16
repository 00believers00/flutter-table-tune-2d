import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuning_table/shared/widgets/pointer_table/pointer_table.dart';

import '../data/models/enum_types.dart';
import '../data/models/point_model.dart';
import '../data/models/pointer_offset_model.dart';
import '../data/models/pointer_settings.dart';
import '../data/services/tuning_table_2d_controller.dart';
import '../shared/utils/table_tune_2d_helpers.dart';
import '../shared/widgets/show_setting_2d.dart';
import '../shared/widgets/show_table_2d.dart';

class TuningTable2dView extends StatefulWidget {
  const TuningTable2dView({
    super.key,
    required this.width,
    required this.height,
    this.sizeSpace = 0.5,
    required this.horizontalName,
    required this.verticalName,
    required this.controller,
    this.labelStyle,
    this.headerStyle,
    this.bodyStyle,
    this.pointerSettings,
    this.tableType = TableType.tune,
  });

  final double width;
  final double height;
  final double sizeSpace;
  final String horizontalName;
  final String verticalName;
  final TuningTableController controller;
  final TextStyle? labelStyle;
  final TextStyle? headerStyle;
  final TextStyle? bodyStyle;
  final PointerSettings? pointerSettings;
  final TableType tableType;

  @override
  State<TuningTable2dView> createState() => _TableTune2dViewState();
}

class _TableTune2dViewState extends State<TuningTable2dView> {
  final _helps = FunctionTableTune2DHelpers.shared;

  double _width = 0;
  double _height = 0;
  double _sizeSpace = 0.5;
  TuningPointerOffset _startPosition = TuningPointerOffset.zero;
  late StreamSubscription updateSubscription;

  @override
  void initState() {
    widget.pointerSettings?.addListener(() {
      if(mounted){
        setState(() {});
      }
    });
    updateSubscription = widget.controller.updateData.listen((type) {
      if(mounted){
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    updateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.width != _width ||
        widget.height != _height ||
        widget.sizeSpace != _sizeSpace) {
      _initSizeBox();
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit:  StackFit.expand,
        children: [
          GestureDetector(
            onPanStart: (a) {
              _onDetectStart(a.localPosition);
            },
            onPanUpdate: (a) {
              _onDetectUpdate(a.localPosition);
            },
            onPanEnd: (a) {
              _onDetectEnd();
            },
            child: StreamBuilder(
              stream: widget.controller.updateData,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.grey,
                  padding: EdgeInsets.only(
                    left: widget.sizeSpace,
                    top: widget.sizeSpace,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ShowTable2d(
                        verticalLabels: widget.controller.verticalLabels,
                        horizontalLabels: widget.controller.horizontalLabels,
                        configTunes: widget.controller.data,
                        sizeSpace: widget.sizeSpace,
                        verticalName: widget.verticalName,
                        horizontalName: widget.horizontalName,
                        horizontalDecimal: widget.controller.horizontalDecimal,
                        verticalDecimal: widget.controller.verticalDecimal,
                        valueDecimal: widget.controller.valueDecimal,
                        labelStyle: widget.labelStyle,
                        headerStyle: widget.headerStyle,
                        bodyStyle: widget.bodyStyle,
                      ),
                      PointerTable(
                        controller: widget.controller,
                        pointerSettings: widget.pointerSettings,
                      ),
                      ShowSetting2D(
                        isOpen: widget.controller.isSettingLabel,
                        width: widget.width,
                        height: widget.height,
                        horizontalName: widget.horizontalName,
                        verticalName: widget.verticalName,
                        labelStyle: widget.labelStyle,
                        verticalLabels: widget.controller.verticalLabels,
                        horizontalLabels: widget.controller.horizontalLabels,
                        configTunes: widget.controller.data,
                        sizeSpace: widget.sizeSpace,
                        horizontalDecimal: widget.controller.horizontalDecimal,
                        verticalDecimal: widget.controller.verticalDecimal,
                        headerStyle: widget.headerStyle,
                        onPressedSave: onPressedSave,
                        onPressedCancel: onPressedCancel,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if(widget.tableType == TableType.preview)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.1),
            ),
        ],
      ),
    );
  }

  void onPressedSave() {
    widget.controller.toggleSettingLabel();
  }

  void onPressedCancel() {
    widget.controller.setSettingLabelOff();
    widget.controller.setLabels(
      widget.controller.verticalLabels,
      widget.controller.horizontalLabels,
    );
  }

  void _initSizeBox() {
    _width = widget.width;
    _height = widget.height;
    _sizeSpace = widget.sizeSpace;

    widget.controller.setScaleTable(
      width: _width,
      height: _height,
      sizeSpace: _sizeSpace,
    );
  }

  void _onDetectEnd() {}

  void _onDetectStart(Offset localPosition) {
    final position = _helps.calPoint(
      localPosition,
      widget.controller.widthSizeBoxAlone,
      widget.controller.heightSizeBoxAlone,
    );
    _startPosition = position;
    widget.controller.setPosition(position, position);
    updateSelect(startPosition: position, endPosition: position);
  }

  void _onDetectUpdate(Offset localPosition) {
    final position = _helps.calPoint(
      localPosition,
      widget.controller.widthSizeBoxAlone,
      widget.controller.heightSizeBoxAlone,
    );
    widget.controller.setPosition(_startPosition, position);
    updateSelect(startPosition: _startPosition, endPosition: position);
  }

  void updateSelect({
    required TuningPointerOffset startPosition,
    required TuningPointerOffset endPosition,
  }) {
    Map<String, TuningPointModel> configTunes = widget.controller.data;

    if (startPosition == endPosition) {
      _updateDataOnePoint(
        position: startPosition,
        data: configTunes,
      );
      return;
    }

    final positions = widget.controller.convertPosition(
      start: startPosition,
      end: endPosition,
    );
    _updateDataTune(
      startPosition: positions[0],
      updatePosition: positions[1],
      data: configTunes,
    );
  }

  void _updateDataOnePoint({
    required TuningPointerOffset position,
    required Map<String, TuningPointModel> data,
  }) {
    String head = TuningPointModel.head(
      horizontal: position.x,
      vertical: position.y,
    );
    data = _clearSelectAll(data);
    data[head] = data[head]?.copyWith(status: true) ?? TuningPointModel.init();

    if (!widget.controller.isSettingLabel) {
      if (position.x == 0 || position.y == 0) {
        data[head] =
            data[head]?.copyWith(status: false) ?? TuningPointModel.init();
      }
    }

    _setSelectData(data);
  }

  void _updateDataTune({
    required TuningPointerOffset startPosition,
    required TuningPointerOffset updatePosition,
    required Map<String, TuningPointModel> data,
  }) {
    Map<String, TuningPointModel> configTunes = data;
    for (int v = 0; v <= widget.controller.verticalLabels.length; v++) {
      for (int h = 0; h <= widget.controller.horizontalLabels.length; h++) {
        bool isRun = false;
        String head = TuningPointModel.head(horizontal: h, vertical: v);

        if (v >= startPosition.y && v <= updatePosition.y) {
          if (h >= startPosition.x && h <= updatePosition.x) {
            isRun = true;
            configTunes[head] = configTunes[head]?.copyWith(status: true) ??
                TuningPointModel.init();
          }
        }

        if (!isRun) {
          configTunes[head] = configTunes[head]?.copyWith(status: false) ??
              TuningPointModel.init();
        }

        if (v == 0 && h == 0) {
          configTunes[head] = TuningPointModel.init();
        }

        if (!widget.controller.isSettingLabel) {
          if (v == 0 || h == 0) {
            configTunes[head] = configTunes[head]?.copyWith(status: false) ??
                TuningPointModel.init();
          }
        }
      }
    }
    _setSelectData(configTunes);
  }

  void _setSelectData(Map<String, TuningPointModel> data) {
    widget.controller.setData(data);
    if (widget.controller.isSettingLabel) {
      widget.controller.clearSelectData();
      widget.controller.clearLabels();
    }
  }

  Map<String, TuningPointModel> _clearSelectAll(
    Map<String, TuningPointModel> data,
  ) {
    data.updateAll((key, value) => value.copyWith(status: false));
    return data;
  }

  void updateScreen() {
    if (mounted) {
      setState(() {});
    }
  }
}
