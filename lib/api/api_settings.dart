class ApiSettings {
  static const String _baseurl = 'https://app.ht12.ly/api/';
  static const String register = '${_baseurl}auth/local/register';
  static const String verifyPhoneNumber = '${_baseurl}auth/verify';
  static const String login = '${_baseurl}auth/local';
  static const String privacyPolicy = '${_baseurl}privacy-policy';
  static const String termsAndConditions = '${_baseurl}terms-and-condition';
  static const String about = '${_baseurl}about';
  static const String deleteAccount = '${_baseurl}users/:id';
  static const String home = '${_baseurl}categories';
  static const String subCategory =
      '${_baseurl}sub-categories?{filters[category][\$eq]=}&&{populate=}';
  static const String bookList =
      '${_baseurl}courses?{filters[sub_category][\$eq]=}&&{populate=}';
  static const String courseDetails =
      '${_baseurl}courses/:documentId?{populate=}';
  static const String allCourses = '${_baseurl}courses?{populate=}';
  static const String enrolledCourse = '${_baseurl}courses/:id';
  static const String getEnrolledCourse =
      '${_baseurl}courses?{filters[enrolled_users][\$eq]=}&populate=*';
  static const String getAllQuizzes =
      '${_baseurl}quizzes?{filters[course][documentId][\$eq]=}&{populate[questions][populate]=*}';

  static const String search =
      '${_baseurl}/courses?{filters[sub_category][\$eq]=}&{filters[title][\$contains]=}';
  static const String completeLessons = '${_baseurl}curricula/:id';

  static const String submitAnswers = '${_baseurl}user-answers';
  static const String addDeviceForNotification = '${_baseurl}notification-tokens';
// static const String verification = '${_baseurl}auth/activate';
// static const String forgetPassword = '${_baseurl}auth/forget-password';
// static const String resetPassword = '${_baseurl}auth/reset-password';
// static const String resetCurrentPassword = '${_baseurl}auth/change-password';
// static const String login = '${_baseurl}auth/login';
// static const String logout = '${_baseurl}auth/logout';
// static const String home = '${_baseurl}home';
// static const String categories = '${_baseurl}categories';
// static const String subCategories = '${_baseurl}categories/{id}';
// static const String product = '${_baseurl}sub-categories/{id}';
// static const String productDetails = '${_baseurl}products/{id}';
// static const String productRate = '${_baseurl}products/rate';
// static const String productFavorite = '${_baseurl}favorite-products';
// static const String AddressRead = '${_baseurl}addresses/{id}';
// static const String cities = '${_baseurl}cities';
// static const String contactUs = '${_baseurl}contact-requests';
// static const String orders = '${_baseurl}orders/{id}';
// static const String faqs = '${_baseurl}faqs';
// static const String offer = '${_baseurl}offers';
// static const String payment = '${_baseurl}payment-cards/{id}';
}
