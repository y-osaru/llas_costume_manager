import 'package:llas_costume_manager/model/card_info.dart';
import 'package:llas_costume_manager/model/db_provider.dart';

class CardInfoRepository{
  static DBProvider dbInstance = DBProvider.instance;

  static Future<List<CardInfo>> getCostume(int costumeId) async{
    final db = await dbInstance.database;
    final List<Map<String,dynamic>> maps = await db.rawQuery("""
    select
      c.id,
      c.name,
      c.image,
      c.costume_id,
      gm.method as get_method
    from
      card_info c inner join costume_info cos on c.costume_id = cos.id
      inner join get_method gm on c.get_method_id = gm.id
    where
	    costume_id = ?
    """,[costumeId]);

    return List.generate(maps.length, (index) => 
      CardInfo(
        id:maps[index]["id"],
        name:maps[index]["name"],
        image:maps[index]["image"],
        costumeId:maps[index]["costume_id"],
        getMethod:maps[index]["get_method"]
      ));
  }

  static Future<Map<int,int>> getCardCountByCostume(int unitId) async{
    final db = await dbInstance.database;
    final List<Map<String,dynamic>> maps = await db.rawQuery("""
    select
      costume_id,
      count(*) as card_count
    from
	    card_info c inner join costume_info cos on c.costume_id = cos.id
    where 
	    cos.unit_id = ?
    group by costume_id
    order by costume_id
    """,[unitId]);

    Map<int,int> cardCountMap = {};
    for(Map<String,dynamic> row in maps){
      cardCountMap[row["costume_id"]] = row["card_count"];
    }

    return cardCountMap;
  }
}