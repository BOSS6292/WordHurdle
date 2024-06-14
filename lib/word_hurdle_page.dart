import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/helper_functions.dart';
import 'package:word_hurdle/hurdle_provider.dart';
import 'package:word_hurdle/keyboard_view.dart';
import 'package:word_hurdle/wordle_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: provider.hurdleBoard.length,
                      itemBuilder: (context, index) {
                        final wordle = provider.hurdleBoard[index];
                        return WordleView(wordle: wordle);
                      }),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyBoardView(
                  excludedLetters: provider.excludedLetters,
                  onPressed: (value) {
                    provider.inputLetters(value);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          provider.deleteLetters();
                        },
                        child: const Text('DELETE')),
                    ElevatedButton(
                        onPressed: provider.isInputValid
                            ? () {
                                _handleInput(provider);
                              }
                            : null,
                        child: const Text('SUBMIT')),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleInput(HurdleProvider provider) {
    if (!provider.isAValidWord) {
      showMsg(context, 'This word is not in Dictionary');
    }

    if (provider.shouldCHeckForAnswer) {
      provider.checkAnswer();
    }

    if (provider.wins) {
      showResults(
          context: context,
          title: 'You win!!',
          body: 'The word was ${provider.targetWord}',
          onCancel: () {
            Navigator.pop(context);
          },
          onPlayAgain: () {
            Navigator.pop(context);
            provider.reset();
          });
    } else if (provider.noAttemptsLeft) {
      showResults(
          context: context,
          title: 'You Lost!!',
          body: 'The word was ${provider.targetWord}',
          onCancel: () {
            Navigator.pop(context);
          },
          onPlayAgain: () {
            Navigator.pop(context);
            provider.reset();
          });
    }
  }
}
