class FormValidator {
  static String? validateEmail(String? val) {
    if (val == null) {
      return "Email field cannot be empty";
    } else if (val.isEmpty) {
      return "Email field cannot be empty";
    } else if (valEmaill(val)) {
      return null;
    } else {
      return "Please enter valid email address";
    }
  }

  static String? validatePassword(String? val) {
    if (val == null) {
      return "Password field cannot be empty";
    } else if (val.isEmpty) {
      return "Password field cannot be empty";
    } else if (val.length < 8) {
      return "Password must be at least 8 character long";
    } else {
      return null;
    }
  }

  static String? validateName(String? val) {
    if (val == null) {
      return "Name field cannot be empty";
    } else if (val.isEmpty) {
      return "Name field cannot be empty";
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null) {
      return "Phone number field cannot be empty";
    } else if (val.isEmpty) {
      return "Phone number field cannot be empty";
    } else if (val.length != 10) {
      return "Phone number must be 10 digit long";
    } else {
      return null;
    }
  }

  static String? validateFieldNotEmpty(String? val, String fieldName) {
    if (val == null) {
      return "$fieldName field cannot be empty";
    } else if (val.isEmpty) {
      return "$fieldName field cannot be empty";
    } else {
      return null;
    }
  }

  static bool valEmaill(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
