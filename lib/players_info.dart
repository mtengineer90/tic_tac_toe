import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_panel.dart';

class PlayersInfo extends StatefulWidget {
  const PlayersInfo({super.key});

  @override
  State<PlayersInfo> createState() => _PlayersInfoState();
}

class _PlayersInfoState extends State<PlayersInfo> {

  TextEditingController player1Controller = TextEditingController();
  TextEditingController player2Controller = TextEditingController();


  @override
  void initState() {
    player1Controller.text = '';
    player2Controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Players Panel', style: TextStyle(color: Colors.black),)
      ),
      backgroundColor: Colors.greenAccent.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:1.0),
                  child: const Divider(color:Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.account_box,
                              color: Colors.grey,
                              size:27
                            ),
                          ),
                          Flexible(
                            flex:4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: player1Controller,
                                decoration: InputDecoration(
                                    enabled: true,
                                    //hintText: 'hint',
                                    helperText: 'Player 1',
                                    //labelText: 'label',
                                    //counterText: 'counter'
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Container()
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: IconButton(
                      onPressed: (){
                        String player1 = player1Controller.text;
                        String player2 = player2Controller.text;
                        player1Controller.text = player2;
                        player2Controller.text = player1;
                  },
                      icon:  Icon(
                        Icons.import_export,
                      size: 50,)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                                Icons.account_box,
                                color: Colors.grey,
                                size:27
                            ),
                          ),
                          Flexible(
                            flex:4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: player2Controller,
                                decoration: InputDecoration(
                                  enabled: true,
                                  //hintText: 'hint',
                                  helperText: 'Player 2',
                                  //labelText: 'label',
                                  //counterText: 'counter'
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                  child: Container()
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:1.0),
                  child: const Divider(color:Colors.black),
                ),
                Text("Heros List:", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
              ],
            ),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.done:
                    String? playerListString = snapshot.data!.getString('players_key');
                    if(playerListString != null) {
                      List<PlayerModel> playerList = PlayerModel.decode(playerListString!);
                      return SingleChildScrollView(
                          primary: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height*.4,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: playerList.length,
                            itemBuilder: (BuildContext context, int index ){
                              return Dismissible(
                                key: Key(playerList[index].toString()),
                                background: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                    child: Icon(Icons.delete,size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  setState(() {
                                    playerList.removeAt(index);
                                  });
                                  final String newPlayer = PlayerModel.encode(playerList);
                                  await snapshot.data!.setString('players_key', newPlayer);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Icon(
                                                Icons.star, color: Colors.orange,size: 50),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(playerList[index].playerName!,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                                Text(playerList[index].playerSymbol!,style: TextStyle( fontSize: 24, color: playerList[index].playerSymbol! =='X' ? Colors.blue : Colors.red),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      Align(alignment:Alignment.centerRight,
                                        child: Text(textAlign: TextAlign.end,
                                          playerList[index].playerScore.toString(),

                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ),
                      );

                    }
                    else {
                      return Container();
                    }
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator(color: Colors.green,));
                  default:
                    return Container();
                }
              },
            ),

          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FloatingActionButton(
          child: const Icon(
            size: 40,
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('gamepanel' ,arguments: [player1Controller.text ?? '',player2Controller.text ?? '']);

          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}
