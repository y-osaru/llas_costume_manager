class UnitInfo{
  final int id;
  final String name;
  final String image;

  UnitInfo({required this.id,required this.name,required this.image});
  
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "name":name,
      "image":image
    };
  }
}