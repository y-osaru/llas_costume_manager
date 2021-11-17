import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llas_costume_manager/model/card_info.dart';
import 'package:llas_costume_manager/model/repository/card_info_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/costume_info.dart';

class CardWidget extends StatefulWidget{
  final CostumeInfo costumeInfo;
  const CardWidget({Key? key,required this.costumeInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardState();
}

class CardState extends State<CardWidget>{
  final _haveCards = <int>[];
  final _biggerFont = const TextStyle(fontSize:14.0);
  List<CardInfo> _cardInfoList = <CardInfo>[];
  
  void _getSaveData(int costumeId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var saveData = prefs.getStringList(costumeId.toString());
    if(saveData != null){
      for(String id in saveData){
        _haveCards.add(int.parse(id));
      }
    }
  }

  void _putSaveData(int costumeId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_haveCards.isNotEmpty){
      prefs.setStringList(costumeId.toString(), _haveCards.map((e) => e.toString()).toList());
    }else{
      prefs.remove(costumeId.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getSaveData(widget.costumeInfo.id);
  }

  @override 
  Widget build(BuildContext context){
    Widget futureBuilder;
    //既にカード情報を取得済みなら再取得しない
    if(_cardInfoList.isEmpty){
      futureBuilder = FutureBuilder(
        future:CardInfoRepository.getCostume(widget.costumeInfo.id),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text("loading...");
            default:
              if(snapshot.hasError){
                return const Text("Error");
              }else{
                _cardInfoList = snapshot.data;
                return _buildCostumeList(context,_cardInfoList);
              }
          }
        }
      );
    }else{
      futureBuilder = _buildCostumeList(context,_cardInfoList);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.costumeInfo.name + " カード一覧")
      ),
      body: futureBuilder
    );
  }

  Widget _buildCostumeList(BuildContext context, List<CardInfo> cardInfoList){
    return ListView.builder(
      itemBuilder: (context,index){
        return _buildRow(cardInfoList[index]);
      },
      itemCount: cardInfoList.length);
  }

  Widget _buildRow(CardInfo cardInfo){
    final isContains = _haveCards.contains(cardInfo.id);
    return ListTile(
      leading: Image(image:AssetImage('assets/image/'+cardInfo.image)),
      title:Text(cardInfo.name,style:_biggerFont),
      subtitle: Text(cardInfo.getMethod),
      tileColor: isContains ? Colors.pink.shade50 : null,
      onTap: (){
        setState((){
          if(isContains){
            _haveCards.remove(cardInfo.id);
          }else{
            _haveCards.add(cardInfo.id);
          }
          //disposeの時だけ保存すると、戻った時に情報が反映されない為、都度保存する。
          _putSaveData(widget.costumeInfo.id);
        });
      },
    );
  }

}
