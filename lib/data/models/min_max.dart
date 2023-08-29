import 'package:equatable/equatable.dart';

class TuningMinMax extends Equatable{
  final double min;
  final double max;

  const TuningMinMax({required this.min, required this.max});
  @override
  List<Object?> get props => [min, max];

  @override
  String toString() {
    return 'TuningMinMax{min: $min, max: $max}';
  }
}