import 'package:flutter/material.dart';
import 'package:tic_tac_toe/players_info.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to TTT', style: TextStyle(color: Colors.black),)),
      backgroundColor: Colors.greenAccent.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                height: MediaQuery.of(context).size.height*.9,
                color: Colors.greenAccent.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(top:18.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                "assets/background.png",
                                width: MediaQuery.of(context).size.width * 0.95,
                              ),
                              Image.asset(
                                "assets/words.png",
                                width: 133,
                              ),
                            ],
                          ),
                          Positioned(
                            //right: 0,
                            bottom: -90,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                              child: Center(
                                child: Text(
                                  'V 1.0',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'playerinfo');
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayersInfo(),),);
                          },
                        child: const Text(
                          "Continue >>",
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
