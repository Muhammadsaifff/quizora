import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<Map<String, String>> questions = [
    {
      'question': 'What is the capital of Pakistan?',
      'A': 'Karachi',
      'B': 'Lahore',
      'C': 'Islamabad',
      'D': 'Peshawar',
      'correct': 'C. Islamabad'
    },
    {
      'question': 'Who is the developer of this app?',
      'A': 'Ali',
      'B': 'Saif',
      'C': 'Ahmed',
      'D': 'Hassan',
      'correct': 'B. Saif'
    },
    {
      'question': 'What is the national language of Pakistan?',
      'A': 'Urdu',
      'B': 'English',
      'C': 'Punjabi',
      'D': 'Pashto',
      'correct': 'A. Urdu'
    },
  ];
  List<String> selectedAnswers = [];

  void _navigateAndSelectAnswer(BuildContext context) async {
    if (currentQuestionIndex >= questions.length) {
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuestionScreen(
          question: questions[currentQuestionIndex])),
    );

    if (result != null && result is String) {
      setState(() {
        selectedAnswers.add(result);
        currentQuestionIndex++;
      });

      if (currentQuestionIndex >= questions.length) {
        _showResults();
      } else {
        _navigateAndSelectAnswer(context);
      }
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(questions.length, (index) {
              return Text(
                'Q${index + 1}: ${questions[index]
                ['question']}\nYour Answer: ${selectedAnswers[index]
                }\nCorrect Answer: ${questions[index]['correct']}\n',
                textAlign: TextAlign.left,
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0;
                  selectedAnswers.clear();
                });
              },
              child: const Text('Restart Quiz'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateAndSelectAnswer(context),
          child:  const Text('Start Quiz'),
        ),
      ),
    );
  }
}

class QuestionScreen extends StatelessWidget {
  final Map<String, String> question;
  QuestionScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Question')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question['question']!, style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            AnswerButton(answer: 'A. ${question['A']!}', 
              correctAnswer: question['correct']!, context: context),
            AnswerButton(answer: 'B. ${question['B']!}', 
              correctAnswer: question['correct']!, context: context),
            AnswerButton(answer: 'C. ${question['C']!}', 
              correctAnswer: question['correct']!, context: context),
            AnswerButton(answer: 'D. ${question['D']!}', 
              correctAnswer: question['correct']!, context: context),
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answer;
  final String correctAnswer;
  final BuildContext context;

  AnswerButton({required this.answer, required this.correctAnswer, 
    required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(this.context, answer);
          },
          child: Text(answer),
        ),
      ),
    );
  }
}
