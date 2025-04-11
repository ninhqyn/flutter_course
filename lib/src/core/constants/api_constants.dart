class ApiConstants{
  static const String baseUrl ='10.0.2.2:7287';

  //Course
  static const String courses ='/api/Course';

  static const String courseByCategory ='/api/Course/category';
  static const String courseNew ='/api/Course/new';
  static const String courseFavorite ='/api/Course/favorites';
  static const String courseFilter = '/api/Course/filter';
  static const String userCourse = '/api/Course/user-courses';
  static const String checkEnrollment = '/api/Course/check-enrollment';
  //Category
  static const String category='api/Category';

  //Skill
  static const String skill ='/api/Skill';

  //Instructor
  static const String instructor ='/api/Instructor';
  static const String instructorCourse ='/api/Instructor/course';

  //Module
  static const String module ='/api/Module';
  static const String moduleUser ='/api/Module/user';

  //Rating
  static const String rating = '/api/Rating';
  static const String ratingTotal = '/api/Rating/total';
  static const String ratingCourse = '/api/Rating/course';
  //Auth
  static const String authLogin = '/api/Auth/login';
  static const String authVerifyToken ='/api/Auth/verify-token';
  static const String authRefreshToken ='api/Auth/refresh-token';


  //User
  static const String user ='/api/User';

  //Quiz
  static const String quiz = '/api/Quiz';
  static const String quizByCourse = '/api/Quiz/course';

  //Lesson
  static const String lessonProgress = '/api/Lesson/progress';

}