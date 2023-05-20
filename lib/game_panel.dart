import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

List<String> displayXO = ['', '', '', '', '', '', '', '', ''];

int filledBoxes = 0;

class PlayerModel {
  final String? playerName;
  final String? playerSymbol;
  final int? playerScore;

  PlayerModel({this.playerName, this.playerSymbol, this.playerScore});

  factory PlayerModel.fromJson(Map<String, dynamic> jsonData){
    return PlayerModel(
      playerName: jsonData['playerName'],
      playerSymbol: jsonData['playerSymbol'],
      playerScore: jsonData['playerScore']
    );
  }

  static Map<String, dynamic> toMap(PlayerModel player) => {
    'playerName': player.playerName,
    'playerSymbol': player.playerSymbol,
    'playerScore': player.playerScore
  };

  static String encode(List<PlayerModel> players) => json.encode(
    players
      .map<Map<String, dynamic>>((player)=>PlayerModel.toMap(player))
        .toList()
  );

  static List<PlayerModel> decode(String players) =>
      (json.decode(players) as List<dynamic>)
      .map<PlayerModel>((item) => PlayerModel.fromJson(item))
      .toList();
}

class Game extends StatefulWidget {
  const Game({super.key, required this.player1, required this.player2});

  final String player1;
  final String player2;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  int player1Score = 0;
  int player2Score = 0;
  int round = 1;

  bool oTurn = true;

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Are you sure to exit?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {

                if(widget.player1!='' && widget.player2!='') {
                  if (player1Score > player2Score) {
                    final SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    final String? playerListString = await prefs.getString(
                        'players_key');
                    if(playerListString != null) {
                      final List<PlayerModel> playerList = PlayerModel.decode(
                          playerListString!);
                      playerList.add(
                          PlayerModel(
                            playerName: widget.player1,
                            playerSymbol: 'O',
                            playerScore: player1Score,
                          )
                      );
                      final String newPlayer = PlayerModel.encode(playerList);
                      await prefs.setString('players_key', newPlayer);
                    }
                    else {
                      final List<PlayerModel> playerList = [];
                      playerList.add(
                          PlayerModel(
                            playerName: widget.player1,
                            playerSymbol: 'O',
                            playerScore: player1Score,
                          )
                      );
                      final String newPlayer = PlayerModel.encode(playerList);
                      await prefs.setString('players_key', newPlayer);
                    }
                  } else {
                    final SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    final String? playerListString = await prefs.getString(
                        'players_key');
                    if (playerListString != null) {
                      final List<PlayerModel> playerList = PlayerModel.decode(
                          playerListString!);
                      playerList.add(
                          PlayerModel(
                            playerName: widget.player2,
                            playerSymbol: 'X',
                            playerScore: player2Score,
                          )
                      );
                      final String newPlayer = PlayerModel.encode(playerList);
                      await prefs.setString('players_key', newPlayer);
                    }
                    else {
                      final List<PlayerModel> playerList = [];
                      playerList.add(
                          PlayerModel(
                            playerName: widget.player2,
                            playerSymbol: 'X',
                            playerScore: player2Score,
                          )
                      );
                      final String newPlayer = PlayerModel.encode(playerList);
                      await prefs.setString('players_key', newPlayer);
                    }
                  }
                }
                player1Score=0;
                player2Score=0;
                round=1;
                _clearBoard();
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, 'playerinfo', (route) => false);
                //Navigator.of(context).pop();
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
    });
    filledBoxes = 0;
    oTurn = true;
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Draw !!! \nOne point for each player",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          actions: [
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  player1Score++;
                  player2Score++;
                  round++;
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          String winnerText= widget.player1;
          if(winner == 'X'){
            winnerText = widget.player2;
          }
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Congratulations !!! \n$winnerText won (+3 Points)",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            actions: [
              Align( alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    round++;
                    if(winner == 'X'){
                      player2Score = player2Score+3;
                    } else {
                      player1Score = player1Score+3;
                    }
                    _clearBoard();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _tapped(int index) {
    setState(() {
      if (oTurn && displayXO[index] == '') {
        displayXO[index] = 'O';
        filledBoxes += 1;
        const Text('O');
      } else if (!oTurn && displayXO[index] == '') {
        displayXO[index] = 'X';

        filledBoxes += 1;
      }
      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      _showWinDialog(displayXO[3]);
    } else if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      _showWinDialog(displayXO[6]);
    } else if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      _showWinDialog(displayXO[1]);
    }
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      _showWinDialog(displayXO[2]);
    } else if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      _showWinDialog(displayXO[2]);
    } else if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    String player1 = widget.player1;
    String player2 = widget.player2;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Game Panel', style: TextStyle(color: Colors.black),)
      ),
      backgroundColor: Colors.greenAccent.shade100,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$player1 ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "Score: $player1Score",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$player2 ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "Score: $player2Score",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:1.0),
            child: const Divider(color:Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Round ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  round.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Turn ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  oTurn == true ? '$player1 (O)' : '$player2 (X)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:1.0),
            child: const Divider(color:Colors.black),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              padding: const EdgeInsets.all(20),
              itemCount: 9,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayXO[index],
                        style: TextStyle(
                          //color: Colors.green,
                          color: (displayXO[index] == 'X') ? Colors.red : Colors.blue,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  player1Score=0;
                  player2Score=0;
                  round = 0;
                  _clearBoard();
                  //Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _showExitDialog();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Exit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
        ],
      ),
    );
  }
}
