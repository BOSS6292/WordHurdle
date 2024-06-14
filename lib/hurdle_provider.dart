import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:word_hurdle/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count = 0;
  int wordSize = 5;
  int index = 0;
  bool wins = false;
  int attempts = 0;
  int totalAttempts = 6;

  bool get shouldCHeckForAnswer => rowInputs.length == wordSize;

  bool get noAttemptsLeft => attempts == totalAttempts;

  init() {
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord =>
      totalWords.contains(rowInputs.join('').toLowerCase());

  inputLetters(String letter) {
    if (count < wordSize) {
      count++;
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      //print(rowInputs);
      notifyListeners();
    }
  }

  void deleteLetters() {
    if (count > 0) {
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
      notifyListeners();
    }
  }

  void checkAnswer() {
    final input = rowInputs.join('');
    if (input == targetWord) {
      wins = true;
    } else {
      _markLettersOnBoard();
      _goToNextRow();
    }
  }

  void _markLettersOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  reset() {
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }

  bool get isInputValid => rowInputs.length == wordSize;
}
