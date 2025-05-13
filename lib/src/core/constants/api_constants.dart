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
  static const String courseByInstructorId = '/api/Course/instructor';
  static const String enrollCourseFree = '/api/Course/enroll-free';
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
  static const String register ='api/Auth/register';
  static const String verifyCode ='api/Auth/verify-code';
  static const String resendVerification='api/Auth/resend-verification';
  static const String forgotPassword ='api/Auth/forgot-password';


  //User
  static const String user ='/api/User';

  //Quiz
  static const String quiz = '/api/Quiz';
  static const String quizByCourse = '/api/Quiz/course';
  static const String quizResult = '/api/Quiz/quiz-result';
  static const String getAllQuizResult ='/api/Quiz/GetAll/quiz-result';

  //Lesson
  static const String lessonProgress = '/api/Lesson/progress';

  //Cart
  static const String cart ='/api/Cart';
  static const String addToCart ="/api/Cart/add";
  static const String removeCart ='/api/Cart/remove';
  static const String getCartItem ='/api/Cart';
  static const String clearCart ='/api/Cart/clear';
  static const String checkCart ='/api/Cart/check';

  //Payment
  static const String payment = "/api/payments";
  static const String getAllPayment="/api/payments/history";

}