import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/dice.dart';
import '../models/scorecard.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yahtzee',
      home: Scaffold(
        body: Center(
          child: GameScreen(),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override 
  _screenState createState() => _screenState();
}

class _screenState extends State<GameScreen> {
  late Dice dice;
  late ScoreCard scoreCard;
  int rolls = 3;
  int totalScore = 0;
  Set<ScoreCategory> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    dice = Dice(6);
    scoreCard = ScoreCard();
  }

  // function to handle the dice roll feature
  void rollDice() {
    setState(() {
      if (rolls > 0 && selectedCategories.length < ScoreCategory.values.length) {
        dice.roll();
        rolls--;
      }
    });
  }

  // function to handle to dice holding feature
  void holdDice(int index) {
    setState(() {
      dice.toggleHold(index);
    });
  }

  // function to handle the selection of categories, update score, and end the game
  void selectCategory(ScoreCategory category) {
    if(scoreCard[category] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already selected this category"),  
        )
      );
    }

    if (scoreCard[category] == null) {
      final diceValues = dice.values;
      scoreCard.registerScore(category, diceValues);
      selectedCategories.add(category);
      
      // if all categories have been already selected, give a game over notification
      if(selectedCategories.length == ScoreCategory.values.length) {
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Game Over",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              content: Text(
                "All categories have been selected! Total score: $totalScore",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 153, 204, 255),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "New Game",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    scoreCard.clear();
                    selectedCategories.clear();
                    rolls = 3;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      else {
        rolls = 3;
      }
      setState(() {});
    }
    dice.clear();
  }

  // function to end the turn
  void endTurn() {
    for(ScoreCategory category in ScoreCategory.values) {
      if(scoreCard[category] == null) {
        scoreCard.registerScore(category, dice.values);
        break;
      }
    }
    dice.clear();
  }

  // building the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yahtzee"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "rolls left: $rolls",
              style: const TextStyle(
                fontSize: 20
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++) 
                  GestureDetector(
                    onTap: () => holdDice(i),
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: dice.isHeld(i)
                            ? const Color.fromARGB(255, 255, 102, 102)
                            : const Color.fromARGB(255, 153, 204, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${i < dice.values.length ? dice.values[i] : ''}',
                        style: const TextStyle(
                            fontSize: 24,
                      ),
                      ),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: rolls > 0 ? rollDice : null, 
              child: const Text(
                "Roll Dice",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
           ListView.builder(
              shrinkWrap: true,
              itemCount: (ScoreCategory.values.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {

                // this is utilized to have two columns of categories
                  final categoryIndex1 = index * 2;
                  final categoryIndex2 = categoryIndex1 + 1;

                  final category1 = categoryIndex1 < ScoreCategory.values.length 
                    ? ScoreCategory.values[categoryIndex1] : null;

                  final category2 = categoryIndex2 < ScoreCategory.values.length
                    ? ScoreCategory.values[categoryIndex2] : null;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategory(category1)  
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildCategory(category2)
                          ),
                        ],
                      )
                    ],
                  );
              }
            ),            
            Text(
              "Total Score: $totalScore",
              style: const TextStyle(
                fontSize: 20
              ),
            ),  
          ],
        ),
      ),
    );
  }

  // utilized to create one category
  Widget _buildCategory(ScoreCategory? category) {
    if (category == null) {
      return Container();
    }

    final score = scoreCard[category];

    return GestureDetector(
      onTap: () {
        if (score == null) {
          selectCategory(category);
          totalScore = scoreCard.total;
        }
        if (score != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("already selected category")),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10) 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: const TextStyle(fontSize: 15),
            ),
            Text(score?.toString() ?? '0',
            style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  } 
}