import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llas_costume_manager/model/repository/card_info_repository.dart';
import 'package:llas_costume_manager/model/repository/costume_info_repository.dart';
import 'package:llas_costume_manager/model/unit_info.dart';
import 'package:llas_costume_manager/ui/card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/costume_info.dart';

class CostumeWidget extends StatefulWidget{
  final UnitInfo unitInfo;
  const CostumeWidget({Key? key,required this.unitInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CostumeState();
}

class CostumeState extends State<CostumeWidget>{
  final _biggerFont = const TextStyle(fontSize:14.0);
  List<CostumeInfo> _costumeInfoList = <CostumeInfo>[];
  Map<int,int> _cardCountByCostumeMap = {};
  final Map<int,int> _haveCardCountByCostumeMap = {};

  void _createHaveCardCount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int costumeId in _cardCountByCostumeMap.keys){
      List<String>? saveData = prefs.getStringList(costumeId.toString());
      if(saveData != null){
        _haveCardCountByCostumeMap[costumeId] = saveData.length;
      }else{
        _haveCardCountByCostumeMap[costumeId] = 0;
      }
    }
  }

  @override
  void initState(){
    super.initState();
    CardInfoRepository.getCardCountByCostume(widget.unitInfo.id)
      .then((map) => _cardCountByCostumeMap = map)
      .then((value) => _createHaveCardCount());
  }

  @override 
  Widget build(BuildContext context){
    Widget futureBuilder;
    if(_costumeInfoList.isEmpty){
      futureBuilder = FutureBuilder(
        future:CostumeInfoRepository.getCostume(widget.unitInfo.id),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text("loading...");
            default:
              if(snapshot.hasError){
                return const Text("Error");
              }else{
                _costumeInfoList = snapshot.data;
                return _buildCostumeList(context,_costumeInfoList);
              }
          }
        }
      );
    }else{
      futureBuilder = _buildCostumeList(context,_costumeInfoList);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unitInfo.name + " 衣装一覧")
      ),
      body: futureBuilder
    );
  }

  Widget _buildCostumeList(BuildContext context, List<CostumeInfo>  costumeInfoList){
    return ListView.builder(
      itemBuilder: (context,index){
        return _buildRow(costumeInfoList[index]);
      },
      itemCount: costumeInfoList.length);
  }

  Widget _buildRow(CostumeInfo costumeInfo){
    bool isComplete = false;
    if(_haveCardCountByCostumeMap[costumeInfo.id] == _cardCountByCostumeMap[costumeInfo.id]){
      isComplete = true;
    }
    return ListTile(
      leading: const Icon(Icons.arrow_forward_ios_rounded),
      title:Text(costumeInfo.name,style:_biggerFont),
      subtitle: Text("所持状況: "
      + _haveCardCountByCostumeMap[costumeInfo.id].toString()
      + " / "
      + _cardCountByCostumeMap[costumeInfo.id].toString()),
      tileColor: isComplete ? Colors.pink.shade50 : null,
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder:(BuildContext context){
              return CardWidget(costumeInfo: costumeInfo);
            }
          ),
        ).then((value) => 
          setState((){
            _createHaveCardCount();
          })
        );
      },
    );
  }
}
