import 'checkbox_type.dart';

class CheckboxModel {
  CheckboxModel({
    required this.type,
    this.isSelected = false,
  });

  CheckboxType type;
  bool isSelected;
}
