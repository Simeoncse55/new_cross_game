
import 'package:circular_pattern/circular_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Game currGame;
  int _answerCount = 0;

  List<Game> _games = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _games.clear();
    _games = Data.game;
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(
        initialPage: 0,
        keepPage: true
    );

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
        controller: pageController,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: _games.length,
        itemBuilder: (context, index) {
          print(index);

          currGame = _games[index];

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
                            pageController.jumpToPage(index - 1);
                            _answerCount = 0;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 50,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            pageController.jumpToPage(index + 1);
                            _answerCount = 0;
                            setState(() {});
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
                      itemCount: currGame.boxes.length,
                      itemBuilder: (context, boxIndex) {
                        final currBox = currGame.boxes[boxIndex];

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
                    height: 280,
                    decoration: const BoxDecoration(
                      color: Colors.white12,
                      shape: BoxShape.circle,
                    ),
                    child: CircularPattern(
                      pointRadius: 42,
                      onStart: () {},
                      minInputLength: 2,
                      onComplete: (List<PatternDot> input) async {
                        final hints = currGame.hints;
                        debugPrint(hints.toString());
                        debugPrint(input.toString());
                        String answer = '';
                        input.forEach((element) {
                          answer += element.value;
                        });
                        final ans = currGame.answers
                            .where((e) =>
                        e.value?.toLowerCase() == answer.toLowerCase())
                            .firstOrNull;
                        if (ans != null) {
                          _answerCount++;
                          if (answer.length >= 2) {
                            currGame.boxes[ans.position[0]].filled = true;
                            currGame.boxes[ans.position[1]].filled = true;
                          }
                          if (answer.length >= 3) {
                            currGame.boxes[ans.position[2]].filled = true;
                          }
                          if (answer.length >= 4) {
                            currGame.boxes[ans.position[3]].filled = true;
                          }
                          if (answer.length >= 5) {
                            currGame.boxes[ans.position[4]].filled = true;
                          }
                          if (answer.length >= 6) {
                            currGame.boxes[ans.position[5]].filled = true;
                          }
                          setState(() {});
                          if (_answerCount == currGame.answers.length) {
                            debugPrint('$_answerCount');
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Dialog Title',
                                desc: 'Dialog description here.............',
                                btnOkOnPress: (){
                                  pageController.jumpToPage(index +1);
                            },
                        ).show();
                        setState(() {});
                      }
                      }
                      },
                      dots: currGame.hints
                          .map((e) => PatternDot(value: e))
                          .toList(),
                      options: const CircularPatternOptions(
                        primaryTextStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        primaryDotColor: Colors.transparent,
                        selectedTextStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

// int _hintGen() {
//   print('_hintGen');
//   final withVal = currGame.boxes
//       .where(
//         (element) => element.value != null,
//       )
//       .toList();
//   final va = Random().nextInt((withVal.length - 1));
//
//   int position = withVal[va].position;
//   if (currGame.boxes[position].filled == true) {
//     position = _hintGen();
//   }
//   return position;
// }
}
