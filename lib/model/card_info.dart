class CardInfo{
  final int id;
  final String name;
  final String image;
  final int costumeId;
  final String getMethod;

  CardInfo({required this.id,required this.name,required this.image,
            required this.costumeId,required this.getMethod});
  
  Map<String,dynamic> toMap(){
    return{
      "id":id,
      "name":name,
      "image":image,
      "costume_id":costumeId,
      "get_method":getMethod
    };
  }
}