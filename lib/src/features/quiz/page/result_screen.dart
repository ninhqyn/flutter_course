import 'package:flutter/material.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/features/quiz/page/quiz_detail_page.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.quiz,
    required this.quizResultResponse
  });

  final Quiz quiz;
  final QuizResultResponse quizResultResponse;
  void handleBack(BuildContext context){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
      return QuizDetailPage(quiz: quiz);
    }));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quiz Results',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                handleBack(context);
              }),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildScoreCircle(quizResultResponse.score),
                const SizedBox(height: 20),
                Text(
                'Bạn đúng ${quizResultResponse.correctAnswers} câu trên tổng số ${quiz.questions.length} câu'
                ,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getScoreMessage(quizResultResponse.score),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      handleBack(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(double percentage) {
    Color scoreColor;
    if (percentage >= 80) {
      scoreColor = Colors.green;
    } else if (percentage >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: scoreColor,
              strokeWidth: 12,
            ),
          ),
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }



  String _getScoreMessage(double percentage) {
    if (percentage >= 80) {
      return 'Excellent work! Great job mastering this quiz!';
    } else if (percentage >= 60) {
      return 'Good effort! You\'re on the right track.';
    } else {
      return 'Keep practicing! You\'ll improve with more study.';
    }
  }
}