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
      final quizResults = await quizRepository.getAllQuizResultsByQuizId(quiz.quizId,page: _currentPage,pageSize: _pageSize);
      emit(QuizDetailLoaded(quizResults: quizResults,hasMax: quizResults.length < _pageSize));
      print('fetch lan dau');
    }
    else if(state is QuizDetailLoaded){
      print('fetch lan 2');
      final currentState = state as QuizDetailLoaded;
      if(currentState.hasMax) return;
      //
      emit(QuizDetailLoadMore(quizResults: currentState.quizResults, hasMax: currentState.hasMax));
      //fetch more data
      print('Fetch more data');

      await Future.delayed(const Duration(seconds: 1));

      _currentPage++;
      final newResult = await quizRepository.getAllQuizResultsByQuizId(quiz.quizId,page: _currentPage,pageSize: _pageSize);

      return emit(QuizDetailLoaded(quizResults: List.of(currentState.quizResults)..addAll(newResult), hasMax: newResult.length< _pageSize));
    }

  }
}
