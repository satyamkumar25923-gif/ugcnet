import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';

enum QuestionStatus { unanswered, answered, markedForReview }

class ExamProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  Map<int, String> _userAnswers = {};
  Map<int, QuestionStatus> _questionStatuses = {};
  
  Timer? _timer;
  int _remainingSeconds = 180 * 60; // 3 hours
  bool _isTestSubmitted = false;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Map<int, String> get userAnswers => _userAnswers;
  Map<int, QuestionStatus> get questionStatuses => _questionStatuses;
  int get remainingSeconds => _remainingSeconds;
  bool get isTestSubmitted => _isTestSubmitted;

  void setQuestions(List<Question> questions) {
    _questions = questions;
    _currentIndex = 0;
    _userAnswers = {};
    _questionStatuses = {for (var i = 0; i < questions.length; i++) i: QuestionStatus.unanswered};
    _remainingSeconds = 180 * 60;
    _isTestSubmitted = false;
    startTimer();
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        submitTest();
      }
    });
  }

  void selectOption(String option) {
    _userAnswers[_currentIndex] = option;
    _questionStatuses[_currentIndex] = QuestionStatus.answered;
    notifyListeners();
  }

  void markForReview() {
    _questionStatuses[_currentIndex] = QuestionStatus.markedForReview;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void submitTest() {
    _timer?.cancel();
    _isTestSubmitted = true;
    notifyListeners();
  }

  String get formattedTime {
    int hours = _remainingSeconds ~/ 3600;
    int minutes = (_remainingSeconds % 3600) ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get correctCount {
    int count = 0;
    _userAnswers.forEach((index, answer) {
      if (answer == _questions[index].correctAnswer) {
        count++;
      }
    });
    return count;
  }

  int get wrongCount => _userAnswers.length - correctCount;
  
  double get score => (correctCount * 2).toDouble(); // UGC NET gives 2 marks per question

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
