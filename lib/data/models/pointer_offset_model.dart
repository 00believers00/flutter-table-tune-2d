import 'package:equatable/equatable.dart';

class TuningPointerOffset extends Equatable {
  final int x;
  final int y;

  const TuningPointerOffset(this.x, this.y);

  static const TuningPointerOffset zero = TuningPointerOffset(0, 0);

  @override
  String toString() {
    return 'TuningPointerOffset{x: $x, y: $y}';
  }

  @override
  List<Object> get props => [x, y];
}