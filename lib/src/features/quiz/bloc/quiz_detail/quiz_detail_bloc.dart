import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:meta/meta.dart';

part 'quiz_detail_event.dart';
part 'quiz_detail_state.dart';

class QuizDetailBloc extends Bloc<QuizDetailEvent, QuizDetailState> {

  final Quiz quiz;
  final QuizRepository quizRepository;
  int _currentPage = 1;
  static const int _pageSize = 5;
  QuizDetailBloc({
    required this.quiz,
    required this.quizRepository
}) : super(QuizDetailInitial()) {
    on<FetchQuizHistory>(_onFetchQuizHistory);
  }
  Future<void> _onFetchQuizHistory(FetchQuizHistory event,Emitter<QuizDetailState> emit) async{
    if(state is QuizDetailInitial){
      emit(QuizDetailLoading());
      final quizResults = await quizRepository.getAllQuizResultsByQuizId(quiz.quizId);
      emit(QuizDetailLoaded(quizResults: quizResults,hasMax: quizResults.length < _pageSize));
    }
    if(state is QuizDetailLoaded){
      //hasMax ?
      final currentState = state as QuizDetailLoaded;
      if(currentState.hasMax) return;


      //
      emit(QuizDetailLoadMore(quizResults: currentState.quizResults, hasMax: currentState.hasMax));
      //fetch more data
      print('Fetch more data');

      await Future.delayed(const Duration(seconds: 1));

      _currentPage++;
     // final newCourses = await _fetchCourses(event.constant);

      return emit(QuizDetailLoaded(quizResults: currentState.quizResults, hasMax: false));
    }

  }
  // Future<List<QuizResultResponse>> _fetchQuizHistory() async {
  //
  // }
}
