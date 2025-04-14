import 'package:flutter/material.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/features/quiz/page/quiz_screen.dart';
class QuizDetailPage extends StatelessWidget {
  final Quiz quiz;

  // Mock data for quiz history - in a real app, this would come from an API or database
  final List<QuizAttempt> quizHistory = [
    QuizAttempt(
      attemptId: 1,
      score: 85,
      totalQuestions: 10,
      correctAnswers: 8.5,
      timeTaken: 7,
      attemptDate: DateTime.now().subtract(Duration(days: 2)),
      isPassed: true,
    ),
    QuizAttempt(
      attemptId: 2,
      score: 90,
      totalQuestions: 10,
      correctAnswers: 9,
      timeTaken: 6,
      attemptDate: DateTime.now().subtract(Duration(days: 1)),
      isPassed: true,
    ),
  ];

  QuizDetailPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Header
            _buildQuizHeader(),

            // Quiz Info
            _buildQuizInfo(),

            // Quiz Stats
            _buildQuizStats(),

            // Quiz History
            _buildQuizHistory(),

            // Start Quiz Button
            _buildStartQuizButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quiz.quizName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            quiz.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.question_answer,
            title: 'Total Questions',
            value: '${quiz.questions.length} questions',
          ),
          _buildInfoRow(
            icon: Icons.timer,
            title: 'Time Limit',
            value: quiz.timeLimitMinutes != null ? '${quiz.timeLimitMinutes} minutes' : 'No time limit',
          ),
          _buildInfoRow(
            icon: Icons.check_circle_outline,
            title: 'Passing Score',
            value: quiz.passingScore != null ? '${quiz.passingScore}%' : 'Not specified',
          ),
          _buildInfoRow(
            icon: Icons.calendar_today,
            title: 'Created',
            value: quiz.createdAt != null ? _formatDate(quiz.createdAt!) : 'Not available',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizStats() {
    // Calculate average score from history
    double averageScore = quizHistory.isEmpty
        ? 0
        : quizHistory.map((e) => e.score).reduce((a, b) => a + b) / quizHistory.length;

    // Calculate best score
    double bestScore = quizHistory.isEmpty
        ? 0
        : quizHistory.map((e) => e.score).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Attempts',
                  value: '${quizHistory.length}',
                  icon: Icons.repeat,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Average Score',
                  value: '${averageScore.toStringAsFixed(1)}%',
                  icon: Icons.analytics,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Best Score',
                  value: '${bestScore.toStringAsFixed(1)}%',
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizHistory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          quizHistory.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You haven\'t attempted this quiz yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: quizHistory.length,
            itemBuilder: (context, index) {
              final attempt = quizHistory[index];
              return _buildHistoryCard(attempt);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(QuizAttempt attempt) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attempt #${attempt.attemptId}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: attempt.isPassed ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  attempt.isPassed ? 'PASSED' : 'FAILED',
                  style: TextStyle(
                    color: attempt.isPassed ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildAttemptDetail(
                label: 'Date',
                value: _formatDate(attempt.attemptDate),
                icon: Icons.calendar_today,
              ),
              _buildAttemptDetail(
                label: 'Score',
                value: '${attempt.score}%',
                icon: Icons.score,
              ),
              _buildAttemptDetail(
                label: 'Time',
                value: '${attempt.timeTaken} min',
                icon: Icons.timer,
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: attempt.score / 100,
              backgroundColor: Colors.grey.shade200,
              color: _getScoreColor(attempt.score),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Correct answers: ${attempt.correctAnswers} out of ${attempt.totalQuestions}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptDetail({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartQuizButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to quiz taking page
          // Implementation would depend on your routing setup
          Navigator.push(context, MaterialPageRoute(builder: (_){
            return QuizScreen(quiz: quiz);
          }));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 54),
        ),
        child: Text(
          'Start Quiz',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.amber;
    return Colors.red;
  }
}

// Model for quiz attempt history
class QuizAttempt {
  final int attemptId;
  final double score;
  final double totalQuestions;
  final double correctAnswers;
  final int timeTaken; // in minutes
  final DateTime attemptDate;
  final bool isPassed;

  QuizAttempt({
    required this.attemptId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.attemptDate,
    required this.isPassed,
  });
}