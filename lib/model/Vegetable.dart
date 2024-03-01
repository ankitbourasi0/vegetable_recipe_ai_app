

class Vegetable {
  final String label;
  final String image;
   double? _unitInKg;

   Vegetable({
    required this.label,
    required this.image,

  });




  void addUnit(double unit) {
    _unitInKg = unit;
  }

  double get unitInKg {
    if (_unitInKg == null) {
      throw Exception('Unit not yet added for this vegetable');
    }
    return _unitInKg!; // Use non-null assertion after checking
  }


}