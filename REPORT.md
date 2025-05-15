# MP Report

## Team

- Name: Your Name
- AID: A12345678

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all
      that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
  - [X] Google Chrome
- [X] The dice rolling mechanism works correctly
- [X] The scorecard works correctly
- [X] Scores are correctly calculated for all categories
- [X] The game end condition is correctly implemented, and the final score is
      correctly displayed
- [X] The game state is reset when the user dismisses the final score
- [X] The implementation separates layout from data, involving the use of data
      model classes separate from custom widgets

## Summary and Reflection

To notify players that they already chose a category, it sends a notification that they already chose it. I was not sure of what other way I could have notified the players. I was thinking of changing the look of tthe category widget when it was already chosen, but I think it would have been too complexe to implement. I also had to figure out a way have two columns of categories. I wonder if ListView already has a way to do this.
For this machine problem, I tried to keep the layout of the code as simplistic as I could. You have the primary widget builders for the dice and categories, and then functions that allow you to play the game.   

I liked making the layout and design for the game. It was a little tough adding the game functionality. Before starting the MP, I wish I would have known how to play the game. I have never played Yahtzee and had to spend time learning how the game works.