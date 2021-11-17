import 'package:llas_costume_manager/model/db_provider.dart';
import 'package:llas_costume_manager/model/unit_info.dart';

class UnitInfoRepository{
  static String table = "unit_info";
  static DBProvider dbInstance = DBProvider.instance;

  static Future<List<UnitInfo>> getAll() async{
    final db = await dbInstance.database;
    final List<Map<String,dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (index) => 
      UnitInfo(
        id:maps[index]["id"],
        name:maps[index]["name"],
        image:maps[index]["image"]));
  }
}