enum DecimalType { none, one, second, three }

extension DataDecimalType on DecimalType{
  int decimal(){
    switch(this){
      case DecimalType.one:
        return 1;
      case DecimalType.second:
        return 2;
      case DecimalType.three:
        return 3;
      default:
        return 0;
    }
  }
}

DecimalType convertDecimalType(int decimal){
  switch(decimal){
    case 1:
      return DecimalType.one;
    case 2:
      return DecimalType.second;
    case 3:
      return DecimalType.three;
    default:
      return DecimalType.none;
  }
}