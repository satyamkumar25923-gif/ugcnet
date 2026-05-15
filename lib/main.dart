import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Internal Imports
import 'core/theme.dart';
import 'providers/exam_provider.dart';
import 'data/models/question_model.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/mock_test_screen.dart';
import 'presentation/screens/result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization would go here if configured
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExamProvider()),
      ],
      child: const NetPrepMaster(),
    ),
  );
}

class NetPrepMaster extends StatelessWidget {
  const NetPrepMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NET Prep Master',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/subjects': (context) => const SubjectSelectionScreen(),
        '/mock-test': (context) => const MockTestScreen(),
        '/results': (context) => const ResultScreen(),
        '/review': (context) => const ReviewScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'NET Prep Master',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Success Starts Here',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Subject')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSubjectSection(context, 'Paper 1', [
            'General Teaching & Research',
            'Teaching Aptitude',
            'Research Aptitude',
            'ICT',
          ]),
          const SizedBox(height: 24),
          _buildSubjectSection(context, 'Paper 2', [
            'Education',
            'History',
            'Sociology',
          ]),
        ],
      ),
    );
  }

  Widget _buildSubjectSection(BuildContext context, String title, List<String> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...subjects.map((subject) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(subject),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              // Load dummy questions for demo
              final String response = await rootBundle.loadString('assets/data/dummy_questions.json');
              final List<dynamic> data = json.decode(response);
              final questions = data.map((q) => Question.fromJson(q)).toList();
              
              if (context.mounted) {
                Provider.of<ExamProvider>(context, listen: false).setQuestions(questions);
                Navigator.pushNamed(context, '/mock-test');
              }
            },
          ),
        )).toList(),
      ],
    );
  }
}

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExamProvider>(context);
    final questions = provider.questions;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Questions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final userAnswer = provider.userAnswers[index];
          final isCorrect = userAnswer == q.correctAnswer;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(q.question),
                  const Divider(height: 24),
                  _buildReviewOption('Correct Answer', q.correctAnswer, true),
                  if (!isCorrect && userAnswer != null)
                    _buildReviewOption('Your Answer', userAnswer, false),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(q.explanation),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewOption(String label, String value, bool isCorrect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isCorrect ? AppTheme.successGreen : AppTheme.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
