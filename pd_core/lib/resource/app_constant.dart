import 'package:flutter/foundation.dart';

class AppConstants {

  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction  = kReleaseMode;

  static bool isDriverTest  = false;
  static bool isUnitTest  = false;
  
  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';
  
  static const String keyGuide = 'keyGuide';
  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String email = 'emailUser';
  static const String pass = 'passUser';

  static const String recentlySearchKey = 'recently_search_key';

  static const String theme = 'AppTheme';
  static const String locale = 'locale';

  static const basicAuthPrefixHeader = 'Basic';
  static const protectedAuthenticationHeaderPrefix = 'Bearer';
  static const authorizationHeader = 'Authorization';

  static const String not_update = 'not_update';
  static const String login = 'auth';

  static const Duration timesToFetchCommonDataAgain = Duration(days: 3);

  static const errorHappened = 'Đã có lỗi xảy ra';
  static const errorHappenedTryAgain = "$errorHappened, vui lòng thử lại sau.";

  //
  static const String user_name_input_hint = 'Enter email';
  static const String password_input_hint = 'Enter password';

  static const String user_name_input = 'Email';
  static const String password_input = 'Password';

  static const String agree = 'OK';
  static const String cancel = 'Huỷ bỏ';

  static const String signUp = 'Đăng ký';
  static const String signOut = 'Đăng xuất';

  static const String featureInDevelopment = 'Chức năng đang phát triển';

  static const String logo_app = 'https://meterpreter.org/wp-content/uploads/2018/09/flutter.png';

  static const String datePattern = 'd/M/y';
  static const String apiDatePattern = 'y-M-d';

  static const String timePattern = 'HH:mm';

  static const int otpLength = 6;

  static const int minPasswordLength = 6;

  // Api

  static const int refecthApiThreshold = 3;

  static const int bussinessAreaSelectionThreshold = 5;

  static const int limitOfListDataLengthForEachRequest = 20;

  static const int timeToAbleToSendOtpAgain = 50;

  static const int inputDebounceTimeInMilliseconds = 440;

  static const int nextPageThreshold = 3;

  // static const int maxNumberOfMessagesFromRecruiterIfTheyActivelySendMessage = 3;
  static const int maxNumberOfMessagesFromRecruiterIfTheyActivelySendMessage = 0;

  static final List<int> scanRadiusInKilometer =
  List.generate(10, (index) => (index + 1) * 2);

  static const List<String> supportImageTypes = [
    'jpeg',
    'jpg',
    'png',
  ];

  static const List<String> supportNonImageFileTypes = [
    'txt',
    'docx',
    'zip',
    'rar',
    'pptx',
    'pdf',
    'doc',
    'xls',
    'xlsx',
    'ppt',
    'gdoc',
    'gsheet',
    'json',
    'html',
  ];

  static const double maxNonImageFileSizeInMb = 10;

  static const List<String> supportAllFileTypes = [
    ...supportImageTypes,
    ...supportNonImageFileTypes,
  ];
}

class ImageConstant {

  static const String logo_app = 'assets/images/ic_logo.png';
  static const String ic_empty_box = 'assets/images/ic_empty_box.png';
  static const String ic_empty_box_blue = 'assets/images/ic_empty_box_blue.png';
  static const String ic_user = 'assets/images/user.png';
  static const String ic_place_holder_image = 'assets/images/place_holder_image_new.png';
  static const String ic_place_holder_product = 'assets/images/placeholder.png';
  static const String ic_place_holder_basic= 'assets/images/placeholder_image.png';
  static const String ic_taobao = 'assets/images/ic_taobao.png';
  static const String ic_1688 = 'assets/images/ic_1688.png';
  static const String ic_tmall = 'assets/images/ic_tmall.png';

}
