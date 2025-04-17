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
  QuizDetailBloc({
    required this.quiz,
    required this.quizRepository
}) : super(QuizDetailInitial()) {
    on<FetchQuizHistory>(_onFetchQuizHistory);
  }
  Future<void> _onFetchQuizHistory(FetchQuizHistory event,Emitter<QuizDetailState> emit) async{
    emit(QuizDetailLoading());
    final quizResults = await quizRepository.getAllQuizResultsByQuizId(quiz.quizId);
    emit(QuizDetailLoaded(quizResults: quizResults));
  }
}
