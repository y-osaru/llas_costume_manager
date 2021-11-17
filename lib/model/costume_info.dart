class CostumeInfo{
  final int id;
  final String name;
  final int unitId;

  CostumeInfo({required this.id,required this.name,required this.unitId});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "name":name,
      "unit_id":unitId
    };
  }
}