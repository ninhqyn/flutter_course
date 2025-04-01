import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/src/core/routes/routes_name.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:learning_app/src/data/repositories/user_repository.dart';

import 'package:learning_app/src/data/services/auth_api_client.dart';
import 'package:learning_app/src/data/data_scources/auth_local_data_source.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

import 'package:learning_app/src/data/repositories/instructor_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/data/repositories/rating_repository.dart';
import 'package:learning_app/src/data/repositories/skill_repository.dart';

import 'package:learning_app/src/data/services/instructor_service.dart';
import 'package:learning_app/src/data/services/module_service.dart';
import 'package:learning_app/src/data/services/quiz_service.dart';
import 'package:learning_app/src/data/services/rating_service.dart';
import 'package:learning_app/src/data/services/skill_service.dart';
import 'package:learning_app/src/data/services/user_service.dart';




import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/routes/routes.dart';
import 'src/data/repositories/category_repository.dart';
import 'src/data/repositories/course_repository.dart';
import 'src/data/services/category_api_client.dart';
import 'src/data/services/course_service.dart';
import 'src/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'src/features/view_course/bloc/course_by_category/course_by_category_bloc.dart';
import 'src/features/view_course/bloc/explore/explore_bloc.dart';
import 'src/features/view_course/bloc/search/search_bloc.dart';




class App extends StatefulWidget {
  const App({super.key, required this.sf});
  final SharedPreferences sf;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final CourseRepository _courseRepository;
  late final CategoryRepository _categoryRepository;
  late final InstructorRepository _instructorRepository;
  late final SkillRepository _skillRepository;
  late final ModuleRepository _moduleRepository;
  late final RatingRepository _ratingRepository;
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final QuizRepository _quizRepository;
  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(authService: AuthService(), authLocalDataSource: AuthLocalDataSource(widget.sf));
    _courseRepository = CourseRepository(courseService: CourseService(_authRepository));
    _categoryRepository =
        CategoryRepository(categoryApiClient: CategoryApiClient());
    _skillRepository = SkillRepository(skillService: SkillService());
    _instructorRepository = InstructorRepository(instructorService: InstructorService());
    _moduleRepository = ModuleRepository(moduleService: ModuleService(_authRepository));
    _ratingRepository = RatingRepository(ratingService: RatingService());
    _userRepository = UserRepository(userService: UserService(_authRepository));
    _quizRepository = QuizRepository(quizService: QuizService());

  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _courseRepository,
        ),
        RepositoryProvider(
          create: (context) => _categoryRepository,
        ),
        RepositoryProvider(
          create: (context) => _instructorRepository,
        ),
        RepositoryProvider(
          create: (context) => _skillRepository,
        ),
        RepositoryProvider(
          create: (context) => _moduleRepository,
        ),
        RepositoryProvider(
          create: (context) => _ratingRepository,
        ),
        RepositoryProvider(
          create: (context) => _authRepository,
        ),
        RepositoryProvider(
          create: (context) => _userRepository,
        ),
        RepositoryProvider(
          create: (context) => _quizRepository,
        ),

      ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) {  // Đúng
              return ExploreBloc(
                  courseRepository: _courseRepository,
                  categoryRepository: _categoryRepository
              );
            }),
            BlocProvider(create: (_) {  // Đúng
              return CourseByCategoryBloc(courseRepository: _courseRepository);
            }),
            BlocProvider(create: (_) {  // Đúng
              return SearchBloc(
                  categoryRepository: _categoryRepository,
                  courseRepository: _courseRepository
              );
            }),
            BlocProvider(create: (_) {  // Đúng
              return AuthBloc(authRepository: _authRepository);
            }),
          ],
          child: const AppView(),
        )

    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        child = DevicePreview.appBuilder(context, child);
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print('state:$state');
            switch (state.status) {
              case AuthStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.myHomePage,
                      (route) => false,
                );
                break;
              case AuthStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.loginPage,
                      (route) => false,
                );
                break;
              case AuthStatus.unknown:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.splashPage,
                      (route) => false,
                );
                break;
              default:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.loginPage,
                      (route) => false,
                );
            }
          },
          child: child,
        );
      },
      title: 'Course Demo',
      theme: ThemeData(
          fontFamily: 'Cabin'
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.splashPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}