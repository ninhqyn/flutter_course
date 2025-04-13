class InputValidators {
  static final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp _emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
  );

  /// Validate user name (chỉ chữ cái và số)
  static String validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'User name không được để trống';
    }

    if (!_usernameRegExp.hasMatch(username)) {
      return 'User name chỉ được chứa chữ cái và số';
    }

    return '';
  }

  /// Validate email
  static String validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email không được để trống';
    }

    if (!_emailRegExp.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    return '';
  }

  /// Validate password (ít nhất 8 ký tự, gồm chữ thường, chữ hoa và số)
  static String validatePassword(String? password) {

    if (password == null || password.isEmpty) {
      return 'Password không được để trống';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password phải chứa ít nhất một chữ hoa';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password phải chứa ít nhất một chữ thường';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password phải chứa ít nhất một chữ số';
    }
    if (password.length < 8) {
      return 'Password phải có ít nhất 8 ký tự';
    }





    return '';
  }

  /// Validate confirm password
  static String validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Vui lòng nhập lại password';
    }

    if (password != confirmPassword) {
      return 'Password không khớp';
    }

    return '';
  }
}