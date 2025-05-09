import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:learning_app/src/features/quiz/bloc/quiz_detail/quiz_detail_bloc.dart';
import 'package:learning_app/src/features/quiz/page/quiz_screen.dart';

class QuizDetailPage extends StatelessWidget{
  const QuizDetailPage({super.key, required this.quiz});
  final Quiz quiz;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizDetailBloc(
          quiz: quiz,
          quizRepository: context.read<QuizRepository>()
      )..add(FetchQuizHistory()),
      child: QuizDetailView(quiz: quiz,),
    );
  }
}

class QuizDetailView extends StatefulWidget {
  final Quiz quiz;
  QuizDetailView({super.key, required this.quiz});

  @override
  State<QuizDetailView> createState() => _QuizDetailViewState();
}

class _QuizDetailViewState extends State<QuizDetailView> {
  
 final _scrollController = ScrollController();

 @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
 void dispose() {
    super.dispose();
   _scrollController.dispose(); 
 }
 void _onScroll(){
   if(_isBottom) {
     context.read<QuizDetailBloc>().add(FetchQuizHistory());
   }
 }
 bool get _isBottom{
   if(!_scrollController.hasClients) return false;
   final maxScroll = _scrollController.position.maxScrollExtent;
   final currentScroll = _scrollController.offset;
   return currentScroll >= (maxScroll * 0.9);
 }

 @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizDetailBloc, QuizDetailState>(
  builder: (context, state) {
    if(state is QuizDetailLoaded || state is QuizDetailLoadMore){
      final history = state is QuizDetailLoaded ? (state as QuizDetailLoaded).quizResults
      :(state as QuizDetailLoadMore).quizResults;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Details'),
          backgroundColor: Colors.lightBlue,
        ),
        body:  _buildContent(context, history),
        bottomNavigationBar: _buildStartQuizButton(context),

      );
    }
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(),));


  },
);
  }

  Widget _buildContent(BuildContext context, List<QuizResultResponse> quizResults) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Header
          _buildQuizHeader(),

          // Quiz Info
          _buildQuizInfo(),

          // Quiz Stats
          _buildQuizStats(quizResults),

          // Quiz History
          _buildQuizHistory(quizResults),
          BlocBuilder<QuizDetailBloc, QuizDetailState>(
            builder: (context, state) {
              if(state is QuizDetailLoadMore){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          )
          

        ],
      ),
    );
  }
 Widget _buildStartQuizButton(BuildContext context) {
   return Container(
     padding: const EdgeInsets.all(16),
     margin: const EdgeInsets.only(bottom: 16),
     child: ElevatedButton(
       onPressed: () {
         // Navigate to quiz taking page
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
           return QuizScreen(quiz:widget.quiz);
         }));
       },
       style: ElevatedButton.styleFrom(
         backgroundColor: Colors.blue.shade800,
         foregroundColor: Colors.white,
         padding: const EdgeInsets.symmetric(vertical: 16),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12),
         ),
         minimumSize: Size(double.infinity, 54),
       ),
       child: const Text(
         'Start Quiz',
         style: TextStyle(
           fontSize: 18,
           fontWeight: FontWeight.bold,
         ),
       ),
     ),
   );
 }
  Widget _buildQuizHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quiz.quizName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.quiz.description,
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
            value: '${widget.quiz.questions.length} questions',
          ),
          _buildInfoRow(
            icon: Icons.timer,
            title: 'Time Limit',
            value: widget.quiz.timeLimitMinutes != null ? '${widget.quiz.timeLimitMinutes} minutes' : 'No time limit',
          ),
          _buildInfoRow(
            icon: Icons.check_circle_outline,
            title: 'Passing Score',
            value: widget.quiz.passingScore != null ? '${widget.quiz.passingScore}%' : 'Not specified',
          ),
          _buildInfoRow(
            icon: Icons.calendar_today,
            title: 'Created',
            value: widget.quiz.createdAt != null ? _formatDate(widget.quiz.createdAt!) : 'Not available',
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

  Widget _buildQuizStats(List<QuizResultResponse> quizResults) {
    // Calculate average score from history
    double averageScore = quizResults.isEmpty
        ? 0
        : quizResults.map((e) => e.score).reduce((a, b) => a + b) / quizResults.length;

    // Calculate best score
    double bestScore = quizResults.isEmpty
        ? 0
        : quizResults.map((e) => e.score).reduce((a, b) => a > b ? a : b);

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
                  value: '${quizResults.length}',
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

  Widget _buildQuizHistory(List<QuizResultResponse> quizResults) {
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
          quizResults.isEmpty
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
                itemCount: quizResults.length,
                itemBuilder: (context, index) {
                  final result = quizResults[index];
                  return _buildHistoryCard(result);
                },
              ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(QuizResultResponse result) {
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
                'Attempt #${result.attemptNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: result.passed ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.passed ? 'PASSED' : 'FAILED',
                  style: TextStyle(
                    color: result.passed ? Colors.green.shade800 : Colors.red.shade800,
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
                value: _formatDate(result.submissionDate),
                icon: Icons.calendar_today,
              ),
              _buildAttemptDetail(
                label: 'Score',
                value: '${result.score.toStringAsFixed(1)}%',
                icon: Icons.score,
              ),
              _buildAttemptDetail(
                label: 'Result ID',
                value: '#${result.resultId}',
                icon: Icons.assignment,
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.score / 100,
              backgroundColor: Colors.grey.shade200,
              color: _getScoreColor(result.score),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Correct answers: ${result.correctAnswers} out of ${result.totalQuestions}',
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



  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.amber;
    return Colors.red;
  }
}