import 'package:llas_costume_manager/model/costume_info.dart';
import 'package:llas_costume_manager/model/db_provider.dart';

class CostumeInfoRepository{
  static String table = "costume_info";
  static DBProvider dbInstance = DBProvider.instance;

  static Future<List<CostumeInfo>> getCostume(int unitId) async{
    final db = await dbInstance.database;
    final List<Map<String,dynamic>> maps = await db.query(table,where:"unit_id=?",whereArgs:[unitId]);

    return List.generate(maps.length, (index) => 
      CostumeInfo(
        id:maps[index]["id"],
        name:maps[index]["name"],
        unitId:maps[index]["unit_id"]
      ));
  }
}