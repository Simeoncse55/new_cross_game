import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'package:circular_pattern/circular_pattern.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Game currGame;

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    // late Game myHints = currGame;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shuffle_rounded),
        onPressed: () {
          currGame.hints.shuffle();
          setState(() {});
        },
      ),
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, index) {
          print(index);
          var _level = index + 1;
          var _hintBadge = 3;

          currGame = game[index];

          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, colors: [
              Colors.black87,
              Colors.deepPurple,
            ])
                // image: DecorationImage(image: AssetImage('images/bg1.png'), fit: BoxFit.cover),
                ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.jumpToPage(index - 1);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 50,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            controller.jumpToPage(index + 1);
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 50,
                            color: Colors.white,
                          )),
                    ],
                  ),

                  /// GRID VIEW BUILDER
                  GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: currGame.gridCount,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: game[index].boxes.length,
                      itemBuilder: (context, boxIndex) {
                        final currBox = game[index].boxes[boxIndex];

                        return Stack(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: currBox.value == null
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  currBox.filled ? (currBox.value ?? "") : "",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: CircularPattern(

                      pointRadius: 3,
                      onStart: () {},
                      onComplete: (List<PatternDot> input) {
                        final hints = currGame.hints;
                        debugPrint(hints.toString());
                        debugPrint(input.toString());

                        String answer = '';
                        // input.forEach((element) {
                        //   answer += hints[element];
                        // });
                        final ans = currGame.answers
                            .where((e) =>
                                e.value?.toLowerCase() == answer.toLowerCase())
                            .firstOrNull;
                        if (ans != null) {
                          currGame.boxes[ans.position[0]].filled = true;
                          currGame.boxes[ans.position[1]].filled = true;
                          if (answer.length == 3 || answer.length == 4) {
                            currGame.boxes[ans.position[2]].filled = true;
                          }
                          if (answer.length == 4) {
                             currGame.boxes[ans.position[3]].filled = true;
                          }
                        }
                        setState(() {});
                      },
                      dots: currGame.hints
                          .map((e) => PatternDot(value: e))
                          .toList(),

                      ///Optionally edit color and font themes with CircularPatternOptions()
                      options:  const CircularPatternOptions(

                        primaryTextStyle: TextStyle(
                        fontSize: 8,
                          color: Colors.black,
                        ),
                        primaryDotColor: Colors.transparent,
                        selectedTextStyle: TextStyle(color: Colors.white , ),
                        selectedDotColor: Colors.deepOrange,

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _hintGen() {
    print('_hintGen');
    final withVal = currGame.boxes
        .where(
          (element) => element.value != null,
        )
        .toList();
    final va = Random().nextInt((withVal.length - 1));

    int position = withVal[va].position;
    if (currGame.boxes[position].filled == true) {
      position = _hintGen();
    }
    return position;
  }
}
