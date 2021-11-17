import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llas_costume_manager/model/unit_info.dart';
import 'costume.dart';
import '../model/repository/unit_info_repository.dart';

class UnitWidget extends StatefulWidget{
  const UnitWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UnitState();
}

class UnitState extends State<UnitWidget>{
  final _biggerFont = const TextStyle(fontSize:14.0);

  @override 
  Widget build(BuildContext context){
    //ユニット情報取得
    var futureBuilder = FutureBuilder(
      future:UnitInfoRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text("loading...");
          default:
            if(snapshot.hasError){
              return const Text("Error");
            }else{
              return _buildUnitList(context,snapshot);
            }
        }
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("LLAS 衣装管理")
      ),
      body: futureBuilder,
    );
  }

  Widget _buildUnitList(BuildContext context, AsyncSnapshot snapshot){
    List<UnitInfo> unitInfoList = snapshot.data;
    return ListView.builder(
      itemBuilder: (context,index){
        return _buildRow(unitInfoList[index]);
      },
      itemCount: unitInfoList.length);
  }

  Widget _buildRow(UnitInfo unitInfo){
    return ListTile(
      leading: const Icon(Icons.arrow_forward_ios_rounded),
      title:Text(unitInfo.name,style:_biggerFont),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder:(BuildContext context){
              return CostumeWidget(unitInfo: unitInfo);
            }
          ),
        );
      },
    );
  }
}
